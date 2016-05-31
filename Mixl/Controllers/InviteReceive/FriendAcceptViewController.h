//
//  FriendAcceptViewController.h
//  Mixl
//
//  Created by Branislav on 5/18/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendAcceptViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgWantedUser;
@property (weak, nonatomic) IBOutlet UILabel *lblWantedUserName;

@property (strong, nonatomic) NSString* friendRequestUserId;

@end
