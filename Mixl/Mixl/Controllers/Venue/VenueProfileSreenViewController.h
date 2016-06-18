//
//  VenueProfileSreenViewController.h
//  Mixl
//
//  Created by Branislav on 4/21/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueProfileSreenViewController : BaseViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgVenue;
@property (weak, nonatomic) IBOutlet UILabel *lblVenueName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCityZipecode;
@property (weak, nonatomic) IBOutlet UITextView *txtVenueAbout;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeOffers;

@property (strong, nonatomic) NSDictionary* venueInfo;
@end
