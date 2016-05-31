//
//  UserSearchViewController.h
//  Mixl
//
//  Created by Branislav on 4/10/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSearchViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIView *viewPeopleTab;
@property (strong, nonatomic) IBOutlet UIView *viewFriendsTab;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UILabel *lblPeopleNearby;
@property (strong, nonatomic) IBOutlet UILabel *lblFriends;

@property (strong, nonatomic) IBOutlet UIView *viewPeopleNearby;
@property (strong, nonatomic) IBOutlet UIView *viewFriends;

@property (strong, nonatomic) IBOutlet UITableView *tablePeople;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionFriends;

@property (nonatomic) int tapType;

@end