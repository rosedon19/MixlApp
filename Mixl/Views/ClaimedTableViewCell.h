//
//  ClaimedTableViewCell.h
//  Mixl
//
//  Created by Jose on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClaimedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblOfferName;

@end
