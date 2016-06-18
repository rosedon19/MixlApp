//
//  LoginViewController.m
//  Mixl
//
//  Created by admin on 4/6/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewFBSignin.layer.cornerRadius = 3.0f;
    _viewFBSignin.layer.borderWidth = 1.5f;
    _viewFBSignin.layer.borderColor = [UIColor whiteColor].CGColor;
    _viewF.layer.borderWidth = 1.5f;
    _viewF.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _viewLogin.layer.cornerRadius = 3.0f;
    _viewLogin.layer.borderWidth = 1.5f;
    _viewLogin.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFBSignInClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_photos"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in with token : @%@", result.token);
             if ([result.grantedPermissions containsObject:@"email"]) {
                 NSLog(@"result is:%@",result);
                 [self fetchUserInfo];
             }
         }
     }];

}

- (IBAction)onLoginClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    [self performSegueWithIdentifier:@"EmailLoginSegue" sender:nil];
}

- (IBAction)onRegisterClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    [self performSegueWithIdentifier:@"UserRegistrationSegue" sender:nil];
}

- (IBAction)onBusinessRegisterClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    [self performSegueWithIdentifier:@"VenueRegistrationSegue" sender:nil];
}

- (void)fetchUserInfo {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, gender, bio, location, friends, hometown, friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"facebook fetched info : %@", result);
                 
                 NSDictionary *temp = (NSDictionary *)result;
                 //NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                 NSMutableDictionary *userFBlogin = [[NSMutableDictionary alloc] init];
                
                 [userFBlogin setObject:[temp objectForKey:@"id"] forKey:@"fb_token"];
                 [userFBlogin setObject:[temp objectForKey:@"email"] forKey:@"email"];
              
                 if([commonUtils checkKeyInDic:@"first_name" inDic:[temp mutableCopy]]) {
                     [userFBlogin setObject:[temp objectForKey:@"first_name"] forKey:@"firstname"];
                 }
                 if([commonUtils checkKeyInDic:@"last_name" inDic:[temp mutableCopy]]) {
                     [userFBlogin setObject:[temp objectForKey:@"last_name"] forKey:@"lastname"];
                 }
                 
                 NSString *gender = @"m";
                 if([commonUtils checkKeyInDic:@"gender" inDic:[temp mutableCopy]]) {
                     if([[temp objectForKey:@"gender"] isEqualToString:@"female"]) gender = @"f";
                 }
                 [userFBlogin setObject:gender forKey:@"gender"];
                 
                 NSString *fbProfilePhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [temp objectForKey:@"id"]];
                 [userFBlogin setObject:fbProfilePhoto forKey:@"image1"];
                 
                 [userFBlogin setObject:@"u" forKey:@"type"];
                 
                 NSString *age = @"30";
                 if([commonUtils checkKeyInDic:@"age" inDic:[temp mutableCopy]]) {
                     age = [NSString stringWithFormat:@"%@", [temp objectForKey:@"age"]];
                 }
                 [userFBlogin setObject:age forKey:@"date_of_birth"];
                 
                 if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
                     [userFBlogin setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"latitude"];
                     [userFBlogin setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"longitude"];
                 }
                 else{
                     [appController.vAlert doAlert:@"Notice" body:@"There is no your location info.\n Please Confirm location service and Try again!" duration:2.0f done:^(DoAlertView *alertView) {
                         return;
                     }];
                     
                 }

                  if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
                      [userFBlogin setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"io_token"];

                      self.isLoadingUserBase = YES;
                      [JSWaiter ShowWaiter:self.view title:@"Signing in..." type:0];
                      //            [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:userInfo];
                      [self requestData:userFBlogin];

                  } else {
                      [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
                          
                          self.isLoadingUserBase = YES;
                          [JSWaiter ShowWaiter:self.view title:@"Signing in..." type:0];
                          // [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:userInfo];
                          [self requestData:userFBlogin];
                      }];
                  }
                 
             } else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}


#pragma mark - API Request - User Signup After FB Login
- (void) requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_FBLOGIN withJSON:(NSMutableDictionary *) params];
    
    self.isLoadingUserBase = NO;
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            appController.currentUser = [NSMutableDictionary dictionaryWithDictionary:result];
            [commonUtils setUserDefault:@"authorized_token" withFormat:[[result objectForKey:@"user"] objectForKey:@"token"]];
            [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"1"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            NSLog(@"current user : %@", appController.currentUser);
            
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateLocationManager];

            [self navToMainView];
            //[self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
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

@end
