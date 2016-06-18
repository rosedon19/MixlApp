//
//  FriendAcceptViewController.m
//  Mixl
//
//  Created by Branislav on 5/18/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "FriendAcceptViewController.h"

@interface FriendAcceptViewController (){
    
    NSDictionary* wantedUserInfo;
}
@end

@implementation FriendAcceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wantedUserInfo = [[NSDictionary alloc] init];
    [self initData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) initData{
    
    NSMutableDictionary *dicUser = [[NSMutableDictionary alloc] init];
    [dicUser setObject:_friendRequestUserId forKey:@"id"];
    NSLog(@"---- UserId Request of Find User: %@", dicUser);
        // Api call Nearby People
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
                    wantedUserInfo = user;
                }
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

- (void) initView{
    
    _lblWantedUserName.text = [NSString stringWithFormat:@"%@ wants to be friend with you.", [wantedUserInfo objectForKey:@"firstname"]];
    NSMutableArray* images = [[NSMutableArray alloc] init];
    images = [wantedUserInfo objectForKey:@"images"];
    if (images.count != 0) {
        NSString* avatarImageURL = [images objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgWantedUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgWantedUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [_imgWantedUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }

}

- (IBAction)acceptClicked:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_friendRequestUserId forKey:@"friend_user_id"];
    [paramDic setObject:@"1" forKey:@"user_accept"];
    [self acceptFriendUser:paramDic];

}

- (IBAction)declineClicked:(id)sender {

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_friendRequestUserId forKey:@"friend_user_id"];
    [paramDic setObject:@"0" forKey:@"user_accept"];
    [self acceptFriendUser:paramDic];
}

- (void)acceptFriendUser:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(acceptFriend:) toTarget:self withObject:dic];
}

- (void) acceptFriend:(id) params {
    
    NSLog(@"Accept/Deny Friend params:------->%@", params);
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_FRIEND withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        NSLog(@"Accept/Deny Received friend request Response:------->%@", result);
        int flag = [str intValue];
        if(flag == 0) {
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UserSearchViewController* userSearchViewController =
            (UserSearchViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
            userSearchViewController.tapType = SIDEBAR_FRIENDSNEARBY_ITEM;
            [self.navigationController pushViewController:userSearchViewController animated:YES];
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
