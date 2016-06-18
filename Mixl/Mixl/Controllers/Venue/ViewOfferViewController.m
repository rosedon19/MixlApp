//
//  ViewOfferViewController.m
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ViewOfferViewController.h"

@interface ViewOfferViewController ()
{
    NSString* offerId;
    NSString* avatarImageURL;
    NSString* imageType;
    NSString* offerName;
    NSString* validUntil;
    NSString* description;
}

@end

@implementation ViewOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    
    _btnSave.layer.borderWidth = 2.0f;
    _btnSave.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnCancel.layer.borderWidth = 2.0f;
    _btnCancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if(_offer != nil)
    {
        offerId = [_offer objectForKey:@"id"];
        offerName = [_offer objectForKey:@"title"];
        validUntil = [_offer objectForKey:@"validuntil"];
        avatarImageURL = [_offer objectForKey:@"image"];
        imageType = [_offer objectForKey:@"imageType"];
        description = [_offer objectForKey:@"description"];
        
        _lblOfferName.text = [NSString stringWithFormat:@"Your Offer:%@", offerName];
        if([imageType isEqualToString:@"File"]){
             [_imgVenue setImage:_imageFile];
        }
        else{
            
            if ([avatarImageURL isEqual:[NSNull null]]){
                [_imgVenue setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
            }else{
                [commonUtils setImageViewAFNetworking:_imgVenue withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
            }
            
        }
    }
    else{
        _lblOfferName.text = [NSString stringWithFormat:@"Your Offer"];
        [_imgVenue setImage:[UIImage imageNamed:@"bar"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveClicked:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(![offerId isEqualToString:@""])
    {
        [dic setObject:offerId forKey:@"id"];
    }
    [dic setObject:offerName forKey:@"title"];
    [dic setObject:description forKey:@"description"];
    [dic setObject:validUntil forKey:@"valid_until"];
    //[dic setObject:voucherCode forKey:@"voucher_code"];
    if([imageType isEqualToString:@"String"]){
        
        [dic setObject:avatarImageURL forKey:@"image_from_gallery"];
        [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
        [NSThread detachNewThreadSelector:@selector(requestUpdateOffer:) toTarget:self withObject:dic];
    }
    else{
        
        NSLog(@"----params:\n%@", dic);
        NSMutableArray *imageData = [[NSMutableArray alloc] init];
        NSData *avatarData = UIImageJPEGRepresentation(_imageFile, 1.0);
        NSDictionary *avatar = @{@"fileType": @"image", @"name": @"image", @"fileName": @"image.jpg", @"data": avatarData, @"mimeType": @"image/jpg"};
        [imageData addObject:avatar];
        NSLog(@"-----image Data:\n%@", imageData);
        
        [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
        [[ServerConnect sharedManager] UploadFiles:API_URL_OFFER withData:imageData withParams:(NSDictionary*)dic onSuccess:^(id json){
            [JSWaiter HideWaiter];
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
            NSLog(@"updated offer object--------%@", result);
            NSString *str = [result objectForKey:@"error"];
            int flag = [str intValue];
            if(flag == 0) {
                [self offerUpdate:[result objectForKey:@"offer"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSArray *msg = (NSArray *)[result objectForKey:@"messages"];
                NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
                if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please save again!";
                [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
                
            }
        }onFailure:^(NSInteger statusCode, id json) {
            [JSWaiter HideWaiter];
            [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
        }];
    }
}

#pragma mark - request data user profile change
- (void) requestUpdateOffer:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils myhttpJsonRequest:API_URL_OFFER withJSON:params];

    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSLog(@"updated offer object--------%@", result);
        NSDecimalNumber *status = [result objectForKey:@"error"];
        if([status intValue] == 0) {
            [self offerUpdate:[result objectForKey:@"offer"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            NSArray *msg = (NSArray *)[resObj objectForKey:@"messages"];
            NSString *stringMsg = (NSString *)[msg objectAtIndex:0];
            if([stringMsg isEqualToString:@""] || stringMsg == nil) stringMsg = @"Please save again!";
            [commonUtils showVAlertSimple:@"Warning" body:stringMsg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (void)offerUpdate:(NSDictionary*)offerObject{
    NSMutableArray* offers = [[NSMutableArray alloc] init];
    BOOL exist = NO;
    offers = appController.offersList;
    for(NSMutableDictionary* offer in offers){
        if([[offer objectForKey:@"id"] isEqualToString:[offerObject objectForKey:@"id"]]){
            NSUInteger index = [offers indexOfObject:offer];
            [offers replaceObjectAtIndex:index withObject:offerObject];
            exist = YES;
            break;
        }
    }
    if(exist == NO){
        [offers addObject:offerObject];
    }
    appController.offersList =  offers;
    [commonUtils setUserDefault:@"offerChanged" withFormat:@"1"];
}

- (IBAction)cancelClicked:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

@end
