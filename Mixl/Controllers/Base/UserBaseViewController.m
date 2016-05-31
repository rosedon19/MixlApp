//
//  WFUserBaseViewController.m
//  Woof
//
//  Created by Branislav on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "UserBaseViewController.h"

@interface UserBaseViewController ()

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
    if([[appController.currentUser objectForKey:@"user"] objectForKey:@"id"] != nil) {
        NSLog(@"----------current info of logged in user: %@", appController.currentUser);
        if([[[appController.currentUser objectForKey:@"user"] objectForKey:@"type"] isEqualToString:@"u"]){
            MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
            [self.navigationController pushViewController:panelController animated:YES];
            return;
        }
        else{
            VenueMySideViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"venuesidePanel"];
            [self.navigationController pushViewController:panelController animated:YES];
            return;
        }

    }

    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
        [commonUtils removeUserDefault:@"logged_out"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        //[self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    self.isLoadingUserBase = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

#pragma mark - Nagivate Events
- (void) navToMainView {
    appController.currentMenuTag = @"1";
    MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
    [self.navigationController pushViewController:panelController animated:YES];

}

#pragma mark - Nagivate Events
- (void) venuenavToMainView {
    appController.currentMenuTag = @"1";
    VenueMySideViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"venuesidePanel"];
    [self.navigationController pushViewController:panelController animated:YES];
    
}

@end
