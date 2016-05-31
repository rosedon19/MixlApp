//
//  VenueProfileSreenViewController.m
//  Mixl
//
//  Created by Branislav on 4/21/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "VenueProfileSreenViewController.h"

@interface VenueProfileSreenViewController ()

@end

@implementation VenueProfileSreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView{
    _btnSeeOffers.layer.borderWidth = 2.0f;
    _btnSeeOffers.layer.cornerRadius = 3.0f;
    _btnSeeOffers.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //_lblVenueName.text = [NSString stringWithFormat:@"%@", [_venueInfo objectForKey:@"name"]];
    _lblVenueName.text = @"CAFE NAME";
    //_lblAddress.text = [NSString stringWithFormat:@"%@", [_venueInfo  objectForKey:@"address"]];
     _lblAddress.text = @"130 5th AVE";
    //_lblCityZipecode.text = [NSString stringWithFormat:@"%@, %@", [_venueInfo  objectForKey:@"city"], [_venueInfo  objectForKey:@"zipecode"]];
    _lblCityZipecode.text = @"New York, NY 100001";
    //_txtVenueAbout.text = [NSString stringWithFormat:@"%@", [_venueInfo  objectForKey:@"description"]];
    _txtVenueAbout.text = @"About sldkfjsdlkfjsldkfjlsk";
    
    //NSString *image = [_venueInfo objectForKey:@"image"];
    //[_imgVenue setImage:[UIImage imageNamed:image]];
    [_imgVenue setImage:[UIImage imageNamed:@"bar_menuhead"]];

}

- (IBAction)seeOffersClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OffersViewController* offersViewController =
    (OffersViewController*) [storyboard instantiateViewControllerWithIdentifier:@"BusicessOffersVC"];
    [self.navigationController pushViewController:offersViewController animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

@end
