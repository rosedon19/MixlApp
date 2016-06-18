//
//  UserAcceptedVenueViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UserAcceptedVenueViewController.h"

@interface UserAcceptedVenueViewController ()

@end

@implementation UserAcceptedVenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) initView{
    _btnUseNow.layer.borderWidth = 3.0f;
    _btnUseNow.layer.cornerRadius = 4.0f;
    _btnUseNow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if ([_venueImage isEqual:[NSNull null]]){
        [_imgVenue setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }else{
        [commonUtils setImageViewAFNetworking:_imgVenue withImageUrl:_venueImage withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    }

    NSString *imageVoucher = [_offerInfo objectForKey:@"image"];
    if ([_venueImage isEqual:[NSNull null]]){
        [_imgVoucher setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }else{
        [commonUtils setImageViewAFNetworking:_imgVoucher withImageUrl:imageVoucher withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    }
    
    NSString *voucherName = [_offerInfo objectForKey:@"title"];
    _lblVoucherName.text = voucherName;
    _lblVenueName.text = _venueName;
    //NSString *price = [_voucherInfo objectForKey:@"fname"];
    NSString *price = @"FREE";
    _lblPrice.text = price;
    NSString *time = [NSString stringWithFormat:@"00:%@:00", [_offerInfo objectForKey:@"valid_until"]];
    _lblRemainTime.text = time;
    NSString *code = [_offerInfo objectForKey:@"voucher_code"];
    _lblVoucherCode.text = _voucher;
    
}

- (IBAction)useNowClicked:(id)sender {
   
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_voucher forKey:@"voucher"];
    [paramDic setObject:_inviteId forKey:@"invite_id"];
    [self claimedVoucher:paramDic];
    
}

- (void)claimedVoucher:(NSMutableDictionary *)dic {
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(claimed:) toTarget:self withObject:dic];
}

- (void) claimed:(id) params {
    
    NSLog(@"Claimed mark request:------->%@", params);
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_CLAIM withJSON:(NSMutableDictionary *) params];
    
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        NSLog(@"Claimed mark Response:------->%@", result);
        int flag = [str intValue];
        if(flag == 0) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UserSearchViewController* userSearchViewController =
            (UserSearchViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
            userSearchViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
            [self.navigationController pushViewController:userSearchViewController animated:YES];
        
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
