//
//  UserRegistrationViewController.m
//  Mixl
//
//  Created by Branislav on 4/8/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "UserRegistrationViewController.h"

@interface UserRegistrationViewController (){
    NSArray *monthList, *month;
    NSMutableArray *dayList;
    NSMutableArray *yearList;
    int monthSelected;
}

@end

@implementation UserRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView {
    
    _viewComponent.layer.borderWidth = 2.0f;
    _viewComponent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTerms.layer.borderWidth = 2.0f;
    _viewTerms.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    _txtMonth.text = [monthList objectAtIndex:monthSelected];
    _txtDay.text = [NSString stringWithFormat:@"%d", (int)[components day]];
    _txtYear.text = [NSString stringWithFormat:@"%d", (int)[components year]];
    
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
    
    _btnMale.selected = YES;
    _btnFemale.selected = NO;
    
    self.swTerms.on = NO;
    self.swPolicy.on = NO;
    
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
        _tableviewYear.hidden = YES;
        _tableViewMonth.hidden = YES;
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

- (IBAction)maleClicked:(id)sender {
    _btnMale.selected = !_btnMale.selected;
    _btnFemale.selected = !_btnMale.selected;
}

- (IBAction)femailClicked:(id)sender {
    _btnFemale.selected = !_btnFemale.selected;
    _btnMale.selected = !_btnFemale.selected;
}


- (IBAction)onSWTerms:(id)sender {
    //[UserInformation sharedInstance].receiveMessage = self.swTerms.on;
}

- (IBAction)onSWPolicy:(id)sender {
    //[UserInformation sharedInstance].receiveMessage = self.swPolicy.on;
}

- (IBAction)doneClicked:(id)sender {
    // sign up
    [_txtDay resignFirstResponder];
    [_txtMonth resignFirstResponder];
    [_txtYear resignFirstResponder];
    [_txtFirstName resignFirstResponder];
    [_txtLastName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
    if(self.isLoadingUserBase) return;
    
    if([commonUtils isFormEmpty:[@[_txtFirstName.text, _txtLastName.text, _txtYear.text, _txtMonth.text, _txtDay.text, _txtEmail.text, _txtPassword.text, _txtConfirmPassword.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
    } else if([_txtFirstName.text length] > 20) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Your first name is too long" duration:1.2];
    } else if([_txtLastName.text length] > 20) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Your last name is too long" duration:1.2];
    } else if(![commonUtils validateEmail:_txtEmail.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format." duration:1.2];
    } else if([_txtPassword.text length] < 6 || [_txtPassword.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length should be 6 to 10." duration:1.2];
    } else if(![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password confirm does not match." duration:1.2];
    } else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:@"u" forKey:@"type"];
        [paramDic setObject:_txtFirstName.text forKey:@"firstname"];
        [paramDic setObject:_txtLastName.text forKey:@"lastname"];
        [paramDic setObject:_txtEmail.text forKey:@"email"];
        //[paramDic setObject:[commonUtils md5:self.userPasswordTextField.text] forKey:@"user_password"];
        [paramDic setObject:_txtPassword.text forKey:@"password"];
        
        NSString *bithday;
        bithday = [NSString stringWithFormat:@"%@-%@-%@", _txtYear.text, [month objectAtIndex:monthSelected], _txtDay.text];
        [paramDic setObject:bithday forKey:@"date_of_birth"];
        
        if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"latitude"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"longitude"];
        }
        else{
            [appController.vAlert doAlert:@"Notice" body:@"There is no your location info.\n Please Confirm location service and Try again!" duration:2.0f done:^(DoAlertView *alertView) {
                return;
            }];
            
        }
        
        if(_btnMale.selected == YES) [paramDic setObject:@"m" forKey:@"gender"];
        else [paramDic setObject:@"f" forKey:@"gender"];
        
        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"io_token"];
            [self requestAPISignUp:paramDic];
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
                [self requestAPISignUp:paramDic];
            }];
        }

    }
  
}

#pragma mark - API Request - User Sign Up
- (void)requestAPISignUp:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [JSWaiter ShowWaiter:self.view title:@"Registering..." type:0];
    [NSThread detachNewThreadSelector:@selector(requestDataSignUp:) toTarget:self withObject:dic];
}
- (void)requestDataSignUp:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            
            appController.currentUser = [NSMutableDictionary dictionaryWithDictionary:result];
            [commonUtils setUserDefault:@"authorized_token" withFormat:[[result objectForKey:@"user"] objectForKey:@"token"]];
            [commonUtils setUserDefault:@"userPassword" withFormat:_txtPassword.text];
            [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"1"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateLocationManager];

            NSLog(@"----------current user info (Sign up)  : %@", appController.currentUser);
            [self navToMainView];
            //[self performSelector:@selector(requestOverSignUp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSArray *msg = (NSArray *)[resObj objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
            _txtFirstName.text = @"";
            _txtLastName.text = @"";
            _txtEmail.text = @"";
            _txtPassword.text = @"";
            _txtConfirmPassword.text = @"";
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            
            monthSelected = (int)([components month] -1);
            _txtMonth.text = [monthList objectAtIndex:monthSelected];
            _txtDay.text = [NSString stringWithFormat:@"%d", (int)[components day]];
            _txtYear.text = [NSString stringWithFormat:@"%d", (int)[components year]];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }
    
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
