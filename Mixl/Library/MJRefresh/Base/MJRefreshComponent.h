//  MJRefreshComponent.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"


typedef enum {
    
    MJRefreshStateIdle = 1,
   
    MJRefreshStatePulling,
    
    MJRefreshStateRefreshing,
    
    MJRefreshStateWillRefresh,
    
    MJRefreshStateNoMoreData
} MJRefreshState;


typedef void (^MJRefreshComponentRefreshingBlock)();


@interface MJRefreshComponent : UIView
{
    
    UIEdgeInsets _scrollViewOriginalInset;
    
    __weak UIScrollView *_scrollView;
}
#pragma mark -

@property (copy, nonatomic) MJRefreshComponentRefreshingBlock refreshingBlock;

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (weak, nonatomic) id refreshingTarget;

@property (assign, nonatomic) SEL refreshingAction;

- (void)executeRefreshingCallback;

#pragma mark -

- (void)beginRefreshing;

- (void)endRefreshing;

- (BOOL)isRefreshing;

@property (assign, nonatomic) MJRefreshState state;

#pragma mark -

@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;

@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark -

- (void)prepare NS_REQUIRES_SUPER;

- (void)placeSubviews NS_REQUIRES_SUPER;

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark -

@property (assign, nonatomic) CGFloat pullingPercent;

@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("please useautomaticallyChangeAlphaAttributes");

@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface UILabel(MJRefresh)
+ (instancetype)label;
@end
