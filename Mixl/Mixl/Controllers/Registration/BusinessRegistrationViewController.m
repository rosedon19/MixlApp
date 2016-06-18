//
//  BusinessRegistrationViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "BusinessRegistrationViewController.h"

@interface BusinessRegistrationViewController () 

@end

@implementation BusinessRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initView {
    
    _viewComponent.layer.borderWidth = 2.0f;
    _viewComponent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTerms.layer.borderWidth = 2.0f;
    _viewTerms.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewPolicy.layer.borderWidth = 2.0f;
    _viewPolicy.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnDone.layer.borderWidth = 2.0f;
    _btnDone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.swTerms.on = NO;
    self.swPolicy.on = NO;
    
}

- (IBAction)onSWTerms:(id)sender {
    //[UserInformation sharedInstance].receiveMessage = self.swTerms.on;
}

- (IBAction)onSWPolicy:(id)sender {
    //[UserInformation sharedInstance].receiveMessage = self.swPolicy.on;
}

- (IBAction)doneClicked:(id)sender {
    // sign up
    [_txtBusinessName resignFirstResponder];
    [_txtAddress resignFirstResponder];
    [_txtZipcode resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
    
    if(self.isLoadingUserBase) return;
    
    if([commonUtils isFormEmpty:[@[_txtBusinessName.text, _txtAddress.text, _txtZipcode.text,_txtEmail.text, _txtPassword.text, _txtConfirmPassword.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
    } else if([_txtBusinessName.text length] > 20) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Business name is too long" duration:1.2];
    } else if(![commonUtils validateEmail:_txtEmail.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format." duration:1.2];
    } else if([_txtPassword.text length] < 6 || [_txtPassword.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length should be 6 to 10." duration:1.2];
    } else if(![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password confirm does not match." duration:1.2];
    } else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:@"v" forKey:@"type"];
        [paramDic setObject:_txtBusinessName.text forKey:@"businessname"];
        [paramDic setObject:_txtAddress.text forKey:@"address"];
        [paramDic setObject:_txtZipcode.text forKey:@"zipcode"];
        [paramDic setObject:_txtEmail.text forKey:@"email"];
        //[paramDic setObject:[commonUtils md5:self.userPasswordTextField.text] forKey:@"user_password"];
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
            [self requestAPISignUp:paramDic];
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
                [self requestAPISignUp:paramDic];
            }];
        }
        
    }
    
}

#pragma mark - API Request - User Sign Up
- (void)requestAPISignUp:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Registering..." type:0];
    [NSThread detachNewThreadSelector:@selector(requestDataSignUp:) toTarget:self withObject:dic];
}
- (void)requestDataSignUp:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
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
            
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateLocationManager];

            NSLog(@"----------current venue info (sign up) : %@", appController.currentUser);
            [self venuenavToMainView];

        } else {
            NSArray *msg = (NSArray *)[resObj objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
            _txtBusinessName.text = @"";
            _txtAddress.text = @"";
            _txtZipcode.text = @"";
            _txtEmail.text = @"";
            _txtPassword.text = @"";
            _txtConfirmPassword.text = @"";
            
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
