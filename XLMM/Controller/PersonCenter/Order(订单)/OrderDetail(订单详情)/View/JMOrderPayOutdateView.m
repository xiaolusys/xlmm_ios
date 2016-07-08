//
//  JMOrderPayOutdateView.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderPayOutdateView.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMSelecterButton.h"
#import "XlmmMall.h"

@interface JMOrderPayOutdateView ()
@property (nonatomic, strong) UILabel *outDateTitleLabel;
@property (nonatomic, strong) UILabel *orderOutdateTime;
@property (nonatomic, strong) JMSelecterButton *canelOrderButton;
@property (nonatomic, strong) JMSelecterButton *sureOrderButton;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation JMOrderPayOutdateView {
    NSTimer *_orderOutTimer;
    NSString *_dateStr;
    BOOL _isShow;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTopUI];
    }
    return self;
}
- (void)setStatusCount:(NSInteger)statusCount {
    _statusCount = statusCount;
    if (statusCount == ORDER_STATUS_WAITPAY) {
        _isShow = YES;
    }else {
        _isShow = NO;
    }
}
- (void)setCreateTimeStr:(NSString *)createTimeStr {
    if (_isShow) {
        _dateStr = @"";
        self.sureOrderButton.hidden = NO;
        self.canelOrderButton.hidden = NO;
        _createTimeStr = createTimeStr;
        _dateStr = [self formatterTimeString:createTimeStr];
        _orderOutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//        self.bottomView.hidden = NO;
    }else {
//        self.bottomView.hidden = YES;
        self.sureOrderButton.hidden = YES;
        self.canelOrderButton.hidden = YES;
        self.bottomView.hidden = YES;
    }
    
}
- (void)setUpTopUI {
    
    UIView *bottomView = [UIView new];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UILabel *outDateTitleLabel = [UILabel new];
    [self.bottomView addSubview:outDateTitleLabel];
    self.outDateTitleLabel = outDateTitleLabel;
    self.outDateTitleLabel.font = [UIFont systemFontOfSize:13.];
    self.outDateTitleLabel.textColor = [UIColor buttonTitleColor];
    self.outDateTitleLabel.text = @"支付剩余时间";
    
    UILabel *orderOutdateTime = [UILabel new];
    [self.bottomView addSubview:orderOutdateTime];
    self.orderOutdateTime = orderOutdateTime;
    self.orderOutdateTime.font = [UIFont systemFontOfSize:13.];
    self.orderOutdateTime.textColor = [UIColor buttonTitleColor];
    
    JMSelecterButton *canelOrderButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:canelOrderButton];
    self.canelOrderButton = canelOrderButton;
    [self.canelOrderButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"取消订单" TitleFont:14. CornerRadius:20];
    self.canelOrderButton.tag = 100;
    [self.canelOrderButton addTarget:self action:@selector(outDateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    JMSelecterButton *sureOrderButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:sureOrderButton];
    self.sureOrderButton = sureOrderButton;
    [self.sureOrderButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"立即支付" TitleFont:14. CornerRadius:20];
    self.sureOrderButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.sureOrderButton.tag = 101;
    [self.sureOrderButton addTarget:self action:@selector(outDateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    kWeakSelf
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.outDateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.bottomView).offset(10);
    }];
    
    [self.orderOutdateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.outDateTitleLabel);
        make.top.equalTo(weakSelf.outDateTitleLabel.mas_bottom).offset(10);
    }];
    
    [self.sureOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomView).offset(-10);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@40);
    }];
    
    [self.canelOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.sureOrderButton.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@40);
    }];
    
    
}
- (void)outDateClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeOutDateView:Index:)]) {
        [_delegate composeOutDateView:self Index:button.tag];
    }
}
- (void)timerFireMethod:(NSTimer*)theTimer {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    //  2015-10-29T15:50:19
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:_dateStr];
    //  NSLog(@"date = %@", date);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDate *todate = [NSDate dateWithTimeInterval:20 * 60 sinceDate:date];
    // NSLog(@"todate = %@", todate);
    //把目标时间装载入date
    //用来得到具体的时差
    NSDateComponents *d = [calendar components:unitFlags fromDate:[NSDate date] toDate:todate options:0];
    NSString *string = nil;
    string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
    // NSLog(@"string = %@", string);
    
    self.orderOutdateTime.text = string;
    if ([d minute] < 0 || [d second] < 0) {
        self.orderOutdateTime.text = @"00:00";
        self.canelOrderButton.hidden = YES;
        self.sureOrderButton.hidden = YES;
        self.bottomView.hidden = YES;
    }else {
        self.canelOrderButton.hidden = NO;
        self.sureOrderButton.hidden = NO;
        self.bottomView.hidden = NO;
    }

    
    
}
- (NSString *)formatterTimeString:(NSString *)timeString{
    if (timeString == nil) {
        return nil;
    }
    if ([timeString class] == [NSNull class]) {
        return nil;
    }
    NSMutableString *newString = [NSMutableString stringWithString:timeString];
    NSRange range = {10, 1};
    [newString replaceCharactersInRange:range withString:@" "];
    
    //    [newString deleteCharactersInRange:NSMakeRange(newString.length - 3, 3)];
    
    return newString;
}
@end





















































