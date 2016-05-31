//
//  ClaimedVouchersViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClaimedVouchersViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView *viewClaimedTab;
@property (strong, nonatomic) IBOutlet UIView *viewNotClaimedTab;
@property (strong, nonatomic) IBOutlet UILabel *lblClaimed;
@property (strong, nonatomic) IBOutlet UILabel *lblNotClaimed;

@property (strong, nonatomic) IBOutlet UIView *viewClaimed;
@property (strong, nonatomic) IBOutlet UIView *viewNotClaimed;

@property (strong, nonatomic) IBOutlet UITableView *tableClaimed;
@property (strong, nonatomic) IBOutlet UITableView *tableNotClaimed;

@property (nonatomic) int tapType;
@end
