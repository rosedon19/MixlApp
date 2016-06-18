//
//  MJRefreshStateHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshStateHeader()
{
    
    __weak UILabel *_lastUpdatedTimeLabel;
    
    __weak UILabel *_stateLabel;
}

@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshStateHeader
#pragma mark -
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

- (UILabel *)lastUpdatedTimeLabel
{
    if (!_lastUpdatedTimeLabel) {
        [self addSubview:_lastUpdatedTimeLabel = [UILabel label]];
    }
    return _lastUpdatedTimeLabel;
}

#pragma mark -
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark key
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    NSString* today = NSLocalizedString(@"Today", nil);
    NSString* last =NSLocalizedString(@"Latest update", nil);
    NSString* norecord =NSLocalizedString(@"No records", nil);
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) {
            formatter.dateFormat = [NSString stringWithFormat:@"%@ HH:mm", today];
        } else if ([cmp1 year] == [cmp2 year]) {
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@：%@", last, time];
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@：%@", last, norecord];
    }
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:MJRefreshHeaderIdleText forState:MJRefreshStateIdle];
    [self setTitle:MJRefreshHeaderPullingText forState:MJRefreshStatePulling];
    [self setTitle:MJRefreshHeaderRefreshingText forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        self.stateLabel.frame = self.bounds;
    } else {
        // 状态
        self.stateLabel.mj_x = 0;
        self.stateLabel.mj_y = 0;
        self.stateLabel.mj_w = self.mj_w;
        self.stateLabel.mj_h = self.mj_h * 0.5;
        
        // 更新时间
        self.lastUpdatedTimeLabel.mj_x = 0;
        self.lastUpdatedTimeLabel.mj_y = self.stateLabel.mj_h;
        self.lastUpdatedTimeLabel.mj_w = self.mj_w;
        self.lastUpdatedTimeLabel.mj_h = self.mj_h - self.lastUpdatedTimeLabel.mj_y;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
}
@end
