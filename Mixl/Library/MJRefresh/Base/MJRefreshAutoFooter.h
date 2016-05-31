//
//  MJRefreshAutoFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015. All rights reserved.
//

#import "MJRefreshFooter.h"

@interface MJRefreshAutoFooter : MJRefreshFooter

@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;


@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("please useautomaticallyChangeAlphaAttributes");


@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
