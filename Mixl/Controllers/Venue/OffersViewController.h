//
//  OffersViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersViewController : BaseViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *txtOfferName;
@property (weak, nonatomic) IBOutlet UITextField *txtExpirationTime;
@property (weak, nonatomic) IBOutlet UIButton    *btnTime;
@property (weak, nonatomic) IBOutlet UITableView *tableviewTime;
@property (weak, nonatomic) IBOutlet UITextView  *txtviewOffer;
@property (weak, nonatomic) IBOutlet UIButton    *btnPreview;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionGallery;

@property (nonatomic) int offerIndex;

@end
