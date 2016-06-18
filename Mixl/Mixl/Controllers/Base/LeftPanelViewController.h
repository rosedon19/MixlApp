//
//  LeftPanelViewController.h
//  DomumLink
//
//  Created by Branislav on 1/15/15.
//  Copyright (c) 2015 Petr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftPanelViewController : UIViewController <SliderPanelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menuPages;

@property (nonatomic, strong) IBOutlet UIView *containerView, *topView;
@property (nonatomic, strong) IBOutlet UIImageView *userPhotoImageView;
@property (nonatomic, strong) IBOutlet UILabel *userName;
   
@end
