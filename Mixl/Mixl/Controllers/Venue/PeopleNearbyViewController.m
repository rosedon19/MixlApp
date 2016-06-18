//
//  PeopleNearbyViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "PeopleNearbyViewController.h"
#import "CurrentOffersCollectionViewCell.h"
#import "OffersTableViewCell.h"

@interface PeopleNearbyViewController ()
{
    int selectedIndex;
    NSMutableArray *offeredUsers;
    NSString* searchRadius;
    NSString* longitude;
    NSString* latitude;
}
@end

@implementation PeopleNearbyViewController
@synthesize peoplesNearBy, offersList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    peoplesNearBy = appController.peoplesNearby;
    offersList = appController.offersList;
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo = [appController.currentUser objectForKey:@"preference"];
    searchRadius = [userInfo objectForKey:@"search_radius"];
    longitude = [commonUtils getUserDefault:@"currentLongitude"];
    latitude = [commonUtils getUserDefault:@"currentLatitude"];
    
    [self initView];
    
    if ([[commonUtils getUserDefault:@"offerChanged"] isEqualToString:@"1"])
    {
        [self initData];
    }
    if ([[commonUtils getUserDefault:@"settingChanged"] isEqualToString:@"1"])
    {
        [self initData1];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    [[ServerConnect sharedManager] GET:API_URL_OFFER withParams:nil onSuccess:^(id json) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------Offers Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            NSMutableArray *offers = [[NSMutableArray alloc] init];
            for(NSMutableDictionary *offer in [result objectForKey:@"offers"]){
                [offers addObject:offer];
            }
            appController.offersList = offers;
            offersList = appController.offersList;
            [commonUtils setUserDefault:@"offerChanged" withFormat:@"0"];
            [_tableViewOffers reloadData];
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the offers";
        }
        
    } onFailure:^(NSInteger statusCode, id json) {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
}

- (void) initData1
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
                    [appController.peoplesNearby addObject:profilePeople];
                }
                peoplesNearBy = appController.peoplesNearby;
                [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
                
                for(int i = 0; i < [peoplesNearBy count]; i++){
                    [offeredUsers addObject:@"0"];
                }
                [_conllectionViewPeople reloadData];
            
            }else {
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
            

- (void) initView{
    
    selectedIndex = 0;
    _viewCurrentOffers.hidden = YES;
    _btnDone.layer.borderWidth = 2.0f;
    _btnDone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnDone.layer.cornerRadius = 3.0f;
    
    offeredUsers = [[NSMutableArray alloc] init];
    for(int i = 0; i < [peoplesNearBy count]; i++){
        [offeredUsers addObject:@"0"];
    }
    
    [_tableViewOffers reloadData];
    [_conllectionViewPeople reloadData];
    
}
- (IBAction)allPeopleOfferSendClicked:(id)sender {
    for(int i = 0; i < offeredUsers.count; i++){
        [offeredUsers replaceObjectAtIndex:i withObject:@"1"];
    }
    [_conllectionViewPeople reloadData];
    NSMutableArray* idsPeople = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for(NSMutableDictionary* people in peoplesNearBy){
        NSString* userId = [people objectForKey:@"id"];
        [idsPeople addObject:userId];
    }
    
    NSString* offerId = [[offersList objectAtIndex:selectedIndex] objectForKey:@"id"];
    [dic setObject:idsPeople forKey:@"invitee_user_id"];
    [dic setObject:offerId forKey:@"offer_id"];
    NSLog(@"------all users offer invite requeset:\n%@", dic);
    [self requestInviteOffer:dic];

}

- (IBAction)currentOffersClicked:(id)sender {
   _viewCurrentOffers.hidden = NO;
}

- (IBAction)newOfferClicked:(id)sender {
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OffersViewController* offersViewController =
    (OffersViewController*) [storyboard instantiateViewControllerWithIdentifier:@"BusicessOffersVC"];
    offersViewController.offerIndex = 0;
    [self.navigationController pushViewController:offersViewController animated:YES];
}

- (IBAction)offerDoneClicked:(id)sender {
    _viewCurrentOffers.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [offersList count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OffersTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OffersCell"];
    
    NSMutableDictionary *dic = [offersList objectAtIndex:indexPath.row];
    
    [cell.lblOfferName setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]]];
    
    if (selectedIndex == indexPath.row) {
        [cell.imgOption setImage:[UIImage imageNamed:@"icon_clickcircle"]];
    }
    else{
        [cell.imgOption setImage:[UIImage imageNamed:@"icon_unclickcircle"]];
    }
    
    cell.btnView.tag = indexPath.row;
    [cell.btnView addTarget:self action:@selector(didSelectView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) didSelectView:(UIButton *) sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OffersViewController* offersViewController =
    (OffersViewController*) [storyboard instantiateViewControllerWithIdentifier:@"BusicessOffersVC"];
    offersViewController.offerIndex = (int)(sender.tag + 1);
    [self.navigationController pushViewController:offersViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = (int)indexPath.row;
    [_tableViewOffers reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma - mark
#pragma - mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [peoplesNearBy count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width) / 2.0;
    CGFloat height = width * 125 / 160;
    return CGSizeMake(width, height);
}

#pragma - mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CurrentOffersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CurrentOffersCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CurrentOffersCollectionViewCell alloc] init];
    }
    NSMutableDictionary *dic = [peoplesNearBy objectAtIndex:indexPath.row];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    images = [dic objectForKey:@"images"];
    if (images.count != 0) {
        NSString* avatarImageURL = [images objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [cell.imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:cell.imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [cell.imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }
    
    if([[offeredUsers objectAtIndex:indexPath.row] isEqualToString:@"1"]){
        cell.viewAlpha.alpha = 0.5;
    }
    else{
        cell.viewAlpha.alpha = 0;
    }
    
    cell.lblUserName.text = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"firstname"], [dic objectForKey:@"lastname"]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for(int i = 0; i < offeredUsers.count; i++){
        if(i == indexPath.row) [offeredUsers replaceObjectAtIndex:i withObject:@"1"];
    }
    [_conllectionViewPeople reloadData];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* people = [[NSMutableDictionary alloc] init];
    people = [peoplesNearBy objectAtIndex:indexPath.row];
    if([offersList count] == 0){
        [commonUtils showVAlertSimple:@"Warning" body:@"There is no selected offer! \n Please select the offer." duration:1.4];
    }
    else{
    NSString* offerId = [[offersList objectAtIndex:selectedIndex] objectForKey:@"id"];
    [dic setObject:[people objectForKey:@"id"] forKey:@"invitee_user_id"];
    [dic setObject:offerId forKey:@"offer_id"];
    [self requestInviteOffer:dic];
    }
}

- (void)requestInviteOffer:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:@"Sending..." type:0];
    [NSThread detachNewThreadSelector:@selector(requestInvite:) toTarget:self withObject:dic];
}

- (void)requestInvite:(id)params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_USER_INVITE withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            NSLog(@"-----Offer invite Response:\n%@", result);
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

@end
