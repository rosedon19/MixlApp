
#import <UIKit/UIKit.h>

const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";

NSString *const MJRefreshHeaderIdleText = @"You can drop down to refresh";
NSString *const MJRefreshHeaderPullingText = @"Release immediately refresh";
NSString *const MJRefreshHeaderRefreshingText = @"Refreshing data ...";

NSString *const MJRefreshAutoFooterIdleText = @"y";
NSString *const MJRefreshAutoFooterRefreshingText = @"Sending message ... ";
NSString *const MJRefreshAutoFooterNoMoreDataText = @"Have all been loaded";

NSString *const MJRefreshBackFooterIdleText = @"Pullup can load more";
NSString *const MJRefreshBackFooterPullingText = @"Load more immediate release";
NSString *const MJRefreshBackFooterRefreshingText = @"Loading data ... more";
NSString *const MJRefreshBackFooterNoMoreDataText = @"Have all been loaded";