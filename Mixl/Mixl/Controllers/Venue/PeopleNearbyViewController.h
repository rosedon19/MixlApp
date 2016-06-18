//
//  PeopleNearbyViewController.h
//  Mixl
//
//  Created by Branislav on 4/20/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleNearbyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *conllectionViewPeople;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOffers;

@property (weak, nonatomic) IBOutlet UIView *viewCurrentOffers;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (nonatomic, strong) NSMutableArray *peoplesNearBy, *offersList;

@end
