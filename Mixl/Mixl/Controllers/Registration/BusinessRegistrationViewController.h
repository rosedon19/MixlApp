//
//  BusinessRegistrationViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessRegistrationViewController : UserBaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewComponent;
@property (strong, nonatomic) IBOutlet UIView *viewTerms;
@property (strong, nonatomic) IBOutlet UIView *viewPolicy;

@property (weak, nonatomic) IBOutlet UITextField *txtBusinessName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (nonatomic, strong) IBOutlet UISwitch*                swTerms;
@property (nonatomic, strong) IBOutlet UISwitch*                swPolicy;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@end
