//
//  OffersViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "OffersViewController.h"
#import "ViewOfferViewController.h"
#import "GalleryCollectionViewCell.h"

@interface OffersViewController (){
    
    NSArray *timeList;
    NSMutableArray *images;
    NSString* imageType;
    NSString* offerImage;
    UIImage* offerUIimage;
    
    NSDictionary* offerObject;
    NSString* offer_id;
    NSString* title;
    NSString* description;
    NSString* validuntil;
    NSString* vouchercode;
}

@end

@implementation OffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGallery];    
}

- (void) initGallery{
    
    offerUIimage = [[UIImage alloc] init];
    [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
    self.isLoadingBase = YES;
    [[ServerConnect sharedManager] GET:API_URL_GALLERY withParams:nil onSuccess:^(id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
        NSLog(@"----------Gallery Response Result:\n%@", result);
        NSString *str = [result objectForKey:@"error"];
        int flag = [str intValue];
        if(flag == 0) {
            images = [[NSMutableArray alloc] init];
            images = [result objectForKey:@"images"];
            
        } else {
            NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""]) stringMsg = @"Sorry, We can't find the Mixl Photo Gallery list";
        }
        [self initView];
        
    } onFailure:^(NSInteger statusCode, id json) {
        self.isLoadingBase = NO;
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }];

}

-(void) initView{
    
    if([appController.offersList count] != 0 && _offerIndex != 0){
        offerObject = [appController.offersList objectAtIndex:_offerIndex - 1];
        offer_id = [offerObject objectForKey:@"id"];
        title = [offerObject objectForKey:@"title"];
        description = [offerObject objectForKey:@"description"];
        validuntil = [offerObject objectForKey:@"valid_until"];
        vouchercode = [offerObject objectForKey:@"voucher_code"];
        offerImage = [offerObject objectForKey:@"image"];
        if(offerImage == nil) offerImage = @"";
        imageType = @"String";
    }
    else{
        offer_id = @"";
        title = @"";
        description = @"";
        validuntil = @"";
        vouchercode = @"";
        offerImage = @"";
        imageType = @"";
    }

    timeList = @[@"15", @"30", @"45", @"60"];
    _txtviewOffer.layer.borderWidth = 2.0f;
    _txtviewOffer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnPreview.layer.borderWidth = 2.0f;
    _btnPreview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _tableviewTime.hidden = YES;
    _tableviewTime.layer.borderWidth = 1.0f;
    _tableviewTime.layer.borderColor = [UIColor darkGrayColor].CGColor;
    if([validuntil isEqualToString:@""]){
        _txtExpirationTime.text = validuntil;
    }
    else{
        _txtExpirationTime.text = [NSString stringWithFormat:@"%@min", validuntil];
    }
    _txtOfferName.text = title;
    _txtviewOffer.text = description;
    
    _collectionGallery.hidden = YES;
    _collectionGallery.layer.borderWidth = 1.0f;
    _collectionGallery.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [_collectionGallery reloadData];
    [_tableviewTime reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)expirationTimeClicked:(id)sender {
    if (_tableviewTime.hidden == YES) {
        _tableviewTime.hidden = NO;
    }else {
        _tableviewTime.hidden = YES;
    }
}

#pragma UITableViewDelegate Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return timeList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@min",[timeList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.hidden = YES;
    validuntil = [timeList objectAtIndex:indexPath.row];
    _txtExpirationTime.text = [NSString stringWithFormat:@"%@min", validuntil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [images count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width) / 2.0;
    CGFloat height = width * 125 / 160;
    return CGSizeMake(width, height);
}

#pragma - mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[GalleryCollectionViewCell alloc] init];
    }
    
    cell.viewPhoto.layer.borderWidth = 2.0f;
    cell.viewPhoto.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    if (images.count != 0 ) {
        NSString* avatarImageURL = [images objectAtIndex:indexPath.row];
        NSLog(@"avatar image URL : %@", avatarImageURL);
        if ([avatarImageURL isEqual:[NSNull null]]){
            [cell.imgPhoto setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [commonUtils setImageViewAFNetworking:cell.imgPhoto withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        }
    }
    else{
        [cell.imgPhoto setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    offerImage = images[(int)indexPath.item];
    imageType = @"String";
    _collectionGallery.hidden = YES;
}


- (IBAction)previewClicked:(id)sender {
    if([commonUtils isFormEmpty:[@[_txtOfferName.text, _txtviewOffer.text, _txtExpirationTime.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete entire form" duration:1.2];
    }
    else if([imageType isEqualToString:@""]){
        [commonUtils showVAlertSimple:@"Warning" body:@"Please select Offer Image" duration:1.2];
    }
    else{
        
        NSMutableDictionary* newOffer = [[NSMutableDictionary alloc] initWithObjectsAndKeys:          offer_id, @"id",
                                                                                            _txtOfferName.text, @"title",
                                                                                                    validuntil, @"validuntil",
                                                                                                    offerImage, @"image",
                                                                                                     imageType, @"imageType",
                                                                                            _txtviewOffer.text, @"description",nil];
        [_txtOfferName resignFirstResponder];
        [_txtviewOffer resignFirstResponder];
        [_txtExpirationTime resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewOfferViewController* viewOfferViewController =
        (ViewOfferViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ViewOffersVC"];
        viewOfferViewController.offer = newOffer;
        viewOfferViewController.imageFile = offerUIimage;
        [self.navigationController pushViewController:viewOfferViewController animated:YES];
    }
}

- (IBAction)mixlGalleryClicked:(id)sender {
    _collectionGallery.hidden = NO;
}


- (IBAction)ownImageClicked:(id)sender {
    UIActionSheet *alertCamera = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a picture",
                                  @"Select photos from camera roll", nil];
    alertCamera.tag = 1;
    [alertCamera showInView:[UIApplication sharedApplication].keyWindow];
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
    offerUIimage = imageSEL;
    imageType = @"File";
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
