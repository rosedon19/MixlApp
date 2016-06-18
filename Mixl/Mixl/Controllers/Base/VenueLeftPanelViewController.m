//
//  VenueLeftPanelViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "VenueLeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuTableViewCell.h"
#import "VenueMySideViewController.h"

@interface VenueLeftPanelViewController ()

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *venuemenuPages;

@property (nonatomic, strong) IBOutlet UIView *containerView, *topView;
@property (nonatomic, strong) IBOutlet UIImageView *userPhotoImageView;
@property (nonatomic, strong) IBOutlet UILabel *userName;

@end

@implementation VenueLeftPanelViewController
@synthesize venuemenuPages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    venuemenuPages = appController.venuemenuPages;
    self.sidePanelController.slideDelegate = self;
    
    [self initView];
}

- (void)initView {
    
    NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
    userProfile = [appController.currentUser objectForKey:@"user"];
    
    NSString *businessName = @"Cafe Bar";
    businessName = [userProfile objectForKey:@"businessname"];
    NSMutableArray* userImages = [[NSMutableArray alloc] init];
    userImages = (NSMutableArray *)[userProfile objectForKey:@"images"];
    
    [self.userPhotoImageView setImage:[UIImage imageNamed:@"user"]];
    if (userImages.count != 0) {
        NSString* avatarImageURL = [userImages objectAtIndex:0];
        if ([avatarImageURL isEqual:[NSNull null]]){
            //[self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
            [self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
    
            NSURL* imageURL = [NSURL URLWithString:avatarImageURL];
            self.userPhotoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        }
    }
    else{
        //[self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        [self.userPhotoImageView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }
    
    _userName.text = businessName;

}

- (void)viewDidLayoutSubviews {
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.width = self.sidePanelController.leftVisibleWidth;
    [self.containerView setFrame:containerFrame];
    
    CGRect topFrame = self.topView.frame;
    [self.topView setFrame:CGRectMake(0, 0, containerFrame.size.width, topFrame.size.height)];
    
    [self.menuTableView setFrame: CGRectMake(0, self.topView.frame.size.height, containerFrame.size.width, containerFrame.size.height - topFrame.size.height + (float)[venuemenuPages count])];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [venuemenuPages count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / (float)[venuemenuPages count] - 1.0f;
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
    
    NSMutableDictionary *dic = [venuemenuPages objectAtIndex:indexPath.row];
    
    [cell setTag:[[dic objectForKey:@"tag"] intValue]];
    [cell.titleLabel setText: [dic objectForKey:@"title"]];
    
    NSString *icon = [dic objectForKey:@"icon"];
    if([appController.currentMenuTag isEqualToString:[dic objectForKey:@"tag"]]) {
        //icon = [icon stringByAppendingString:@"_over"];
        [cell.bgLabel setBackgroundColor:RGBA(211, 216, 216, 1)];
    } else {
        [cell.bgLabel setBackgroundColor:RGBA(243, 244, 244, 1)];
    }
    [cell.btnIcon setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Page Transition

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    appController.currentMenuTag = [[venuemenuPages objectAtIndex:indexPath.row] objectForKey:@"tag"];
    [tableView reloadData];
    
    BusinessProfileViewController *businessProfileViewController;
    PeopleNearbyViewController *peopleNearbyViewController;
    BusinessSettingViewController *businessSettingViewController;
    OffersViewController *offersViewController;
    ClaimedVouchersViewController *claimedVouchersViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController* loginViewController =
    (LoginViewController*) [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
   
    UINavigationController *navController;
    
    switch (cell.tag) {
        case 1:
            businessProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BusicessProfileVC"];
            navController = [[UINavigationController alloc] initWithRootViewController: businessProfileViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 2:
            offersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BusicessOffersVC"];
            offersViewController.offerIndex = 1;
            navController = [[UINavigationController alloc] initWithRootViewController: offersViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 3:
            peopleNearbyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleNearbyVC"];
            navController = [[UINavigationController alloc] initWithRootViewController: peopleNearbyViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 4:
            claimedVouchersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimedVoucherVC"];
            claimedVouchersViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
            navController = [[UINavigationController alloc] initWithRootViewController: claimedVouchersViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 5:
            claimedVouchersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimedVoucherVC"];
            claimedVouchersViewController.tapType = SIDEBAR_FRIENDSNEARBY_ITEM;
            navController = [[UINavigationController alloc] initWithRootViewController: claimedVouchersViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 6:
            businessSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BusinessSettingVC"];
            navController = [[UINavigationController alloc] initWithRootViewController: businessSettingViewController];
            self.sidePanelController.centerPanel = navController;
            break;
            
        case 7:
            [commonUtils removeUserDefaultDic:@"current_user"];
            appController.currentUser = [[NSMutableDictionary alloc] init];
            [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
            [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"0"];
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"0"];
            [self.navigationController pushViewController:loginViewController animated:YES];
            break;
        default:
            break;
    }
    
}

#pragma mark -  Left Side Menu Show

- (void)onMenuShow {
    if([[commonUtils getUserDefault:@"profileChanged"] isEqualToString:@"1"]){
        [self initView];
        [commonUtils setUserDefault:@"profileChanged" withFormat:@"0"];
    }
    
}
- (void)onMenuHide {
    
}

@end
