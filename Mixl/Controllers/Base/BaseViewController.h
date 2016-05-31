//
//  WFBaseViewController.h
//  Woof
//
//  Created by Branislav on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingBase;

@property (nonatomic, strong) IBOutlet UIView *topNavBarView, *containerView, *noContentView;
@property (nonatomic, strong) IBOutlet UIImageView *dot;

- (IBAction)menuClicked:(id)sender;
- (IBAction)menuBackClicked:(id)sender;

@end
