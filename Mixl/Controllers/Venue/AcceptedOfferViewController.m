//
//  AcceptedOfferViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "AcceptedOfferViewController.h"

@interface AcceptedOfferViewController (){
    
    NSDictionary* receiverUserInfo;
}


@end

@implementation AcceptedOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    
        NSString *receiverUserID = [commonUtils getUserDefault:@"accepted_user"];
        
        NSMutableDictionary *dicUser = [[NSMutableDictionary alloc] init];
        [dicUser setObject:receiverUserID forKey:@"id"];
        NSLog(@"---- UserId Request of Find User: %@", dicUser);
        [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
        [[ServerConnect sharedManager] GET:API_URL_USER withParams:dicUser onSuccess:^(id json) {
        
            [JSWaiter HideWaiter];
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            NSLog(@"----------User Response Result:\n%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                
                NSMutableArray *users = [[NSMutableArray alloc] init];
                users = [result objectForKey:@"users"];
                for(NSMutableDictionary* user in users){
                    receiverUserInfo = user;
                }
            } else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the user sent the friend request";
            }
            [self initView];
            
        } onFailure:^(NSInteger statusCode, id json) {
            [JSWaiter HideWaiter];
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
        }];
}

- (void) initView{
    
    NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
    userProfile = [appController.currentUser objectForKey:@"user"];
    NSMutableArray* userImages = [[NSMutableArray alloc] init];
    userImages = (NSMutableArray *)[userProfile objectForKey:@"images"];
    if (userImages.count != 0) {
        NSString* avatarImageURL = [userImages objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgVenue setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgVenue withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    
    NSMutableArray* receiverimages = [[NSMutableArray alloc] init];
    receiverimages = [receiverUserInfo objectForKey:@"images"];
    if (receiverimages.count != 0) {
        NSString* avatarImageURL = [receiverimages objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgAcceptedUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgAcceptedUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    
    _lblTitle.text = [NSString stringWithFormat:@"%@ accept your offer", [receiverUserInfo objectForKey:@"firstname"]];
    
}
- (IBAction)viewVoucherClicked:(id)sender {
    int offerindex = -1;
    for(NSMutableDictionary *offer in appController.offersList){
        if([[offer objectForKey:@"id"] isEqualToString:[appController.apnsMessage objectForKey:@"offer_id"]]){
            offerindex = [appController.offersList indexOfObject:offer];
        }
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OffersViewController* offersViewController =
    (OffersViewController*) [storyboard instantiateViewControllerWithIdentifier:@"BusicessOffersVC"];
    offersViewController.offerIndex = offerindex + 1;
    [self.navigationController pushViewController:offersViewController animated:YES];
}

@end
