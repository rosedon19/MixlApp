//
//  WFIntroModalViewController.h
//  Woof
//
//  Created by Mac on 1/10/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFIntroModalViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

- (void)setIntroContent:(NSString *)content;

@end
