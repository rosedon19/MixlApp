//
//  LoginEmailViewController.m
//  Mixl
//
//  Created by admin on 4/7/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "LoginEmailViewController.h"
#import "UserSearchViewController.h"

@interface LoginEmailViewController ()

@end

@implementation LoginEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    
    _viewUserEmail.layer.cornerRadius = 3.0f;
    _viewUserEmail.layer.borderWidth = 1.5f;
    _viewUserEmail.layer.borderColor = [UIColor whiteColor].CGColor;
    _viewPassword.layer.cornerRadius = 3.0f;
    _viewPassword.layer.borderWidth = 1.5f;
    _viewPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnLogin.layer.cornerRadius = 3.0f;
    _btnLogin.layer.borderWidth = 1.5f;
    _btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIColor *color = [UIColor whiteColor];
    _txtUserEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];

    self.txtUserEmail.delegate = self;
    self.txtPassword.delegate = self;
    
}

- (IBAction)onLoginClicked:(id)sender {
    
    [_txtUserEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
 
    if(self.isLoadingUserBase) return;
    if([commonUtils isFormEmpty:[@[_txtUserEmail.text, _txtPassword.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete entire form" duration:1.2];
    } else if(![commonUtils validateEmail:_txtUserEmail.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format" duration:1.2];
    } else if([_txtPassword.text length] < 2 || [_txtPassword.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length must be between 6 and 10 characters" duration:1.2];
    } else {
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:_txtUserEmail.text forKey:@"email"];
        [paramDic setObject:_txtPassword.text forKey:@"password"];
        
        if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"latitude"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"longitude"];
        }
        else{
            [appController.vAlert doAlert:@"Notice" body:@"There is no your location info.\n Please Confirm location service and Try again!" duration:2.0f done:^(DoAlertView *alertView) {
                return;
            }];
            
        }
        
        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"io_token"];
            [self requestAPILogin:paramDic];
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
                [self requestAPILogin:paramDic];
            }];
        }
    }

}

- (void)requestAPILogin:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:@"Loging in..." type:0];
    [NSThread detachNewThreadSelector:@selector(requestDataLogin:) toTarget:self withObject:dic];
}

- (void) requestDataLogin:(id) params {
    
    NSDictionary *resObj = nil;
    NSLog(@"-----------User Login Param: %@", params);
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGIN withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            appController.currentUser = [NSMutableDictionary dictionaryWithDictionary:result];
            [commonUtils setUserDefault:@"authorized_token" withFormat:[[result objectForKey:@"user"] objectForKey:@"token"]];
            [commonUtils setUserDefault:@"userPassword" withFormat:_txtPassword.text];
            [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"1"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            NSLog(@"----------current info of logged in user: %@", appController.currentUser);
            
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateLocationManager];
            
            if([[[appController.currentUser objectForKey:@"user"] objectForKey:@"type"] isEqualToString:@"u"]){
                [self navToMainView];
            }
            else{
                [commonUtils setUserDefault:@"offerChanged" withFormat:@"1"];
                [self venuenavToMainView];
            }

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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
