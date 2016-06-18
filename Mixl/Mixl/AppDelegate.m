//
//  AppDelegate.m
//  Mixl
//
//  Created by Branislav on 4/6/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "AppDelegate.h"
#import "AGPushNoteView.h"
#import "Config.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    [FBLoginView class];
    //    [FBProfilePictureView class];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [self updateLocationManager];
    [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
    [commonUtils setUserDefault:@"offerChanged" withFormat:@"1"];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    if(launchOptions != nil && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    }
    
    return YES;
}

- (void)updateLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager setDistanceFilter:804.17f]; // Distance Filter as 0.5 mile (1 mile = 1609.34m)
    
    if(IS_OS_8_OR_LATER) {
        [_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
    if([commonUtils getUserDefault:@"flag_location_query_enabled"] != nil && [[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"]) {
        [self runTask:300];
    }
}

//run locationtrack task
-(void)runTask: (int) time{
    //check if application is in background mode
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(startTrackingBg) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)startTrackingBg{

    int time = 300;
    
    if(![commonUtils getUserDefault:@"currentLatitude"] || ![commonUtils getUserDefault:@"currentLongitude"]) {
        [self runTask:time];
    }
    else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"latitude"];
        [dic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"longitude"];
        
        NSLog(@"---- Location Request of location update(300): %@", dic);
        [NSThread detachNewThreadSelector:@selector(requestLocation:) toTarget:self withObject:dic];
    }
}

- (void) requestLocation:(id) params {
    
    int time = 300;
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_LOCATION_UPDATE withJSON:(NSMutableDictionary *) params];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            NSLog(@"-----Location messages: %@", (NSArray *)[resObj objectForKey:@"messages"]);
            if([[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"]) {
                [self runTask:time];
            }
            else{
                return;
            }
        }
    }
    else{
        NSArray *msg = (NSArray *)[resObj objectForKey:@"messages"];
        NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
        if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Error Location Update!";
        [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
        if([[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"]) {
            [self runTask:time];
        }
        else{
            return;
        }

    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_locationManager stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [_locationManager startUpdatingLocation];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [_locationManager startUpdatingLocation];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [FBSession.activeSession handleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [commonUtils setUserDefault:@"user_apns_id" withFormat:newToken];
    NSLog(@"My saved token is: %@", [commonUtils getUserDefault:@"user_apns_id"]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    appController.apnsMessage = [[NSMutableDictionary alloc] init];
    appController.apnsMessage = [[commonUtils removeNilValue:[userInfo objectForKey:@"info"]] mutableCopy];
    
    NSLog(@"APNS Info Fetched : %@", userInfo);
    NSLog(@"My Received Message : %@", appController.apnsMessage);
    
    NSString* alertMessage = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    [AGPushNoteView showWithNotificationMessage:alertMessage];
    [AGPushNoteView setMessageAction:^(NSString *message) {
        // Do something...
    }];
    
    [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DidReceivePush
                                                        object:self];

    
    int pushType = [[appController.apnsMessage objectForKey:@"push_type"] intValue];
    if(pushType == PUSH_USERINVITE){
        [commonUtils setUserDefault:@"aps_type" withFormat:@"2"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MySidePanelController *navroot = (MySidePanelController*) [mainStoryboard instantiateViewControllerWithIdentifier:@"sidePanel"];
        self.window.rootViewController = navroot;
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"0"];
    }else if(pushType == PUSH_USERINVITEACCEPT){
        
        [commonUtils setUserDefault:@"aps_type" withFormat:@"3"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MySidePanelController *navroot = (MySidePanelController*) [mainStoryboard instantiateViewControllerWithIdentifier:@"sidePanel"];
        self.window.rootViewController = navroot;
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"0"];
    }else if(pushType == PUSH_ACCEPTOFFER){
        [commonUtils setUserDefault:@"accepted_user" withFormat:[appController.apnsMessage objectForKey:@"invitee_user_id"]];
        [commonUtils setUserDefault:@"aps_type" withFormat:@"6"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        VenueMySideViewController *navroot = (VenueMySideViewController*) [mainStoryboard instantiateViewControllerWithIdentifier:@"venuesidePanel"];
        self.window.rootViewController = navroot;
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"0"];
    }else if(pushType == PUSH_CHATMESSAGE){
        [[NSNotificationCenter defaultCenter] postNotificationName:APP_DidReceiveMessagePush
                                                            object:self
                                                            userInfo:(NSDictionary*)appController.apnsMessage];
    }

    
    [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    
}



#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    //[commonUtils showAlert:@"Error" withMessage:@"Failed to Get Your Location"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        BOOL locationChanged = NO;
        if(![commonUtils getUserDefault:@"currentLatitude"] || ![commonUtils getUserDefault:@"currentLongitude"]) {
            locationChanged = YES;
        } else if(![[commonUtils getUserDefault:@"currentLatitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]] || ![[commonUtils getUserDefault:@"currentLongitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]]) {
            locationChanged = YES;
        }
        if(locationChanged) {
            
            [commonUtils setUserDefault:@"currentLatitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]];
            [commonUtils setUserDefault:@"currentLongitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]];


        }
    }

    [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
}

- (void)updateUserLocation {  //for update user's coordinate automatically
    NSString *msg = [NSString stringWithFormat:@"%@:%@", [commonUtils getUserDefault:@"currentLatitude"], [commonUtils getUserDefault:@"currentLongitude"]];
    [commonUtils showAlert:@"Location Updated" withMessage:msg];
}

@end
