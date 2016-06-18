//
//  ChatViewController.h
//  Mixl
//
//  Created by Branislav on 4/19/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblChatUserName;

@property (weak, nonatomic) IBOutlet UIView         *viewBack;
@property (weak, nonatomic) IBOutlet UITableView    *chatHistoryTable;
@property (weak, nonatomic) IBOutlet UITextView     *txtMessage;
@property (weak, nonatomic) IBOutlet UIButton       *btnSend;
@property (weak, nonatomic) IBOutlet UIView         *viewInput;

@property (strong, nonatomic) NSMutableDictionary   *issueInfo;
@property (strong, nonatomic) NSString              *unreadMessage;

@property (strong, nonatomic) NSString*              receiverId;

@end
