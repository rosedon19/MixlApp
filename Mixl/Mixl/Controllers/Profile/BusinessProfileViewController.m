//
//  BusinessProfileViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "BusinessProfileViewController.h"

@interface BusinessProfileViewController (){
    NSMutableArray *cityList;
    NSMutableArray *stateList;
    
    NSString* businessName;
    NSString* address;
    NSString* city;
    NSString* state;
    NSString* zipecode;
    NSString* about;
    NSString* email;
    NSString* userPassword;
    NSArray*  venueImages;
}
@end

@implementation BusinessProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void) initData{
    NSMutableDictionary *venueProfile = [[NSMutableDictionary alloc] init];
    cityList = [[NSMutableArray alloc] init];
    stateList = [[NSMutableArray alloc] init];
    venueProfile = [appController.currentUser objectForKey:@"user"];
    email = [venueProfile objectForKey:@"email"];
    businessName = [venueProfile objectForKey:@"businessname"];
    address = [venueProfile objectForKey:@"address"];
    city = [venueProfile objectForKey:@"city"];
    state = [venueProfile objectForKey:@"state"];
    zipecode = [venueProfile objectForKey:@"zipcode"];
    about = [venueProfile objectForKey:@"description"];
    userPassword = [commonUtils getUserDefault:@"userPassword"];
    venueImages = [[NSArray alloc] init];
    venueImages = (NSArray *)[venueProfile objectForKey:@"images"];
    
    // Api call Nearby People
    [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
    self.isLoadingBase = YES;
    [[ServerConnect sharedManager] GET:API_URL_CITY withParams:nil onSuccess:^(id json) {
        self.isLoadingBase = NO;
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------City Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            NSMutableArray *users = [[NSMutableArray alloc] init];
            users = [result objectForKey:@"cities"];
            for(NSMutableDictionary* user in users){
                [cityList addObject:[user objectForKey:@"name"]];
            }
            [self getStates];
        } else {
            [JSWaiter HideWaiter];
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the city list";
        }
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];

}

- (void) getStates{
    [[ServerConnect sharedManager] GET:API_URL_STATES withParams:nil onSuccess:^(id json) {
        
        NSMutableDictionary *result1 = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------States Response Result:\n%@", result1);
        NSString *str1 = [result1 objectForKey:@"error"];
        int flag1 = [str1 intValue];
        if(flag1 == 0) {
            
            NSMutableArray *users1 = [[NSMutableArray alloc] init];
            users1 = [result1 objectForKey:@"states"];
            for(NSMutableDictionary* user1 in users1){
                [stateList addObject:[user1 objectForKey:@"name"]];
            }
            [JSWaiter HideWaiter];
            [self initView];
        } else {
            [JSWaiter HideWaiter];
            NSArray *msg1 = (NSArray *)[result1 objectForKey:@"messages"];
            NSString *stringMsg1 = (NSString *)[msg1 objectAtIndex:0];
            if([stringMsg1 isEqualToString:@""]) stringMsg1 = @"Sorry, We can't find the city list";
        }
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];
}


- (void) initView {
    
    [_imgVenue setImage:[UIImage imageNamed:@"bar_menuhead"]];
    
    CGFloat radius = MAX(_viewVenueImage.bounds.size.height, _viewVenueImage.bounds.size.height);
    CGPoint center = _viewVenueImage.center;
    _viewVenueImage.frame = CGRectMake(center.x - radius/2
                                      , center.y - radius/2
                                      , radius, radius);
    _viewVenueImage.layer.cornerRadius = radius/2;
    _viewVenueImage.layer.borderWidth = 2.0f;
    _viewVenueImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewComponent.layer.borderWidth = 2.0f;
    _viewComponent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnNext.layer.borderWidth = 2.0f;
    _btnNext.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if([cityList count] == 0){
        cityList = [@[@"New York", @"Washigton", @"Los Angles", @"San Francisco", @"Philadelphia", @"Houston", @"Atlanta", @"Baltimore", @"Chicago", @"Portland", @"New Orleans", @"Boston", @"San Jose", @"Denver" ] mutableCopy];
    }
    if([stateList count] == 0){
        stateList = [@[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"] mutableCopy];
    }
    _tableViewCity.hidden = YES;
    _tableViewCity.layer.borderWidth = 1.0f;
    _tableViewCity.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _tableviewState.hidden = YES;
    _tableviewState.layer.borderWidth = 1.0f;
    _tableviewState.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    _txtviewAbout.text = @"About Us";
    _txtviewAbout.textColor = [UIColor lightGrayColor];
    
    //init show of user Informations
    _txtBusinessName.text = businessName;
    _txtAddress.text = address;
    if([city isEqualToString:@""]) _txtCity.text = @"City";
    else _txtCity.text = city;
    if([state isEqualToString:@""]) _txtState.text = @"State";
    else _txtState.text = state;
    _txtZipCode.text = zipecode;
    if([about isEqualToString:@""]) _txtviewAbout.text = @"About Us";
    else _txtviewAbout.text = about;
    
    if (venueImages.count != 0 ) {
        NSString* avatarImageURL = [venueImages objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgVenue setImage:[UIImage imageNamed:@"bar_menuhead"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgVenue withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"bar_menuhead"]];
        }
    }
    else{
        [_imgVenue setImage:[UIImage imageNamed:@"bar_menuhead"]];
    }
    
    [_tableViewCity reloadData];
    [_tableviewState reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photouploadClicked:(id)sender {
    UIActionSheet *alertCamera = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a picture",
                                  @"Select photos from camera roll", nil];
    alertCamera.tag = 1;
    [alertCamera showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)cityClicked:(id)sender {
    if (_tableViewCity.hidden == YES) {
        _tableViewCity.hidden = NO;
        _tableviewState.hidden = YES;
    }else {
        _tableViewCity.hidden = YES;
    }
}
- (IBAction)stateClicked:(id)sender {
    if (_tableviewState.hidden == YES) {
        _tableviewState.hidden = NO;
        _tableViewCity.hidden = YES;
    }else {
        _tableviewState.hidden = YES;
    }
}

- (IBAction)doneClicked:(id)sender {
    // profile update

    [_txtviewAbout resignFirstResponder];
    [_txtZipCode  resignFirstResponder];
    [_txtAddress resignFirstResponder];
    [_txtBusinessName resignFirstResponder];

    if(self.isLoadingBase) return;

    if([commonUtils isFormEmpty:[@[_txtBusinessName.text, _txtAddress.text, _txtCity.text, _txtState.text, _txtZipCode.text, _txtviewAbout.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
    } else if([_txtBusinessName.text length] > 20) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Business Name is too long" duration:1.2];
    } else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        [paramDic setObject:email forKey:@"email"];
        [paramDic setObject:userPassword forKey:@"password"];
        [paramDic setObject:_txtBusinessName.text forKey:@"businessname"];
        [paramDic setObject:_txtAddress.text forKey:@"address"];
        [paramDic setObject:_txtCity.text forKey:@"city"];
        [paramDic setObject:_txtState.text forKey:@"state"];
        [paramDic setObject:_txtZipCode.text forKey:@"zipcode"];
        [paramDic setObject:_txtviewAbout.text forKey:@"description"];
       
        UIImage* venueAvatarImg = _imgVenue.image;
        NSMutableArray *imageData = [[NSMutableArray alloc] init];
        NSData *avatarData = UIImageJPEGRepresentation(venueAvatarImg, 1.0);
        NSDictionary *avatar = @{@"fileType": @"image", @"name": @"image1", @"fileName": @"image1.jpg", @"data": avatarData, @"mimeType": @"image/jpg"};
        [imageData addObject:avatar];
        
        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"io_token"];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
            }];
        }
        
        NSLog(@"------Venue Profile request params:\n%@", paramDic);
        // Api call
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
        
        [[ServerConnect sharedManager] UploadFiles:API_URL_PROFILE_UPDATE withData:imageData withParams:(NSDictionary*)paramDic onSuccess:^(id json){
            
            self.isLoadingBase = NO;
            [JSWaiter HideWaiter];
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            NSLog(@"----------Profile Response Result:\n%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                userInfo = appController.currentUser;
                [userInfo setObject:[result objectForKey:@"user"] forKey:@"user"];
                appController.currentUser =  userInfo;
                [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
                NSLog(@"current user : %@", appController.currentUser);
                [commonUtils setUserDefault:@"profileChanged" withFormat:@"1"];
                
                [self performSelector:@selector(Done) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
            } else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please complete entire form";
                [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
                _txtBusinessName.text = @"";
                _txtAddress.text = @"";
                _txtCity.text = @"";
                _txtState.text = @"";
                _txtZipCode.text = @"";
                _txtviewAbout.text = @"About Us";
                
            }
        }onFailure:^(NSInteger statusCode, id json) {
            self.isLoadingBase = NO;
            [JSWaiter HideWaiter];
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
        }];
        
    }
}

- (void) Done{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BusinessSettingViewController *businessSettingViewController =
    (BusinessSettingViewController*) [storyboard instantiateViewControllerWithIdentifier:@"BusinessSettingVC"];
    [self.navigationController pushViewController:businessSettingViewController animated:YES];
}


#pragma UITableViewDelegate Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numRow;
    if (tableView == _tableViewCity) {
        numRow = cityList.count;
    }
    else
    {
        numRow = stateList.count;
    }
    return numRow;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (tableView == _tableViewCity) {
        cell.textLabel.text = [cityList objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [stateList objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.hidden = YES;
    if (tableView == _tableViewCity) {
        _txtCity.text = [cityList objectAtIndex:indexPath.row];
    }
    else
    {
        _txtState.text = [stateList objectAtIndex:indexPath.row];
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if([_txtviewAbout.text isEqualToString:@"About Us"])
    {
        _txtviewAbout.text = @"";
        _txtviewAbout.textColor = [UIColor blackColor];
    }
    [_txtviewAbout becomeFirstResponder];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{   if([_txtviewAbout.text isEqualToString:@""])
{
    _txtviewAbout.text = @"About Us";
    _txtviewAbout.textColor = [UIColor lightGrayColor];
}
    [_txtviewAbout resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    switch (buttonIndex) {
            
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    NSLog(@"%ld , %ld", (long)actionSheet.tag , (long)buttonIndex);
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageSEL = info[UIImagePickerControllerEditedImage];
    [_imgVenue setImage:imageSEL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
