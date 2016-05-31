//  UIScrollView+MJRefresh.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015. All rights reserved.
//  ScrollView

#import <UIKit/UIKit.h>

@class MJRefreshHeader, MJRefreshFooter;

@interface UIScrollView (MJRefresh)

@property (strong, nonatomic) MJRefreshHeader *header;

@property (strong, nonatomic) MJRefreshFooter *footer;

#pragma mark - other
- (NSInteger)totalDataCount;
@property (copy, nonatomic) void (^reloadDataBlock)(NSInteger totalDataCount);
@end
