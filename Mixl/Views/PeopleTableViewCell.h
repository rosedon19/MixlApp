//
//  PeopleTableViewCell.h
//  Mixl
//
//  Created by admin on 4/10/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgPeople;
@property (strong, nonatomic) IBOutlet UILabel *lblPeopleName;
@property (strong, nonatomic) IBOutlet UILabel *lblPeopleAge;
@property (strong, nonatomic) IBOutlet UILabel *lblPeopleLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnSendOffer;

@end
