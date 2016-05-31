//
//  LeftPanelViewController.m
//  DomumLink
//
//  Created by Branislav on 1/15/15.
//  Copyright (c) 2015 Petr. All rights reserved.
//

#import "LeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuTableViewCell.h"
#import "MySidePanelController.h"
#import "UIImageView+WebCache.h"
#import "FriendAcceptViewController.h"

@interface LeftPanelViewController (){

    BOOL friendRequest;
    BOOL chatReceive;
    BOOL offerRequest;
    NSString *friendRequestUserId;
    NSString *offerId;
    NSString *venueId;
    NSString *inviteId;
}
@end

@implementation LeftPanelViewController
@synthesize menuPages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    menuPages = appController.menuPages;
    self.sidePanelController.slideDelegate = self;
    
    [self initView];
}

- (void)initView {
    
    friendRequest = NO;
    chatReceive = NO;
    offerRequest = NO;
    
    NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
    userProfile = [appController.currentUser objectForKey:@"user"];
    
    NSString *userFirstName = @"John";
    userFirstName = [userProfile objectForKey:@"firstname"];
    NSString *userLastName = @"Doe";
    userLastName = [userProfile objectForKey:@"lastname"];
    NSMutableArray* userImages = [[NSMutableArray alloc] init];
    userImages = (NSMutableArray *)[userProfile objectForKey:@"images"];

    //[commonUtils setWFUserPhoto:self.userPhotoImageView byPhotoUrl:[appController.currentUser objectForKey:@"user_photo_url"]];
    [self.userPhotoImageView setImage:[UIImage imageNamed:@"user"]];
    if (userImages.count != 0) {
        NSString* avatarImageURL = [userImages objectAtIndex:0];
        if ([avatarImageURL isEqual:[NSNull null]]){
            //[self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
            [self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            
//            [commonUtils setImageViewAFNetworking:self.userPhotoImageView withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
            NSURL* imageURL = [NSURL URLWithString:avatarImageURL];
            self.userPhotoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        }
    }
    else{
        //[self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        [self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }

    _userName.text = [NSString stringWithFormat:@"%@ %@", userFirstName, userLastName];

}

#pragma mark - Did Receive Unread Message
- (void)friendRequestNoti {
    
    NSLog(@"apnsMessage:--->%@", appController.apnsMessage);
    friendRequestUserId = [appController.apnsMessage objectForKey:@"friend_id"];
    friendRequest = YES;
    [self.menuTableView reloadData];

}

- (void)chatMessage {
    
    NSLog(@"apnsMessage:--->%@", appController.apnsMessage);
    chatReceive = YES;
    [self.menuTableView reloadData];

}

- (void)offerReceive {
    
    NSLog(@"apnsMessage:--->%@", appController.apnsMessage);
    offerId = [appController.apnsMessage objectForKey:@"offer_id"];
    venueId = [appController.apnsMessage objectForKey:@"host_user_id"];
    inviteId = [appController.apnsMessage objectForKey:@"invite_id"];
    offerRequest = YES;
    [self.menuTableView reloadData];
}


- (void)viewDidLayoutSubviews {
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.width = self.sidePanelController.leftVisibleWidth;
    [self.containerView setFrame:containerFrame];
    
    CGRect topFrame = self.topView.frame;
    [self.topView setFrame:CGRectMake(0, 0, containerFrame.size.width, topFrame.size.height)];
    
    [self.menuTableView setFrame: CGRectMake(0, self.topView.frame.size.height, containerFrame.size.width, containerFrame.size.height - topFrame.size.height + (float)[menuPages count])];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [menuPages count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / (float)[menuPages count] - 1.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SideMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (SideMenuTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    
    NSMutableDictionary *dic = [menuPages objectAtIndex:indexPath.row];
    
    [cell setTag:[[dic objectForKey:@"tag"] intValue]];
    [cell.titleLabel setText: [dic objectForKey:@"title"]];
    
    NSString *icon = [dic objectForKey:@"icon"];
    if([appController.currentMenuTag isEqualToString:[dic objectForKey:@"tag"]]) {
        //icon = [icon stringByAppendingString:@"_over"];
        [cell.bgLabel setBackgroundColor:RGBA(211, 216, 216, 1)];
    } else {
        [cell.bgLabel setBackgroundColor:RGBA(243, 244, 244, 1)];
    }
    
    if(friendRequest == YES && indexPath.row == 5) [cell.btnIcon setImage:[UIImage imageNamed:@"icon_friendrequest"] forState:UIControlStateNormal];
    else if(chatReceive == YES && indexPath.row == 1){
        [cell.btnIcon setImage:[UIImage imageNamed:@"icon_chatnoti"] forState:UIControlStateNormal];
    }
    else if(offerRequest == YES && indexPath.row == 4){
        [cell.btnIcon setImage:[UIImage imageNamed:@"icon_offernoti"] forState:UIControlStateNormal];
    }
    else{   [cell.btnIcon setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Page Transition

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    appController.currentMenuTag = [[menuPages objectAtIndex:indexPath.row] objectForKey:@"tag"];
    [tableView reloadData];
    
    UserSearchViewController *userSearchViewController;
    UserProfileViewController *userProfileViewController;
    ManageSettingViewController *userSettingViewController;
    ChatViewController *chatViewController;
    UserReceiveOffersViewController *userReceiveOffersViewController;
    FriendAcceptViewController *friendAcceptViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController* loginViewController =
    (LoginViewController*) [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    UINavigationController *navController;
    
    switch (cell.tag) {
        case 1:
            userProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
            navController = [[UINavigationController alloc] initWithRootViewController: userProfileViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 2:
            if(chatReceive == YES) {
                chatReceive = NO;
                [self.menuTableView reloadData];
                chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatVC"];
                chatViewController.unreadMessage = @"1";
                navController = [[UINavigationController alloc] initWithRootViewController: chatViewController];
                self.sidePanelController.centerPanel = navController;
            }else{
                chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatVC"];
                chatViewController.unreadMessage = @"0";
                navController = [[UINavigationController alloc] initWithRootViewController: chatViewController];
                self.sidePanelController.centerPanel = navController;
            }
            
            break;
        case 3:
            userSearchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
            userSearchViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
            navController = [[UINavigationController alloc] initWithRootViewController: userSearchViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 4:
            userSearchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
            userSearchViewController.tapType = SIDEBAR_FRIENDSNEARBY_ITEM;
            navController = [[UINavigationController alloc] initWithRootViewController: userSearchViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 5:
            if(offerRequest == YES) {
                
                offerRequest = NO;
                [self.menuTableView reloadData];
            userReceiveOffersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserReceiveOffersVC"];
                userReceiveOffersViewController.offerId = offerId;
                userReceiveOffersViewController.venueId = venueId;
                userReceiveOffersViewController.inviteId = inviteId;
            navController = [[UINavigationController alloc] initWithRootViewController: userReceiveOffersViewController];
            self.sidePanelController.centerPanel = navController;
            }
            else{
                [commonUtils showAlert:@"Attention!" withMessage:@"You haven't received the offer request yet."];
            }
            break;
        case 6:
            if(friendRequest == YES) {
            
            friendRequest = NO;
            [self.menuTableView reloadData];
                if(friendRequestUserId != nil){
                    friendAcceptViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendAcceptVC"];
                    friendAcceptViewController.friendRequestUserId = friendRequestUserId;
                    navController = [[UINavigationController alloc] initWithRootViewController: friendAcceptViewController];
                    self.sidePanelController.centerPanel = navController;
                }
            }
            else{
                [commonUtils showAlert:@"Attention!" withMessage:@"You haven't received the friend request yet."];
            }
            
            break;
            
        case 7:
            userSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettingVC"];
            navController = [[UINavigationController alloc] initWithRootViewController: userSettingViewController];
            self.sidePanelController.centerPanel = navController;
            break;
            
        case 8:
            [commonUtils removeUserDefaultDic:@"current_user"];
            appController.currentUser = [[NSMutableDictionary alloc] init];
            [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
            [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"0"];
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
            //[self.navigationController popToRootViewControllerAnimated:NO];
            
            [self.navigationController pushViewController:loginViewController animated:YES];
           
            break;
        default:
            break;
    }
    
}

#pragma mark - App Share Function
- (void)defaultShare {
    NSString *texttoshare = @"I'm using WOOF SOCIAL! I share and discover photos/videos from people around me and watch that content spread. It's free on Apple app store!";
    UIImage *imagetoshare = [UIImage imageNamed:@"user_default_avatar"];
    
    
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    
    //activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

#pragma mark -  Left Side Menu Show

- (void)onMenuShow {
    if([[commonUtils getUserDefault:@"profileChanged"] isEqualToString:@"1"]){
        [self initView];
        [commonUtils setUserDefault:@"profileChanged" withFormat:@"0"];
    }
    
    if([[commonUtils getUserDefault:@"apns_message_arrived"] isEqualToString:@"1"]){
        
        int pushType = [[appController.apnsMessage objectForKey:@"push_type"] intValue];
        switch (pushType) {
            case PUSH_FRIENDREQUEST:
                [self friendRequestNoti];
                break;
            case PUSH_CHATMESSAGE:
                [self chatMessage];
                break;
            case PUSH_OFFER:
                [self offerReceive];
                break;
            default:
                break;
        }

        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"0"];
    }
}
- (void)onMenuHide {
    
}

@end

