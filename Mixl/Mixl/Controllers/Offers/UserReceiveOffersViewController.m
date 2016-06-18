//
//  UserReceiveOffersViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UserReceiveOffersViewController.h"
#import "UserAcceptedVenueViewController.h"

@interface UserReceiveOffersViewController (){
    
    NSDictionary* offerInfo;
    NSDictionary* venueInfo;
    NSString* avatarImageURL;
}
@end

@implementation UserReceiveOffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     offerInfo = [[NSDictionary alloc] init];
    [self initData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) initData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_offerId forKey:@"offer_id"];
    NSLog(@"---- offer_id Request of Find Offer: %@", dic);
    // Api call Nearby People
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
    [[ServerConnect sharedManager] GET:API_URL_OFFER withParams:dic onSuccess:^(id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------User Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            NSMutableDictionary *offer = [[NSMutableDictionary alloc] init];
            offer = [result objectForKey:@"offer"];
            offerInfo =offer;
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
            [dic1 setObject:_venueId forKey:@"id"];
            NSLog(@"---- offer_id Request of Find Offer: %@", dic);

            [[ServerConnect sharedManager] GET:API_URL_USER withParams:dic1 onSuccess:^(id json) {
                
                NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
                NSLog(@"----------User Response Result:\n%@", result);
                NSString *str = [result objectForKey:@"error"];
                int flag = [str intValue];
                if(flag == 0) {
                    
                    NSMutableArray *users = [[NSMutableArray alloc] init];
                    users = [result objectForKey:@"users"];
                    for(NSMutableDictionary* user in users){
                        venueInfo = user;
                    }
                } else {
                    NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                    NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                    if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the venue sent the offer";
                }
                [self initView];
                
            } onFailure:^(NSInteger statusCode, id json) {
                [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
            }];
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find offer";
        }
        //[self initView];
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];

}
- (void) initView{
    
    _lblOfferName.text = [NSString stringWithFormat:@"Your Offer: %@", [offerInfo objectForKey:@"title"]];
    _lblVenueName.text = [venueInfo objectForKey:@"businessname"];
    NSMutableArray* images = [[NSMutableArray alloc] init];
    images = [venueInfo objectForKey:@"images"];
    if (images.count != 0) {
        avatarImageURL = [images objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgVenue setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgVenue withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [_imgVenue setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }

}

- (IBAction)acceptClicked:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_inviteId forKey:@"invite_id"];
    [paramDic setObject:@"1" forKey:@"accept"];
    [self acceptInviteUser:paramDic];
    
    }

- (IBAction)declineClicked:(id)sender {
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_inviteId forKey:@"invite_id"];
    [paramDic setObject:@"0" forKey:@"accept"];
    [self acceptInviteUser:paramDic];

    
}

- (void)acceptInviteUser:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(acceptInvite:) toTarget:self withObject:dic];
}

- (void) acceptInvite:(id) params {
    
    NSLog(@"Accept/Deny Received Offer params(in User Side):------->%@", params);
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_USER_ACCEPT_INVITE withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        NSLog(@"Accept/Deny Received Offer Response:------->%@", result);
        int flag = [str intValue];
        if(flag == 0) {
            if([[params objectForKey:@"accept"] isEqualToString:@"1"]){
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UserAcceptedVenueViewController* userAcceptedVenueViewController =
                (UserAcceptedVenueViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserAcceptedVenueVC"];
                userAcceptedVenueViewController.offerInfo = offerInfo;
                userAcceptedVenueViewController.venueImage = avatarImageURL;
                userAcceptedVenueViewController.venueName = [venueInfo objectForKey:@"businessname"];
                userAcceptedVenueViewController.inviteId = _inviteId;
                userAcceptedVenueViewController.voucher = [[result objectForKey:@"invite"] objectForKey:@"voucher"];
                [self.navigationController pushViewController:userAcceptedVenueViewController animated:YES];

            }
            else{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UserSearchViewController* userSearchViewController =
                (UserSearchViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
                userSearchViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
                [self.navigationController pushViewController:userSearchViewController animated:YES];
                
            }
            
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
