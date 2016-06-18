//
//  ClaimedVouchersViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ClaimedVouchersViewController.h"
#import "ClaimedTableViewCell.h"
#import "NotClaimedTableViewCell.h"
#import "AcceptedOfferViewController.h"

@interface ClaimedVouchersViewController ()

@property (nonatomic, strong) NSMutableArray *claimedUsers, *notclaimedUsers;

@end

@implementation ClaimedVouchersViewController
@synthesize claimedUsers, notclaimedUsers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void) initData{
    
    NSMutableDictionary *dicClaimed = [[NSMutableDictionary alloc] init];
    [dicClaimed setObject:@"claimed" forKey:@"filter"];
    NSLog(@"----  Request of Claimed: %@", dicClaimed);
    [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
    [[ServerConnect sharedManager] GET:API_URL_RECEIVEINVITE withParams:dicClaimed onSuccess:^(id json) {
        
        [JSWaiter HideWaiter];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------User Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            NSMutableArray *claims = [[NSMutableArray alloc] init];
            claims = [result objectForKey:@"invites"];
            claimedUsers = claims;
            
            NSMutableDictionary *dicUnClaimed = [[NSMutableDictionary alloc] init];
            [dicUnClaimed setObject:@"unclaimed" forKey:@"filter"];
            NSLog(@"----  Request of UnClaimed: %@", dicUnClaimed);
            [[ServerConnect sharedManager] GET:API_URL_RECEIVEINVITE withParams:dicUnClaimed onSuccess:^(id json) {
                
                NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
                NSLog(@"----------User Response Result:\n%@", result);
                NSString *str = [result objectForKey:@"error"];
                int flag = [str intValue];
                if(flag == 0) {
                    
                    NSMutableArray *unclaims = [[NSMutableArray alloc] init];
                    unclaims = [result objectForKey:@"invites"];
                    notclaimedUsers = unclaims;
                    
                    [_tableClaimed reloadData];
                    [_tableNotClaimed reloadData];
                    
                } else {
                    NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                    NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                    if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the user sent the friend request";
                }
                [self initView];
                
            } onFailure:^(NSInteger statusCode, id json) {
                [JSWaiter HideWaiter];
                [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
            }];

        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the user sent the friend request";
        }
        
    } onFailure:^(NSInteger statusCode, id json) {
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];

}
- (void) initView {
    
    if(_tapType == 2)
    {
        [self showTap:YES];
    }
    else
    {
        [self showTap:NO];
    }
    
    [_tableClaimed reloadData];
    [_tableNotClaimed reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTap:(BOOL)show {
    
    self.lblClaimed.textColor = (show) ? [UIColor whiteColor]:UIColorFromRGB(0xF5F8EE);
    self.viewClaimedTab.backgroundColor = (show) ? UIColorFromRGB(0x55E0E0) : UIColorFromRGB(0x43C6DB);
    
    self.lblNotClaimed.textColor = (show) ?  UIColorFromRGB(0xF5F8EE):[UIColor whiteColor];
    self.viewNotClaimedTab.backgroundColor = (show) ? UIColorFromRGB(0x43C6DB):UIColorFromRGB(0x55E0E0);
    
    _viewClaimed.hidden = !show;
    _viewNotClaimed.hidden = show;
    
}


- (IBAction)onClaimedTapClicked:(id)sender {
    [self showTap:YES];
}

- (IBAction)onNotClaimedTapClicked:(id)sender {
    [self showTap:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _tableClaimed){
        return [claimedUsers count];
    }
    else{
        return [notclaimedUsers count];
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _tableClaimed){
        ClaimedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ClaimedCell"];
        
        NSMutableDictionary *dic = [claimedUsers objectAtIndex:indexPath.row];
        NSMutableDictionary *userProfile = [dic objectForKey:@"invitee_user_profile"];
        NSString* name = [NSString stringWithFormat:@"%@ %@",[userProfile objectForKey:@"firstname"], [userProfile objectForKey:@"lastname"]];
        [cell.lblName setText:name];
        
         NSArray *bithday = [[userProfile objectForKey:@"date_of_birth"] componentsSeparatedByString:@"-"];
        [cell.lblAge setText:[NSString stringWithFormat:@"Age: %@", [commonUtils ageCount:[bithday objectAtIndex:0]]]];
        
        [cell.lblOfferName setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"offerTitle"]]];
        
        NSMutableArray* images = [[NSMutableArray alloc] init];
        images = [userProfile objectForKey:@"images"];
        if (images.count != 0) {
            NSString* avatarImageURL = [images objectAtIndex:0];
            NSLog(@"avatar image URL : %@", avatarImageURL);
            if ([avatarImageURL isEqual:[NSNull null]]){
                [cell.imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
            }else{
                [commonUtils setImageViewAFNetworking:cell.imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
            }
        }
        else{
            [cell.imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NotClaimedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotClaimedCell"];
        
        NSMutableDictionary *dic = [notclaimedUsers objectAtIndex:indexPath.row];
        NSMutableDictionary *userProfile = [dic objectForKey:@"invitee_user_profile"];
        NSString* name = [NSString stringWithFormat:@"%@ %@",[userProfile objectForKey:@"firstname"], [userProfile objectForKey:@"lastname"]];
        [cell.lblName setText:name];
        
        NSArray *bithday = [[userProfile objectForKey:@"date_of_birth"] componentsSeparatedByString:@"-"];
        [cell.lblAge setText:[NSString stringWithFormat:@"Age: %@", [commonUtils ageCount:[bithday objectAtIndex:0]]]];
        
        [cell.lblOfferName setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"offerTitle"]]];

        [cell.lblTime setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"remain_time"]]];
        
        NSMutableArray* images = [[NSMutableArray alloc] init];
        images = [userProfile objectForKey:@"images"];
        if (images.count != 0) {
            NSString* avatarImageURL = [images objectAtIndex:0];
            NSLog(@"avatar image URL : %@", avatarImageURL);
            if ([avatarImageURL isEqual:[NSNull null]]){
                [cell.imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
            }else{
                [commonUtils setImageViewAFNetworking:cell.imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
            }
        }
        else{
            [cell.imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _tableClaimed){
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        AcceptedOfferViewController* acceptedofferViewController =
//        (AcceptedOfferViewController*) [storyboard instantiateViewControllerWithIdentifier:@"AcceptedOfferVC"];
//        acceptedofferViewController.offeredUser = [claimedUsers objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:acceptedofferViewController animated:YES];

    }
}

@end
