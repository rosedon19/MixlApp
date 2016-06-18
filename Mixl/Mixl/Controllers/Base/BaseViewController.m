//
//  WFBaseViewController.m
//  Woof
//
//  Created by Branislav on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSMutableDictionary *receiverInfo;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([appController.receiverUser objectForKey:@"id"] == nil){
        _receiverInfo = [[NSMutableDictionary alloc] init];
        _receiverInfo = [commonUtils getUserDefaultDicByKey:@"receiver_user"];
        if([_receiverInfo objectForKey:@"id"] != nil) {
            appController.receiverUser = _receiverInfo;
        }
    }
    
    if(appController.latestMessageId == nil){
        appController.latestMessageId = [commonUtils getUserDefault:@"latest_message_id"];
    }
    
    if(![commonUtils checkKeyInDic:@"id" inDic:[appController.currentUser objectForKey:@"user"]] || ![commonUtils checkKeyInDic:@"images" inDic:[appController.currentUser objectForKey:@"user"]] || ![commonUtils checkKeyInDic:@"firstname" inDic:[appController.currentUser objectForKey:@"user"]]) {
        _userInfo = [[NSMutableDictionary alloc] init];
        _userInfo = [commonUtils getUserDefaultDicByKey:@"current_user"];
        if([[_userInfo objectForKey:@"user"] objectForKey:@"id"] != nil) {
            appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
           // [commonUtils setUserDefault:@"authorized_token" withFormat:[[_userInfo objectForKey:@"user"] objectForKey:@"token"]];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.isLoadingBase = NO;
    
    _dot = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 10, 10)];
    _dot.image = [UIImage imageNamed:@"ic_notify"];
    [self.view addSubview:_dot];
    _dot.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUnreadNotiStatus:)
                                                 name:APP_DidReceivePush
                                               object:nil];
}

#pragma mark - Did Receive Unread Message
- (void)updateUnreadNotiStatus:(NSNotification*) noti {
    _dot.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APP_DidReceivePush object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

# pragma Top Menu Events
- (IBAction)menuClicked:(id)sender {
    if(self.isLoadingBase) return;
    self.dot.hidden = YES;
    [self.sidePanelController showLeftPanelAnimated: YES];
}

- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
