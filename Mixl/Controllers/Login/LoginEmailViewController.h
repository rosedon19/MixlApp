//
//  LoginEmailViewController.h
//  Mixl
//
//  Created by admin on 4/7/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginEmailViewController : UserBaseViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView*      viewUserEmail;
@property (nonatomic, strong) IBOutlet UIView*      viewPassword;
@property (nonatomic, strong) IBOutlet UIButton*    btnLogin;

@property (weak, nonatomic) IBOutlet UITextField*   txtUserEmail;
@property (weak, nonatomic) IBOutlet UITextField*   txtPassword;

@end
