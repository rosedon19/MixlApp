//  MJRefreshFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) 2015. All rights reserved.
//

#import "MJRefreshFooter.h"

@interface MJRefreshFooter()

@end

@implementation MJRefreshFooter
#pragma mark -
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark -
- (void)prepare
{
    [super prepare];
    
    
    self.mj_h = MJRefreshFooterHeight;
    
    
    self.automaticallyHidden = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        
        if ([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]]) {
            [self.scrollView setReloadDataBlock:^(NSInteger totalDataCount) {
                if (self.isAutomaticallyHidden) {
                    self.hidden = (totalDataCount == 0);
                }
            }];
        }
    }
}

#pragma mark - 
- (void)endRefreshingWithNoMoreData
{
    self.state = MJRefreshStateNoMoreData;
}

- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    self.state = MJRefreshStateIdle;
}
@end
