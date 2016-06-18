//
//  UsersViewViewController.m
//  Mixl
//
//  Created by Branislav on 4/19/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UsersViewViewController.h"

@interface UsersViewViewController ()

@end

@implementation UsersViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView{
    _btnAddList.layer.borderWidth = 3.0f;
    _btnAddList.layer.cornerRadius = 4.0f;
    _btnAddList.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _lblUserName.text = [NSString stringWithFormat:@"%@ %@", [self.userInfo objectForKey:@"firstname"], [self.userInfo objectForKey:@"lastname"]];
    NSArray *bithday = [[self.userInfo objectForKey:@"date_of_birth"] componentsSeparatedByString:@"-"];
    [_lblUserAge setText:[NSString stringWithFormat:@"Age: %@", [commonUtils ageCount:[bithday objectAtIndex:0]]]];
    if([[self.userInfo  objectForKey:@"gender"] isEqualToString:@"m"]){
        _lblUserGender.text = @"Gender: Male";
    }
    else{
        _lblUserGender.text = @"Gender: Female";
    }
    _txtUserAbout.text = [self.userInfo objectForKey:@"description"];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    images = [self.userInfo objectForKey:@"images"];
    if (images.count != 0) {
        NSString* avatarImageURL = [images objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgUserPic setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgUserPic withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [_imgUserPic setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }

}

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addListClicked:(id)sender {
    //add friend api
    if([self.userInfo objectForKey:@"id"] != nil){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[self.userInfo objectForKey:@"id"] forKey:@"friend_user_id"];
        [self requestFriendUser:paramDic];
    }
    else{
        [commonUtils showVAlertSimple:@"Warning" body:@"Please select the friend" duration:1.4];
    }
}

- (void)requestFriendUser:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:@"Sending..." type:0];
    [NSThread detachNewThreadSelector:@selector(requestFriend:) toTarget:self withObject:dic];
}

- (void) requestFriend:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_FRIEND withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSArray *msg = (NSArray *)[resObj objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
        }
    } else {
        
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

@end
