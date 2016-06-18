//
//  UserProfileViewController.h
//  Mixl
//
//  Created by Branislav on 4/6/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : BaseViewController<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewUserImage;

@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UIView *viewComponent;
@property (strong, nonatomic) IBOutlet UITableView *tableViewMonth;
@property (strong, nonatomic) IBOutlet UITableView *tableviewDay;
@property (strong, nonatomic) IBOutlet UITableView *tableviewYear;
@property (strong, nonatomic) IBOutlet UITextField *txtMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtDay;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;
@property (strong, nonatomic) IBOutlet UITextField *txtFullName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextView *txtviewAbout;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;


@end
