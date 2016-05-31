//
//  ManageSettingViewController.h
//  Mixl
//
//  Created by Branislav on 4/7/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface ManageSettingViewController : BaseViewController <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NMRangeSlider *standardSlider;
@property (nonatomic, strong) IBOutlet UILabel*                 lblRadius;
@property (nonatomic, strong) IBOutlet UILabel*                 lblAgeRange;
@property (nonatomic, strong) IBOutlet UISegmentedControl*      segGander;
@property (nonatomic, strong) IBOutlet UIButton*                btnSeeAllCheckbox;
@property (nonatomic, strong) IBOutlet UIButton*                btnSeeFriendsCheckbox;
@property (nonatomic, strong) IBOutlet UIButton*                btnContactAllCheckbox;
@property (nonatomic, strong) IBOutlet UIButton*                btnContactFriendsCheckbox;
@property (nonatomic, strong) IBOutlet UISwitch*                swFriendRequest;
@property (nonatomic, strong) IBOutlet UISwitch*                swInvitesUsers;
@property (weak, nonatomic) IBOutlet UISlider *sliderRadius;

@end
