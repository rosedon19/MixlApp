//
//  UserAcceptedVenueViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAcceptedVenueViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgVoucher;
@property (weak, nonatomic) IBOutlet UILabel *lblVoucherName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVenue;
@property (weak, nonatomic) IBOutlet UILabel *lblVenueName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainTime;
@property (weak, nonatomic) IBOutlet UILabel *lblVoucherCode;

@property (weak, nonatomic) IBOutlet UIButton *btnUseNow;

@property (strong, nonatomic) NSDictionary* offerInfo;
@property (strong, nonatomic) NSString*     venueImage;
@property (strong, nonatomic) NSString*     venueName;
@property (strong, nonatomic) NSString*     inviteId;
@property (strong, nonatomic) NSString*     voucher;

@end
