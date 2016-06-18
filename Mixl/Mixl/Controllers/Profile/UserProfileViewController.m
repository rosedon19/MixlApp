//
//  UserProfileViewController.m
//  Mixl
//
//  Created by Branislav on 4/6/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController (){
    
    NSArray *monthList, *month;
    NSMutableArray *dayList;
    NSMutableArray *yearList;
    BOOL txtFullNameflag, txtEmailflag, txtPassflag, txtAboutflag;
    int monthSelected;
    
    NSString* userFirstName;
    NSString* userLastName;
    NSString* userBirthDay;
    NSString* userGender;
    NSString* userEmail;
    NSString* userPassword;
    NSString* userDescription;
    NSMutableArray* userImages;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void) initData{
    NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
    
    userProfile = [appController.currentUser objectForKey:@"user"];
    userFirstName = [userProfile objectForKey:@"firstname"];
    userLastName = [userProfile objectForKey:@"lastname"];
    userBirthDay = [userProfile objectForKey:@"date_of_birth"];
    userGender = [userProfile objectForKey:@"gender"];
    userEmail = [userProfile objectForKey:@"email"];
    userPassword = [commonUtils getUserDefault:@"userPassword"];
    userDescription = [userProfile objectForKey:@"description"];
    userImages = [[NSMutableArray alloc] init];
    userImages = (NSMutableArray *)[userProfile objectForKey:@"images"];
}

- (void) initView {
    
    //_imgUser.layer.borderWidth = 2.0f;
    //_imgUser.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imgUser setImage:[UIImage imageNamed:@"avatar_placeholder"]];
    //[commonUtils setCircleBorderImage:_imgUser withBorderWidth:2.0f withBorderColor:[UIColor whiteColor]];
    
    CGFloat radius = MAX(_viewUserImage.bounds.size.height, _viewUserImage.bounds.size.height);
    CGPoint center = _viewUserImage.center;
    _viewUserImage.frame = CGRectMake(center.x - radius/2
                                      , center.y - radius/2
                                      , radius, radius);
    _viewUserImage.layer.cornerRadius = radius/2;
    _viewUserImage.layer.borderWidth = 2.0f;
    _viewUserImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgUser.clipsToBounds = YES;
    
    _viewComponent.layer.borderWidth = 2.0f;
    _viewComponent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnDone.layer.borderWidth = 2.0f;
    _btnDone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    monthList = @[@"Jan", @"Feb", @"Mar", @"Aprl", @"May", @"June", @"Jul", @"Aug", @"Sep", @"Oct", @"Nob", @"Dec" ];
    month = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12" ];
    dayList = [[NSMutableArray alloc] init];
    yearList = [[NSMutableArray alloc] init];
    NSInteger year = [components year];
    for(int d = 1 ; d <= 31; d++)
        [dayList addObject:[NSString stringWithFormat:@"%d", d]];
    for(int y = (int)year ; y >= 1930; y--)
        [yearList addObject:[NSString stringWithFormat:@"%d", y]];
    monthSelected = (int)([components month] -1);
    
    _tableViewMonth.hidden = YES;
    _tableViewMonth.layer.borderWidth = 1.0f;
    _tableViewMonth.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _tableviewDay.hidden = YES;
    _tableviewDay.layer.borderWidth = 1.0f;
    _tableviewDay.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _tableviewYear.hidden = YES;
    _tableviewYear.layer.borderWidth = 1.0f;
    _tableviewYear.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [_btnMale setImage:[UIImage imageNamed:@"icon_unclickcircle"] forState:UIControlStateNormal];
    [_btnMale setImage:[UIImage imageNamed:@"icon_clickcircle"] forState:UIControlStateSelected];
    [_btnFemale setImage:[UIImage imageNamed:@"icon_unclickcircle"] forState:UIControlStateNormal];
    [_btnFemale setImage:[UIImage imageNamed:@"icon_clickcircle"] forState:UIControlStateSelected];
    
    _txtFullName.delegate = self;
    _txtEmail.delegate = self;
    _txtPassword.delegate = self;
    _txtviewAbout.delegate = self;
    _txtviewAbout.textColor = [UIColor lightGrayColor];
    txtFullNameflag = NO;
    txtEmailflag = NO;
    txtPassflag = NO;
    txtAboutflag = NO;

    //init show of user Informations
    _txtFullName.text = [NSString stringWithFormat:@"%@ %@", userFirstName, userLastName];
    
    NSArray *array = [userBirthDay componentsSeparatedByString:@"-"];
    if([[array objectAtIndex:1] isEqualToString:@"00"]){
        _txtMonth.text = [monthList objectAtIndex:((int)[components month] -1)];
    }
    else
    {
        _txtMonth.text = [monthList objectAtIndex:([[array objectAtIndex:1] intValue] -1)];
    }
    if([[array objectAtIndex:2] isEqualToString:@"00"]){
        _txtDay.text = [NSString stringWithFormat:@"%d", (int)[components day]];
    }
    else
    {
        _txtDay.text = [array objectAtIndex:2];
    }
    if([[array objectAtIndex:0] isEqualToString:@"0000"]){
        _txtYear.text = [NSString stringWithFormat:@"%d", (int)[components year]];
    }
    else
    {
        _txtYear.text = [array objectAtIndex:0];
    }
    
    if([userGender isEqualToString:@"m"]){
        _btnMale.selected = YES;
        _btnFemale.selected = NO;
    }
    else{
        if([userGender isEqualToString:@"f"]){
            _btnMale.selected = NO;
            _btnFemale.selected = YES;
        }
        else{
            _btnMale.selected = NO;
            _btnFemale.selected = NO;
        }
    }
    
    _txtEmail.text = userEmail;
    _txtPassword.text = userPassword;
    if([userDescription isEqualToString:@""]){
        _txtviewAbout.text = @"Tell users a little about yourself...";
    }
    else{
        _txtviewAbout.text = userDescription;
    }
    
    if (userImages.count != 0 ) {
        NSString* avatarImageURL = [userImages objectAtIndex:0];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [_imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
//            [commonUtils setImageViewAFNetworking:_imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
            NSURL* imageURL = [NSURL URLWithString:avatarImageURL];
            _imgUser.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        }
    }
    else{
        [_imgUser setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)monthClicked:(id)sender {
    
    if (_tableViewMonth.hidden == YES) {
        _tableViewMonth.hidden = NO;
        _tableviewDay.hidden = YES;
        _tableviewYear.hidden = YES;
    }else {
        _tableViewMonth.hidden = YES;
    }
}

- (IBAction)dayClicked:(id)sender {
    if (_tableviewDay.hidden == YES) {
        _tableviewDay.hidden = NO;
        _tableViewMonth.hidden = YES;
        _tableviewYear.hidden = YES;
    }else {
        _tableviewDay.hidden = YES;
    }
}

- (IBAction)yearClicked:(id)sender {
    if (_tableviewYear.hidden == YES) {
        _tableviewYear.hidden = NO;
        _tableViewMonth.hidden = YES;
        _tableviewDay.hidden = YES;
    }else {
        _tableviewYear.hidden = YES;
    }
}

- (IBAction)nameEditClicked:(id)sender {
    _txtFullName.text = @"";
    txtFullNameflag = YES;
    [_txtFullName becomeFirstResponder];
}

- (IBAction)emailEditClicked:(id)sender {
    _txtEmail.text = @"";
    txtEmailflag = YES;
    [_txtEmail becomeFirstResponder];
}

- (IBAction)passEditClicked:(id)sender {
    _txtPassword.text = @"";
    [_txtPassword setSecureTextEntry:YES];
    txtPassflag = YES;
    [_txtPassword becomeFirstResponder];
}

- (IBAction)aboutEditClicked:(id)sender {
    _txtviewAbout.text = @"";
    txtAboutflag = YES;
    [_txtviewAbout becomeFirstResponder];
}

- (IBAction)maleClicked:(id)sender {
    _btnMale.selected = !_btnMale.selected;
    _btnFemale.selected = !_btnMale.selected;
}

- (IBAction)femailClicked:(id)sender {
    _btnFemale.selected = !_btnFemale.selected;
    _btnMale.selected = !_btnFemale.selected;
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


- (IBAction)doneClicked:(id)sender {
    // profile update
    [_txtviewAbout resignFirstResponder];
    [_txtPassword  resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtFullName resignFirstResponder];
    
   if(self.isLoadingBase) return;

    if([commonUtils isFormEmpty:[@[_txtFullName.text, _txtYear.text, _txtMonth.text, _txtDay.text, _txtEmail.text, _txtPassword.text, _txtviewAbout.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
    } else if([_txtFullName.text length] > 20) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Your name is too long" duration:1.2];
    }  else if(_btnMale.selected == NO && _btnFemale.selected == NO) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please select Gender" duration:1.2];
    } else if(![commonUtils validateEmail:_txtEmail.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format." duration:1.2];
    } else if([_txtPassword.text length] < 6 || [_txtPassword.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length should be 6 to 10." duration:1.2];
    }  else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        NSArray *array = [_txtFullName.text componentsSeparatedByString:@" "];
        
        [paramDic setObject:[array objectAtIndex:0] forKey:@"firstname"];
        [paramDic setObject:[array objectAtIndex:1] forKey:@"lastname"];
        [paramDic setObject:_txtEmail.text forKey:@"email"];
        [paramDic setObject:_txtPassword.text forKey:@"password"];
        [paramDic setObject:_txtviewAbout.text forKey:@"description"];
        
        NSString *bithday;
        bithday = [NSString stringWithFormat:@"%@-%@-%@", _txtYear.text, [month objectAtIndex:monthSelected], _txtDay.text];
        [paramDic setObject:bithday forKey:@"date_of_birth"];
        
        if(_btnMale.selected == YES) [paramDic setObject:@"m" forKey:@"gender"];
        else [paramDic setObject:@"f" forKey:@"gender"];
        NSLog(@"------Profile request params:\n%@", paramDic);
        
        UIImage* userAvatarImg = _imgUser.image;
        NSMutableArray *imageData = [[NSMutableArray alloc] init];
        NSData *avatarData = UIImageJPEGRepresentation(userAvatarImg, 1.0);
        NSDictionary *avatar = @{@"fileType": @"image",
                                 @"name": @"image1",
                                  @"fileName": @"image1.jpg",
                                 @"data": avatarData, @"mimeType": @"image/jpg"};
        [imageData addObject:avatar];
        
        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"io_token"];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
            }];
        }
        
        // Api call
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
        
        
        [[ServerConnect sharedManager] UploadFiles:API_URL_PROFILE_UPDATE withData:imageData withParams:(NSDictionary*)paramDic onSuccess:^(id json){
            
            self.isLoadingBase = NO;
            [JSWaiter HideWaiter];
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            //NSLog(@"----------Profile Response Result:\n%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                userInfo = appController.currentUser;
                [userInfo setObject:[result objectForKey:@"user"] forKey:@"user"];
                appController.currentUser =  userInfo;
                [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
                NSLog(@"---------current user info updated profile: %@", appController.currentUser);
                [commonUtils setUserDefault:@"userPassword" withFormat:_txtPassword.text];
                [commonUtils setUserDefault:@"profileChanged" withFormat:@"1"];
        
                [self performSelector:@selector(Done) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
            } else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
               
                if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please complete entire form";
                [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
                _txtFullName.text = @"";
                _txtEmail.text = @"";
                _txtPassword.text = @"";
                _txtviewAbout.text = @"Tell users a little about yourself...";
                
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                
                monthSelected = (int)([components month] -1);
                _txtMonth.text = [monthList objectAtIndex:monthSelected];
                _txtDay.text = [NSString stringWithFormat:@"%d", (int)[components day]];
                _txtYear.text = [NSString stringWithFormat:@"%d", (int)[components year]];
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
    UserSearchViewController* userSearchViewController =
    (UserSearchViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserSearchVC"];
    userSearchViewController.tapType = SIDEBAR_PEOPLENEARBY_ITEM;
    [self.navigationController pushViewController:userSearchViewController animated:YES];
}

#pragma UITableViewDelegate Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numRow;
    if (tableView == _tableViewMonth) {
        numRow = monthList.count;
    }
    else
    {
        if (tableView == _tableviewDay)
            numRow = dayList.count;
        else
            numRow = yearList.count;
    }
    return numRow;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (tableView == _tableViewMonth) {
        cell.textLabel.text = [monthList objectAtIndex:indexPath.row];
    }
    else
    {
        if (tableView == _tableviewDay)
            cell.textLabel.text = [dayList objectAtIndex:indexPath.row];
        else
            cell.textLabel.text = [yearList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.hidden = YES;
    if (tableView == _tableViewMonth) {
        _txtMonth.text = [monthList objectAtIndex:indexPath.row];
        monthSelected = (int)indexPath.row;

    }
    else
    {
        if (tableView == _tableviewDay)
            _txtDay.text = [dayList objectAtIndex:indexPath.row];
        else
            _txtYear.text = [yearList objectAtIndex:indexPath.row];
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

#pragma UITextFieldDelegate methods
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == _txtFullName) {
        if (txtFullNameflag) {
            return YES;
        }else {
            return NO;
        }
    }
    else{
        if (textField == _txtEmail) {
            if (txtEmailflag) {
                return YES;
            }else {
                return NO;
            }
        }
        else
        {
            if (txtPassflag) {
                return YES;
            }else {
                return NO;
            }
        }
    }
}

#pragma UITextViewDelegate methods
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (txtAboutflag) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if([_txtviewAbout.text isEqualToString:@"Tell users a little about yourself..."])
    {
        _txtviewAbout.text = @"";
        _txtviewAbout.textColor = [UIColor blackColor];
    }
    [_txtviewAbout becomeFirstResponder];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{   if([_txtviewAbout.text isEqualToString:@""])
    {
        _txtviewAbout.text = @"Tell users a little about yourself...";
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
    [_imgUser setImage:imageSEL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




@end
