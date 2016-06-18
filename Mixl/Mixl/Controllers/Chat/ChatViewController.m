//
//  ChatViewController.m
//  Mixl
//
//  Created by Branislav on 4/19/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import "MJRefresh.h"
#import "MJRefreshAutoFooter.h"
#import "MJRefreshFooter.h"
#import "MJRefreshHeader.h"
#import "MJRefreshComponent.h"


@interface ChatViewController (){
    
    NSMutableArray *_chatHistoryArray;
    NSString *_limit, *_allcount;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self registerNotifications];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    
    _txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtMessage.layer.borderWidth = 2.0f;
    _txtMessage.layer.cornerRadius = 3.0f;
    self.chatHistoryTable.delegate = self;
    self.chatHistoryTable.dataSource = self;
    _txtMessage.delegate = self;
    [self.btnSend setImage:[UIImage imageNamed:@"ic_send_disabled"] forState:UIControlStateNormal];
    self.btnSend.userInteractionEnabled = NO;
    
    if([appController.receiverUser objectForKey:@"id"] != nil){
        _lblChatUserName.text = [NSString stringWithFormat:@"%@ %@", [appController.receiverUser objectForKey:@"firstname"], [appController.receiverUser objectForKey:@"lastname"]];
    }
    else{
        _lblChatUserName.text = @"Jessy";
    }
}

- (void)initData {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    _chatHistoryArray = [[NSMutableArray alloc] init];
    
    if(![_unreadMessage isEqualToString:@"3"]){
        if([_unreadMessage isEqualToString:@"1"]){
            NSString* sender = [appController.apnsMessage objectForKey:@"sender"];
            [self checkSenderUser:sender];
            [commonUtils setUserDefault:@"latest_message_id" withFormat:[appController.apnsMessage objectForKey:@"message_id"]];
            appController.latestMessageId = [commonUtils getUserDefault:@"latest_message_id"];
        }
        
        if([appController.receiverUser objectForKey:@"id"] != nil){
            [self getChatHistory];
        }
        
    }
}

- (void) getChatHistory{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString* receiverId = [appController.receiverUser objectForKey:@"id"];
    NSString* latestMessageId = appController.latestMessageId;
    [dic setObject:receiverId forKey:@"friend_id"];
    [dic setObject:latestMessageId forKey:@"last_message_id"];
    NSLog(@"----------Chat History Messages Request:\n%@", dic);
    
    [[ServerConnect sharedManager] POST:API_URL_CHAT_HISTORY withParams:dic onSuccess:^(id json) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------Chat History Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            NSMutableArray *contents = [[NSMutableArray alloc] init];
            contents = [result objectForKey:@"contents"];
            NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* Message = [[NSMutableDictionary alloc] init];
            
            for(int i = (int)[contents count] - 1; i >= 0; i--){
                content = [contents objectAtIndex:i];
                if([[content objectForKey:@"receiver"] isEqualToString:receiverId]){
                    Message = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Me", @"Sender",
                                                           [content objectForKey:@"text"], @"Message",
                                                    [content objectForKey:@"sent_at"], @"SentOn", nil];
                }
                else{
                    Message = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Reciver", @"Sender",
                                                    [content objectForKey:@"text"], @"Message",
                                                    [content objectForKey:@"sent_at"], @"SentOn", nil];

                }
                [_chatHistoryArray insertObject:Message atIndex:0];
            }
            [self.chatHistoryTable reloadData];
            [self scrollToNewestMessage];
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the receive Message.";
        }
        [self initView];
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
    
}

- (void) receiveMessage:(NSNotification *) notification{
    NSDictionary *notiInfo = notification.userInfo;
    NSString* sender = [notiInfo objectForKey:@"sender"];
    
    [self checkSenderUser:sender];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:sender forKey:@"sender"];
    NSLog(@"----------Unread Messages Request:\n%@", dic);
    
    [[ServerConnect sharedManager] GET:API_URL_SEND_MESSAGE withParams:dic onSuccess:^(id json) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------Unread Messages Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            messages = [result objectForKey:@"chats"];
            NSMutableDictionary *revceiveM = [[NSMutableDictionary alloc] init];
            for(NSMutableDictionary* message in messages){
                if([[message objectForKey:@"id"] intValue] == [[notiInfo objectForKey:@"message_id"] intValue]){
                    revceiveM = message;
                    break;
                }
            }
            
            if([revceiveM count] != 0){
            
                NSMutableDictionary* receiveMessage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Receiver", @"Sender",
                                                       [revceiveM objectForKey:@"text"], @"Message",
                                                       [revceiveM objectForKey:@"sent_at"], @"SentOn", nil];
                [_chatHistoryArray insertObject:receiveMessage atIndex:0];
                [self.chatHistoryTable reloadData];
                [self scrollToNewestMessage];
                [commonUtils setUserDefault:@"latest_message_id" withFormat:[notiInfo objectForKey:@"message_id"]];
                appController.latestMessageId = [commonUtils getUserDefault:@"latest_message_id"];
           }
            else{
                [commonUtils showVAlertSimple:@"Warning!" body:@"Message is empty." duration:1.0];
            }
            
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Sorry, We can't find the receive Message.";
            [commonUtils showVAlertSimple:@"Warning!" body:stringMsg duration:1.0];

        }
        [self initView];
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];

}

- (void) checkSenderUser:(NSString*) sender{

    if(![sender isEqualToString:[appController.receiverUser objectForKey:@"id"]]){
        NSMutableDictionary *dicUser = [[NSMutableDictionary alloc] init];
        [dicUser setObject:sender forKey:@"id"];
        NSLog(@"---- UserId Request of Find User: %@", dicUser);
        
        [[ServerConnect sharedManager] GET:API_URL_USER withParams:dicUser onSuccess:^(id json) {
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            NSLog(@"----------User Response Result:\n%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                
                NSMutableDictionary *receiverUserInfo = [[NSMutableDictionary alloc] init];
                NSMutableArray *users = [[NSMutableArray alloc] init];
                users = [result objectForKey:@"users"];
                for(NSMutableDictionary* user in users){
                    receiverUserInfo = user;
                }
                appController.receiverUser = [NSMutableDictionary dictionaryWithDictionary:receiverUserInfo];
                [commonUtils setUserDefaultDic:@"receiver_user" withDic:appController.receiverUser];
                _lblChatUserName.text = [NSString stringWithFormat:@"%@ %@", [appController.receiverUser objectForKey:@"firstname"], [appController.receiverUser objectForKey:@"lastname"]];
                _chatHistoryArray = [[NSMutableArray alloc] init];
                
            } else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the user sent the friend request";
            }
            
        } onFailure:^(NSInteger statusCode, id json) {
            self.isLoadingBase = NO;
            [JSWaiter HideWaiter];
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
        }];
    }
    else{
        [commonUtils showVAlertSimple:@"Warning" body:@"We can't find the receiver." duration:1.0];
        return;
    }
}

- (void)onSendSuccess {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSLog(@"-----Receiver User Info:\n%@", appController.receiverUser);
    
    if([appController.receiverUser objectForKey:@"id"] != nil){
    NSString* receiverId = [appController.receiverUser objectForKey:@"id"];
    [dic setObject:receiverId  forKey:@"receiver"];
    [dic setObject:self.txtMessage.text forKey:@"text"];
    //[self sendMessage:dic];
    
    [[ServerConnect sharedManager] POST:API_URL_SEND_MESSAGE withParams:dic onSuccess:^(id json) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------Nearby Friends Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            int mId = (int)[result objectForKey:@"message_id"];
            [commonUtils setUserDefault:@"latest_message_id" withFormat:[NSString stringWithFormat:@"%d", mId]];
            appController.latestMessageId = [commonUtils getUserDefault:@"latest_message_id"];

            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = [formatter stringFromDate:[NSDate date]];
            NSMutableDictionary* sendMessage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Me", @"Sender",
                                                _txtMessage.text, @"Message",
                                                dateString, @"SentOn", nil];
            
            [_chatHistoryArray insertObject:sendMessage atIndex:0];
            [self.chatHistoryTable reloadData];
            [self scrollToNewestMessage];
            _txtMessage.text = @" ";
            [self textViewDidChange:_txtMessage];
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please check your internet connection status";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
        }
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        //[JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
    }
    else{
        [commonUtils showVAlertSimple:@"Warning" body:@"We can't find the receiver." duration:1.0];
    }
}

- (IBAction)sendClicked:(id)sender {

    [_txtMessage resignFirstResponder];
    if (_txtMessage.text.length > 0 && ![_txtMessage.text isEqualToString:@" "]) {
        [self scrollToNewestMessage];
        [self performSelector:@selector(onSendSuccess) withObject:nil afterDelay:0.5];
    }
    
}

- (IBAction)cameraClicked:(id)sender {
    
    UIActionSheet *alertCamera = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a picture",
                                  @"Select photos from camera roll", nil];
    alertCamera.tag = 1;
    [alertCamera showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) scrollToNewestMessage
{
    // The newest message is at the bottom of the table
    if (_chatHistoryArray.count > 0)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(_chatHistoryArray.count - 1) inSection:0];
        [self.chatHistoryTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return _chatHistoryArray.count ;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"MessageCellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    MessageTableViewCell* cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.clipsToBounds = YES;
    cell.contentView.clipsToBounds = YES;

    [cell setMessage:[_chatHistoryArray objectAtIndex:_chatHistoryArray.count - indexPath.row -1 ]];

        
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat heightCell;
    NSDictionary *message = [_chatHistoryArray objectAtIndex:_chatHistoryArray.count - indexPath.row -1];
    NSString* messagetxt = [message objectForKey:@"Message"];
    
   // if([[message objectForKey:@"Message"] rangeOfString:@"http://"].location == NSNotFound){
        if(messagetxt == nil) messagetxt = @" ";
        CGSize bubbleSize = [SpeechBubbleView sizeForText:messagetxt];
        heightCell = bubbleSize.height + 26;
    //}
//    else{
//        heightCell = 100;
//    }
    return heightCell;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self.btnSend setImage:[UIImage imageNamed:@"ic_send_disabled"] forState:UIControlStateNormal];
        self.btnSend.userInteractionEnabled = NO;
    } else {
        [self.btnSend setImage:[UIImage imageNamed:@"ic_send_enabled"] forState:UIControlStateNormal];
        self.btnSend.userInteractionEnabled = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}


// Setting up keyboard notifications.
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessage:)
                                                 name:APP_DidReceiveMessagePush object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint viewOrigin = self.viewBack.frame.origin;
    CGSize viewSize = self.viewBack.frame.size;
    viewSize.height = [[UIScreen mainScreen] bounds].size.height - viewOrigin.y - kbSize.height;
    [self.viewBack setFrame:CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height)];
    [self scrollToNewestMessage];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGPoint viewOrigin = self.viewBack.frame.origin;
    CGSize viewSize = self.viewBack.frame.size;
    viewSize.height = [[UIScreen mainScreen] bounds].size.height - viewOrigin.y;
    [self.viewBack setFrame:CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height)];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    switch (buttonIndex) {
            
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    NSLog(@"%ld , %ld", (long)actionSheet.tag , (long)buttonIndex);
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageSEL = info[UIImagePickerControllerEditedImage];
    
    NSMutableArray *imageData = [[NSMutableArray alloc] init];
    NSData *avatarData = UIImageJPEGRepresentation(imageSEL, 1.0);
    NSDictionary *avatar = @{@"fileType": @"image", @"name": @"image", @"fileName": @"image.jpg", @"data": avatarData, @"mimeType": @"image/jpg"};
    [imageData addObject:avatar];

    [JSWaiter ShowWaiter:self.view title:@"Sending..." type:0];
    [[ServerConnect sharedManager] UploadFiles:API_URL_UPLOAD_PHOTO withData:imageData withParams:nil onSuccess:^(id json){
        [JSWaiter HideWaiter];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"updated offer object--------%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            [self onSendImageSuccess:[result objectForKey:@"link"]];
        }else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please save again!";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
            
        }
    }onFailure:^(NSInteger statusCode, id json) {
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
}

- (void)onSendImageSuccess:(NSString*)imageLink {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSLog(@"-----Receiver User Info:\n%@", appController.receiverUser);
    
    if(appController.receiverUser != nil){
        NSString* receiverId = [appController.receiverUser objectForKey:@"id"];
        [dic setObject:receiverId  forKey:@"receiver"];
        [dic setObject:imageLink forKey:@"text"];
        //[self sendMessage:dic];
        
        [[ServerConnect sharedManager] POST:API_URL_SEND_MESSAGE withParams:dic onSuccess:^(id json) {
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            NSLog(@"----------Nearby Friends Response Result:\n%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                
                int mId = (int)[result objectForKey:@"message_id"];
                [commonUtils setUserDefault:@"latest_message_id" withFormat:[NSString stringWithFormat:@"%d", mId]];
                appController.latestMessageId = [commonUtils getUserDefault:@"latest_message_id"];
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* dateString = [formatter stringFromDate:[NSDate date]];
                NSMutableDictionary* sendMessage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Me", @"Sender",
                                                    imageLink, @"Message",
                                                    dateString, @"SentOn", nil];
                
                [_chatHistoryArray insertObject:sendMessage atIndex:0];
                [self.chatHistoryTable reloadData];
                [self scrollToNewestMessage];
//                _txtMessage.text = @" ";
                [self textViewDidChange:_txtMessage];
                
            } else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please check your internet connection status";
                [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
            }
            
        } onFailure:^(NSInteger statusCode, id json) {
            self.isLoadingBase = NO;
            //[JSWaiter HideWaiter];
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
        }];
        
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)sendMessage:(NSMutableDictionary *)dic {
    [NSThread detachNewThreadSelector:@selector(sendMessageRequest:) toTarget:self withObject:dic];
}

- (void) sendMessageRequest:(id) params {
    
    NSLog(@"send Message request params:------->%@", params);
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_SEND_MESSAGE withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        NSLog(@"send Message request Response:------->%@", result);
        int flag = [str intValue];
        if(flag == 0) {
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = [formatter stringFromDate:[NSDate date]];
            NSMutableDictionary* sendMessage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Me", @"Sender",
                                                _txtMessage.text, @"Message",
                                                dateString, @"SentOn", nil];
            
            [_chatHistoryArray insertObject:sendMessage atIndex:0];
            [self.chatHistoryTable reloadData];
            [self scrollToNewestMessage];
            _txtMessage.text = @" ";
            [self textViewDidChange:_txtMessage];
            
        } else {
            NSArray *msg = (NSArray *)[resObj objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please check your internet connection status";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
        }
    } else {
        
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}


@end
