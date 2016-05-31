//
//  BusinessProfileViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessProfileViewController : BaseViewController<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewVenueImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgVenue;
@property (strong, nonatomic) IBOutlet UIView *viewComponent;

@property (strong, nonatomic) IBOutlet UITextField *txtBusinessName;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCity;
@property (strong, nonatomic) IBOutlet UITableView *tableviewState;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (strong, nonatomic) IBOutlet UITextView *txtviewAbout;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

@end
