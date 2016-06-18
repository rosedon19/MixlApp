//
//  UserSearchViewController.m
//  Mixl
//
//  Created by Branislav on 4/10/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UserSearchViewController.h"
#import "UsersViewViewController.h"
#import "PeopleTableViewCell.h"
#import "FriendsCollectionViewCell.h"

@interface UserSearchViewController (){
    NSString* searchRadius;
    NSString* longitude;
    NSString* latitude;
    
}

@property (nonatomic, strong) NSMutableArray *peoplesNearBy, *Friends;

@end

@implementation UserSearchViewController
@synthesize peoplesNearBy, Friends;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    peoplesNearBy = appController.peoplesNearby;
    Friends = appController.Friends;
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo = [appController.currentUser objectForKey:@"preference"];
    searchRadius = [userInfo objectForKey:@"search_radius"];
    
    longitude = [commonUtils getUserDefault:@"currentLongitude"];
    latitude = [commonUtils getUserDefault:@"currentLatitude"];
    
    [self initView];
    
    if ([[commonUtils getUserDefault:@"settingChanged"] isEqualToString:@"1"])
    {
        [self initData];
    }
    
    
}


- (void) initData
{
    NSMutableDictionary *dicPeople = [[NSMutableDictionary alloc] init];
    [dicPeople setObject:@"people" forKey:@"type"];
    if(longitude && latitude){
    [dicPeople setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"longitude"];
    [dicPeople setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"latitude"];
    [dicPeople setObject:searchRadius forKey:@"search_radius"];
    
    NSLog(@"---- Location Request of Nearby People: %@", dicPeople);
    // Api call Nearby People
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
    [[ServerConnect sharedManager] GET:API_URL_NEARBY withParams:dicPeople onSuccess:^(id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------Nearby People Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            NSMutableArray *peoples = [[NSMutableArray alloc] init];
            appController.peoplesNearby = peoples;
            peoples = [result objectForKey:@"found"];
            for(NSMutableDictionary* people in peoples){
                NSMutableDictionary *profilePeople = [[NSMutableDictionary alloc] init];
                profilePeople = [people objectForKey:@"profile"];
                if([[profilePeople objectForKey:@"id"] isEqualToString:[[appController.currentUser objectForKey:@"user"] objectForKey:@"id"]]) continue;
                else [appController.peoplesNearby addObject:profilePeople];
            }
            
            peoplesNearBy = appController.peoplesNearby;
            
            NSMutableDictionary *dicFriend = [[NSMutableDictionary alloc] init];
            [dicFriend setObject:@"friends" forKey:@"type"];
            [dicFriend setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"longitude"];
            [dicFriend setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"latitude"];
            [dicFriend setObject:searchRadius forKey:@"search_radius"];
            
            NSLog(@"---- Location Request : %@", dicFriend);
            // Api call Friends
            self.isLoadingBase = YES;
            //[JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
            [[ServerConnect sharedManager] GET:API_URL_NEARBY withParams:dicFriend onSuccess:^(id json) {
                self.isLoadingBase = NO;
                //[JSWaiter HideWaiter];
                
                NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
                NSLog(@"----------Nearby Friends Response Result:\n%@", result);
                NSString *str = [result objectForKey:@"error"];
                int flag = [str intValue];
                if(flag == 0) {
                    
                    NSMutableArray *friends = [[NSMutableArray alloc] init];
                    appController.Friends = friends;
                    friends = [result objectForKey:@"found"];
                    for(NSMutableDictionary* friend in friends){
                        NSMutableDictionary *profileFriend = [[NSMutableDictionary alloc] init];
                        profileFriend = [friend objectForKey:@"profile"];
                        if([[profileFriend objectForKey:@"id"] isEqualToString:[[appController.currentUser objectForKey:@"user"] objectForKey:@"id"]]) continue;
                        else [appController.Friends addObject:profileFriend];
                    }
                    Friends = appController.Friends;
                    [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
//                    [_tablePeople reloadData];
//                    [_collectionFriends reloadData];
                    [self performSelector:@selector(initView) withObject:self afterDelay:1.0f];
                    
                } else {
                    NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                    NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                    if([stringMsg isEqualToString:@""]) stringMsg = @"Please complete entire form";
                }
                
            } onFailure:^(NSInteger statusCode, id json) {
                self.isLoadingBase = NO;
                //[JSWaiter HideWaiter];
                [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
            }];


        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Please complete entire form";
        }

    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
    }
}

- (void) initView {
    
    _viewSearch.layer.cornerRadius = 3.0f;
    _viewSearch.layer.borderWidth = 1.5f;
    _viewSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if(_tapType == 2)
    {
        [self showTap:YES];
    }
    else
    {
        [self showTap:NO];
    }
    
    [_tablePeople reloadData];
    [_collectionFriends reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTap:(BOOL)show {
    
    self.lblPeopleNearby.textColor = (show) ? [UIColor whiteColor]:UIColorFromRGB(0xF5F8EE);
    self.viewPeopleTab.backgroundColor = (show) ? UIColorFromRGB(0x55E0E0) : UIColorFromRGB(0x43C6DB);
    
    self.lblFriends.textColor = (show) ?  UIColorFromRGB(0xF5F8EE):[UIColor whiteColor];
    self.viewFriendsTab.backgroundColor = (show) ? UIColorFromRGB(0x43C6DB):UIColorFromRGB(0x55E0E0);
    
    _viewPeopleNearby.hidden = !show;
    _viewFriends.hidden = show;
    
}


- (IBAction)searchClicked:(id)sender {
    _lblSearch.hidden = YES;
    _btnSearch.hidden = YES;
    [_txtSearch becomeFirstResponder];
}

- (IBAction)onPeopleTapClicked:(id)sender {
    [self showTap:YES];
}

- (IBAction)onFriendsTapClicked:(id)sender {
    [self showTap:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [peoplesNearBy count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PeopleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
    
    NSMutableDictionary *dic = [peoplesNearBy objectAtIndex:indexPath.row];
    
    [cell.lblPeopleName setText:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"firstname"], [dic objectForKey:@"lastname"]]];
    NSArray *bithday = [[dic objectForKey:@"date_of_birth"] componentsSeparatedByString:@"-"];
    [cell.lblPeopleAge setText:[NSString stringWithFormat:@"Age: %@", [commonUtils ageCount:[bithday objectAtIndex:0]]]];
    int mile = [commonUtils calculateDistance:[latitude doubleValue] withSourceLong:[longitude doubleValue] withDestinationLat:[[dic objectForKey:@"latitude"] doubleValue]  withDestinationLong:[[dic objectForKey:@"longitude"] doubleValue]];
    [cell.lblPeopleLocation setText:[NSString stringWithFormat:@"%@ mi", [NSString stringWithFormat:@"%d", mile]]];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    images = [dic objectForKey:@"images"];
    if (images.count != 0) {
        NSString* avatarImageURL = [images objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [cell.imgPeople setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:cell.imgPeople withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [cell.imgPeople setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }
    
    cell.btnSendOffer.tag = indexPath.row;
    [cell.btnSendOffer addTarget:self action:@selector(selectedInvite:) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)selectedInvite:(UIButton*) sender{
    
    NSMutableDictionary *inviteUser = [peoplesNearBy objectAtIndex:sender.tag];
    
    if([inviteUser objectForKey:@"id"] != nil){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[inviteUser objectForKey:@"id"] forKey:@"invitee_user_id"];
        [self requestInviteUser:paramDic];
    }
    else{
        [commonUtils showVAlertSimple:@"Warning" body:@"Please select the user." duration:1.4];
    }
}

- (void)requestInviteUser:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:@"Sending..." type:0];
    [NSThread detachNewThreadSelector:@selector(requestInvite:) toTarget:self withObject:dic];
}

- (void) requestInvite:(id) params {
    
    NSLog(@"user invite request params:------->%@", params);
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_USER_INVITE withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            [commonUtils showVAlertSimple:@"Success!" body:@"You sent the Invite." duration:1.4];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UsersViewViewController* userViewViewController =
    (UsersViewViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UsersViewVC"];
    userViewViewController.userInfo = [peoplesNearBy objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:userViewViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([[UIScreen mainScreen] bounds].size.height) / 2.0 - 40;
}

#pragma - mark
#pragma - mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [Friends count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width) / 2.0;
    CGFloat height = width * 125 / 160;
    return CGSizeMake(width, height);
}

#pragma - mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiendsCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FriendsCollectionViewCell alloc] init];
    }
    NSMutableDictionary *dic = [Friends objectAtIndex:indexPath.row];
    
    [cell.lblName setText:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"firstname"], [dic objectForKey:@"lastname"]]];
    int mile = [commonUtils calculateDistance:[latitude doubleValue] withSourceLong:[longitude doubleValue] withDestinationLat:[[dic objectForKey:@"latitude"] doubleValue]  withDestinationLong:[[dic objectForKey:@"longitude"] doubleValue]];
    [cell.lblDistance setText:[NSString stringWithFormat:@"%@ mi", [NSString stringWithFormat:@"%d", mile]]];
    
    int onlinestae = [[dic objectForKey:@"online"] intValue];
    if ([[NSString stringWithFormat:@"%d", onlinestae] isEqualToString:@"1"]) {    //!= [NSNull null]
        [cell.imgStatus setImage:[UIImage imageNamed:@"icon_circlegreen"]];

    } else {
        cell.imgStatus.image = [UIImage imageNamed:@"icon_circlered"];
    }
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    images = [dic objectForKey:@"images"];
    if (images.count != 0 ) {
        NSString* avatarImageURL = [images objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [cell.imgFriend setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:cell.imgFriend withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [cell.imgFriend setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //current_selected = (int)indexPath.item;
    
    appController.receiverUser = [Friends objectAtIndex:indexPath.row];
    [commonUtils setUserDefaultDic:@"receiver_user" withDic:appController.receiverUser];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController* chatViewController =
    (ChatViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserChatVC"];
    chatViewController.unreadMessage = @"3";
    [self.navigationController pushViewController:chatViewController animated:YES];

}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self search:textField.text];
    return YES;
}

- (void) search:(NSString*)key {
    if (key.length > 0) {
        
        NSMutableDictionary *searchPeople = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *searchFriend = [[NSMutableDictionary alloc] init];
        
        [searchPeople setObject:@"people" forKey:@"type"];
        [searchFriend setObject:@"friends" forKey:@"type"];
        if([key rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound){
            [searchPeople setObject:key forKey:@"age"];
            [searchFriend setObject:key forKey:@"age"];
        }
        else{
            if([key isEqualToString:@"male"]){
                [searchPeople setObject:@"m" forKey:@"gender"];
                [searchFriend setObject:@"m" forKey:@"gender"];
            }
            else{
                if([key isEqualToString:@"female"]){
                    [searchPeople setObject:@"f" forKey:@"gender"];
                    [searchFriend setObject:@"f" forKey:@"gender"];
                }
                else{
                    [searchPeople setObject:key forKey:@"name"];
                    [searchFriend setObject:key forKey:@"name"];
                }
            }
        }
       
        
        NSLog(@"---- Request of Search People: %@", searchPeople);
        // Api call Nearby People
        
        [self requestSearch:searchPeople friendsParam:searchFriend];
    }
}

- (void) requestSearch:(id) params friendsParam: (id) friendsparams {
    
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Searching..." type:0];
    [[ServerConnect sharedManager] GET:API_URL_SEARCH withParams:params onSuccess:^(id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            NSLog(@"----------Search People Response Result:\n%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                
                NSMutableArray *peoples = [[NSMutableArray alloc] init];
                peoplesNearBy = peoples;
                peoples = [result objectForKey:@"found"];
                for(NSMutableDictionary* people in peoples){
                    NSMutableDictionary *profilePeople = [[NSMutableDictionary alloc] init];
                    profilePeople = [people objectForKey:@"profile"];
                    if([[profilePeople objectForKey:@"id"] isEqualToString:[[appController.currentUser objectForKey:@"user"] objectForKey:@"id"]]) continue;
                    else [peoplesNearBy addObject:profilePeople];
                }
                
                // Api call Friends
                self.isLoadingBase = YES;
                //[JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
                [[ServerConnect sharedManager] GET:API_URL_SEARCH withParams:friendsparams onSuccess:^(id json) {
                    self.isLoadingBase = NO;
                    //[JSWaiter HideWaiter];
                    
                    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
                    NSLog(@"----------Search Friends Response Result:\n%@", result);
                    NSString *str = [result objectForKey:@"error"];
                    int flag = [str intValue];
                    if(flag == 0) {
                        
                        NSMutableArray *friends = [[NSMutableArray alloc] init];
                        Friends = friends;
                        friends = [result objectForKey:@"found"];
                        for(NSMutableDictionary* friend in friends){
                            NSMutableDictionary *profileFriend = [[NSMutableDictionary alloc] init];
                            profileFriend = [friend objectForKey:@"profile"];
                            if([[profileFriend objectForKey:@"id"] isEqualToString:[[appController.currentUser objectForKey:@"user"] objectForKey:@"id"]]) continue;
                            else [Friends addObject:profileFriend];
                        }
                        
                        [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
                        [_tablePeople reloadData];
                        [_collectionFriends reloadData];
                        
                    } else {
                        NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                        NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                        if([stringMsg isEqualToString:@""]) stringMsg = @"Please complete entire form";
                    }
                    
                } onFailure:^(NSInteger statusCode, id json) {
                    self.isLoadingBase = NO;
                    //[JSWaiter HideWaiter];
                    [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
                }];
                
                
            } else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""]) stringMsg = @"Please complete entire form";
            }
            
        } onFailure:^(NSInteger statusCode, id json) {
            self.isLoadingBase = NO;
            [JSWaiter HideWaiter];
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
        }];

}

@end
