//
//  UserReceiveOffersViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserReceiveOffersViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgVenue;
@property (weak, nonatomic) IBOutlet UILabel *lblVenueName;
@property (weak, nonatomic) IBOutlet UILabel *lblOfferName;

@property (strong, nonatomic) NSString* offerId;
@property (strong, nonatomic) NSString* venueId;
@property (strong, nonatomic) NSString* inviteId;


@end
