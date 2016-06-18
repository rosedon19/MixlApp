//
//  ManageSettingViewController.m
//  Mixl
//
//  Created by Branislav on 4/7/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ManageSettingViewController.h"

@interface ManageSettingViewController (){
    int searchRadius;
    int ageMin;
    int ageMax;
    NSString* searchRadiusT;
    NSString* ageMinT;
    NSString* ageMaxT;
    NSString* friendGender;
    NSString* whoSee;
    NSString* whoContact;
    NSString* friendRequest;
    NSString* inviteUsers;
}

@end

@implementation ManageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
    [self initView];
}

- (void) initData{
    NSMutableDictionary *userSettings = [[NSMutableDictionary alloc] init];

    userSettings = [appController.currentUser objectForKey:@"preference"];
    searchRadius = [[userSettings objectForKey:@"search_radius"] intValue];
    ageMin = [[userSettings objectForKey:@"age_range_min"] intValue];
    ageMax = [[userSettings objectForKey:@"age_range_max"] intValue];
    friendGender = [userSettings objectForKey:@"friend_gender"];
    whoSee = [userSettings objectForKey:@"who_can_see_me"];
    whoContact = [userSettings objectForKey:@"who_can_contact_me"];
    friendRequest = [userSettings objectForKey:@"accept_friend_request"];
    inviteUsers = [userSettings objectForKey:@"accept_invites"];
    
    searchRadiusT = [NSString stringWithFormat:@"%d",searchRadius];
    ageMinT = [NSString stringWithFormat:@"%d",ageMin];
    ageMaxT = [NSString stringWithFormat:@"%d",ageMax];
}

- (void) initView {
    
    [_btnSeeAllCheckbox setImage:[UIImage imageNamed:@"icon_uncheckbox"] forState:UIControlStateNormal];
    [_btnSeeAllCheckbox setImage:[UIImage imageNamed:@"icon_checkbox"] forState:UIControlStateSelected];
    [_btnSeeFriendsCheckbox setImage:[UIImage imageNamed:@"icon_uncheckbox"] forState:UIControlStateNormal];
    [_btnSeeFriendsCheckbox setImage:[UIImage imageNamed:@"icon_checkbox"] forState:UIControlStateSelected];
    [_btnContactAllCheckbox setImage:[UIImage imageNamed:@"icon_uncheckbox"] forState:UIControlStateNormal];
    [_btnContactAllCheckbox setImage:[UIImage imageNamed:@"icon_checkbox"] forState:UIControlStateSelected];
    [_btnContactFriendsCheckbox setImage:[UIImage imageNamed:@"icon_uncheckbox"] forState:UIControlStateNormal];
    [_btnContactFriendsCheckbox setImage:[UIImage imageNamed:@"icon_checkbox"] forState:UIControlStateSelected];
    
    _sliderRadius.value = searchRadius;
    _lblRadius.text = [NSString stringWithFormat:@"%dmi.",searchRadius];
    [self configureStandardSlider];
    if([friendGender isEqualToString:@"a"]) _segGander.selectedSegmentIndex = 0;
    else{
        if([friendGender isEqualToString:@"m"]) _segGander.selectedSegmentIndex = 1;
        else _segGander.selectedSegmentIndex = 2;
    }
    
    if([whoSee isEqualToString:@"a"]){
        _btnSeeAllCheckbox.selected = YES;
        _btnSeeFriendsCheckbox.selected = NO;
    }
    else{
        if([whoSee isEqualToString:@"f"]){
            _btnSeeAllCheckbox.selected = NO;
            _btnSeeFriendsCheckbox.selected = YES;
        }
        else
        {
            _btnSeeAllCheckbox.selected = NO;
            _btnSeeFriendsCheckbox.selected = NO;
        }
    }
    
    if([whoContact isEqualToString:@"a"]){
        _btnContactAllCheckbox.selected = YES;
        _btnContactFriendsCheckbox.selected = NO;
    }
    else{
        if([whoContact isEqualToString:@"f"]){
            _btnContactAllCheckbox.selected = NO;
            _btnContactFriendsCheckbox.selected = YES;
        }
        else
        {
            _btnContactAllCheckbox.selected = NO;
            _btnContactFriendsCheckbox.selected = NO;
        }
    }
    
    if ([friendRequest isEqualToString:@"1"]) {
        _swFriendRequest.on = YES;
    }
    else{
        _swFriendRequest.on = NO;
    }
    
    if ([inviteUsers isEqualToString:@"1"]) {
        _swInvitesUsers.on = YES;
    }
    else{
        _swInvitesUsers.on = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark -
#pragma mark - Standard Slider

- (void) configureStandardSlider
{
    self.standardSlider.lowerValue = (float) ageMin / 100;
    self.standardSlider.upperValue = (float) ageMax / 100;
    _lblAgeRange.text = [NSString stringWithFormat:@"%d-%d.",(int)((float)self.standardSlider.lowerValue * 100),(int)((float)self.standardSlider.upperValue * 100)];
}

- (IBAction)radiusSlider:(UISlider *)sender {
    self.navigationController.sidePanelController.allowLeftSwipe = NO;
    searchRadius = [sender value];
    searchRadiusT = [NSString stringWithFormat:@"%d",searchRadius];
    _lblRadius.text = [NSString stringWithFormat:@"%dmi.",searchRadius];
}

- (IBAction)ageRangeSlider:(NMRangeSlider*)sender
{   self.navigationController.sidePanelController.allowLeftSwipe = NO;
    ageMinT = [NSString stringWithFormat:@"%d",(int)((float)self.standardSlider.lowerValue * 100)];
    ageMaxT = [NSString stringWithFormat:@"%d",(int)((float)self.standardSlider.upperValue * 100)];
    _lblAgeRange.text = [NSString stringWithFormat:@"%@-%@.",ageMinT, ageMaxT];
}

- (IBAction)onGenderChanged:(id)sender {
    int m_Gender = (int)_segGander.selectedSegmentIndex;
    switch (m_Gender) {
        case 0:
            friendGender = @"a";
            break;
        case 1:
            friendGender = @"m";
            break;
        case 2:
            friendGender = @"f";
            break;
        default:
            break;
    }
}

- (IBAction)onSeeAllCheckBoxToggle:(id)sender
{
    _btnSeeAllCheckbox.selected = !_btnSeeAllCheckbox.selected;
    _btnSeeFriendsCheckbox.selected = !_btnSeeAllCheckbox.selected;
}

- (IBAction)onSeeFriendsCheckBoxToggle:(id)sender
{
    _btnSeeFriendsCheckbox.selected = !_btnSeeFriendsCheckbox.selected;
    _btnSeeAllCheckbox.selected = !_btnSeeFriendsCheckbox.selected;
}

- (IBAction)onContactAllCheckBoxToggle:(id)sender
{
    _btnContactAllCheckbox.selected = !_btnContactAllCheckbox.selected;
    _btnContactFriendsCheckbox.selected = !_btnContactAllCheckbox.selected;
}

- (IBAction)onContactFriendsCheckBoxToggle:(id)sender
{
    _btnContactFriendsCheckbox.selected = !_btnContactFriendsCheckbox.selected;
    _btnContactAllCheckbox.selected = !_btnContactFriendsCheckbox.selected;
}

- (IBAction)onFriendRequest:(id)sender {
   
}

- (IBAction)onInvitesUsers:(id)sender {

}

- (IBAction)onShareMixlClick:(id)sender
{
    [self defaultShare];
}

- (IBAction)onDoneClick:(id)sender
{
    // Settings Update
    [self onSaveSettings];
    
}

- (IBAction)onDeleteAccountClick:(id)sender
{

    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Deleting..." type:0];
    [[ServerConnect sharedManager] POST:API_URL_SETTINGS_DELETE withParams:nil onSuccess:^(id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        if (json != nil) {
            NSDictionary *result = (NSDictionary *)json;
            NSDecimalNumber *status = [result objectForKey:@"error"];
            if([status intValue] == 0) {
                
                NSLog(@"--------Delete Response:\n%@", result);
                [commonUtils removeUserDefaultDic:@"current_user"];
                appController.currentUser = [[NSMutableDictionary alloc] init];
                [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
                [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"0"];
                [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                NSArray *msg = (NSArray *)[json objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please complete entire form";
                [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
            }
        } else {
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
        }

        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        //[JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];

//    self.isLoadingBase = YES;
//    [JSWaiter ShowWaiter:self.view title:@"Deleting..." type:0];
//    [NSThread detachNewThreadSelector:@selector(requestAccountDelete:) toTarget:self withObject:nil];
}
- (void) requestAccountDelete :(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_SETTINGS_DELETE withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"error"];
        if([status intValue] == 0) {
            
            NSLog(@"--------Delete Response:\n%@", result);
            [commonUtils removeUserDefaultDic:@"current_user"];
            appController.currentUser = [[NSMutableDictionary alloc] init];
            [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
            [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"0"];
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
            [self.navigationController popToRootViewControllerAnimated:NO];
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

- (void)onSaveSettings{
    if(self.isLoadingBase) return;
    
    if(_btnSeeAllCheckbox.selected == YES){
        whoSee = @"a";
    }
    else{
        if(_btnSeeFriendsCheckbox.selected == YES){
            whoSee = @"f";
        }
        else{
            whoSee = @"n";
        }
    }
    
    if(_btnContactAllCheckbox.selected == YES){
        whoContact = @"a";
    }
    else{
        if(_btnContactFriendsCheckbox.selected == YES){
            whoContact = @"f";
        }
        else{
            whoContact = @"n";
        }
    }
    
    if(_swFriendRequest.on == YES){
        friendRequest = @"1";
    }
    else{
        friendRequest = @"0";
    }
    
    if(_swInvitesUsers.on == YES){
        inviteUsers = @"1";
    }
    else{
        inviteUsers = @"0";
    }
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[appController.currentUser objectForKey:@"user"] objectForKey:@"id"] forKey:@"user_id"];
        [dic setObject:searchRadiusT forKey:@"search_radius"];
        [dic setObject:ageMinT forKey:@"age_range_min"];
        [dic setObject:ageMaxT forKey:@"age_range_max"];
        [dic setObject:friendGender forKey:@"friend_gender"];
        [dic setObject:whoSee forKey:@"who_can_see_me"];
        [dic setObject:whoContact forKey:@"who_can_contact_me"];
        [dic setObject:friendRequest forKey:@"accept_friend_request"];
        [dic setObject:inviteUsers forKey:@"accept_invites"];
    
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
    
//        [[ServerConnect sharedManager] POST:API_URL_SETTINGS withParams:dic onSuccess:^(id json) {
//        
//            NSLog(@"setting web service result : %@", json);
//            [JSWaiter HideWaiter];
//            NSMutableDictionary *updateSettings = [NSMutableDictionary dictionaryWithDictionary:json];
//            
//            NSLog(@"---------------setting web service result : %@", updateSettings);
//            
//                } onFailure:^(NSInteger statusCode, id json) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//         }];

         [NSThread detachNewThreadSelector:@selector(requestUpdateSettings:) toTarget:self withObject:dic];
}

#pragma mark - request data user profile change
- (void) requestUpdateSettings:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_SETTINGS withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"error"];
        if([status intValue] == 0) {
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            
            userInfo = appController.currentUser;
            [userInfo setObject:[result objectForKey:@"preference"] forKey:@"preference"];
            appController.currentUser =  userInfo;
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            NSLog(@"------------user info updated setting : %@", appController.currentUser);
            [self performSelector:@selector(Done) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
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

- (void) Done{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserSearchViewController* userSearchViewController =
    (UserSearchViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
    userSearchViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
    [self.navigationController pushViewController:userSearchViewController animated:YES];
}


#pragma mark - App Share Function
- (void)defaultShare {
    NSString *texttoshare = @"I'm using Mixl!  It's free on Apple app store!";
    UIImage *imagetoshare = [UIImage imageNamed:@"Icon-76"];
    
    
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    
    //activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

@end
