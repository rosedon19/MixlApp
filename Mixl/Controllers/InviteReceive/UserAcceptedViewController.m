//
//  UserAcceptedViewController.m
//  Mixl
//
//  Created by Branislav on 4/19/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UserAcceptedViewController.h"

@interface UserAcceptedViewController (){
    
    NSDictionary* receiverUserInfo;
}
@end

@implementation UserAcceptedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData{
    
    int pushType = [[appController.apnsMessage objectForKey:@"push_type"] intValue];
    if(pushType == PUSH_USERINVITEACCEPT){
        
    NSString *receiverUserID = [appController.apnsMessage objectForKey:@"invitee_user_id"];
    
    NSMutableDictionary *dicUser = [[NSMutableDictionary alloc] init];
    [dicUser setObject:receiverUserID forKey:@"id"];
    NSLog(@"---- UserId Request of Find User: %@", dicUser);
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
    [[ServerConnect sharedManager] GET:API_URL_USER withParams:dicUser onSuccess:^(id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------User Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            NSMutableArray *users = [[NSMutableArray alloc] init];
            users = [result objectForKey:@"users"];
            for(NSMutableDictionary* user in users){
                receiverUserInfo = user;
            }
            appController.receiverUser = [NSMutableDictionary dictionaryWithDictionary:receiverUserInfo];
            [commonUtils setUserDefaultDic:@"receiver_user" withDic:appController.receiverUser];
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the user sent the friend request";
        }
        [self initView];
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
        
    }
    
}

- (void) initView{
    
    NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
    userProfile = [appController.currentUser objectForKey:@"user"];
    NSMutableArray* userImages = [[NSMutableArray alloc] init];
    userImages = (NSMutableArray *)[userProfile objectForKey:@"images"];
    if (userImages.count != 0) {
        NSString* avatarImageURL = [userImages objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgSender setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgSender withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [_imgSender setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }

    _lblAcceptedName.text = [NSString stringWithFormat:@"Invite accepted by %@!", [receiverUserInfo objectForKey:@"firstname"]];
    NSMutableArray* receiverimages = [[NSMutableArray alloc] init];
    receiverimages = [receiverUserInfo objectForKey:@"images"];
    if (receiverimages.count != 0) {
        NSString* avatarImageURL = [receiverimages objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgRecipient setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgRecipient withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [_imgRecipient setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }

}

- (IBAction)sendMessageClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController* chatViewController =
    (ChatViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserChatVC"];
    chatViewController.unreadMessage = @"3";
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (IBAction)keepSearchClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserSearchViewController* userSearchViewController =
    (UserSearchViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
    userSearchViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
    [self.navigationController pushViewController:userSearchViewController animated:YES];
}

@end
