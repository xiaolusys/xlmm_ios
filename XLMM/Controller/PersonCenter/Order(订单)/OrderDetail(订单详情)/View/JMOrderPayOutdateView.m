//
//  JMOrderPayOutdateView.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderPayOutdateView.h"
#import "JMSelecterButton.h"
#import "JMGoodsCountTime.h"


@interface JMOrderPayOutdateView ()
@property (nonatomic, strong) UILabel *outDateTitleLabel;
@property (nonatomic, strong) UILabel *orderOutdateTime;
@property (nonatomic, strong) JMSelecterButton *canelOrderButton;
@property (nonatomic, strong) JMSelecterButton *sureOrderButton;
//@property (nonatomic, strong) JMSelecterButton *shareButton;
@property (nonatomic, strong) UIView *bottomView;

//@property (nonatomic, strong) UIView *sharBottom;
//@property (nonatomic, strong) UIImageView *shareImage;
//@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) JMSelecterButton *teamBuyOrderButton;

@end

@implementation JMOrderPayOutdateView {
    NSString *_dateStr;
    BOOL _isShow;
    BOOL _isShowShare;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTopUI];
    }
    return self;
}
- (void)setIsTeamBuy:(BOOL)isTeamBuy {
    _isTeamBuy = isTeamBuy;
}
- (void)setStatusCount:(NSInteger)statusCount {
    _statusCount = statusCount;
    if (statusCount == ORDER_STATUS_WAITPAY) {
        _isShow = YES;
    }else {
        _isShow = NO;
    }
    if ((statusCount >= ORDER_STATUS_PAYED) && (statusCount <= ORDER_STATUS_TRADE_SUCCESS)) {
        if (_isTeamBuy) {
            _isShowShare = NO;
        }else {
            _isShowShare = NO;
        }
    }else {
        _isShowShare = NO;
    }
}
- (void)setCreateTimeStr:(NSString *)createTimeStr {
    if (_isShow) {
        _dateStr = @"";
        self.bottomView.hidden = NO;
        _createTimeStr = createTimeStr;
        _dateStr = [self formatterTimeString:createTimeStr];
        int endSecond = [[JMGlobal global] secondOfCurrentTimeInEndTime:_dateStr];
        int end = endSecond + 1200;
        [JMGoodsCountTime initCountDownWithCurrentTime:end];
        kWeakSelf
        [JMGoodsCountTime shareCountTime].countBlock = ^(int second) {
            second == -1 ? [weakSelf xiaoyu] : [weakSelf dayu:second];
        };
    }else {
        self.sureOrderButton.hidden = YES;
        self.canelOrderButton.hidden = YES;
        self.bottomView.hidden = YES;
        if (_isTeamBuy) {     // 如果是团购的话,就吧下面的继续支付和分享红包的视图给隐藏掉,只显示开团进展
            self.teamBuyOrderButton.hidden = NO;
            self.bottomView.hidden = NO;
        }
        if (_isShowShare) {
            self.bottomView.hidden = NO;
//            self.shareImage.hidden = NO;
//            self.descLabel.hidden = NO;
//            self.shareButton.hidden = NO;
//            self.sharBottom.hidden = NO;
        }
    }
    if (self.bottomView.hidden) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(0));
        }];
    }
}
- (void)xiaoyu {
    self.orderOutdateTime.text = @"00:00";
    self.bottomView.hidden = YES;
    self.canelOrderButton.hidden = YES;
    self.sureOrderButton.hidden = YES;
    self.orderOutdateTime.hidden = YES;
    self.outDateTitleLabel.hidden = YES;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(0));
    }];
}
- (void)dayu:(int)endTime {
    self.bottomView.hidden = NO;
    self.canelOrderButton.hidden = NO;
    self.sureOrderButton.hidden = NO;
    self.orderOutdateTime.hidden = NO;
    self.outDateTitleLabel.hidden = NO;
    self.orderOutdateTime.text = [NSString TimeformatMSFromSeconds:endTime];
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
    
    self.canelOrderButton.hidden = YES;
    self.sureOrderButton.hidden = YES;
    self.orderOutdateTime.hidden = YES;
    self.outDateTitleLabel.hidden = YES;
    self.bottomView.hidden = YES;
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
    // === 显示红包 === //
//    UIView *sharBottom = [UIView new];
//    [self addSubview:sharBottom];
//    self.sharBottom = sharBottom;
//    self.sharBottom.backgroundColor = [UIColor blackColor];
//    self.sharBottom.alpha = 0.8;
//    
//    UIImageView *shareImage = [UIImageView new];
//    [self.sharBottom addSubview:shareImage];
//    shareImage.image = [UIImage imageNamed:@"show_RedpageImage"];
//    self.shareImage = shareImage;
//    
//    UILabel *descLabel = [UILabel new];
//    [self.sharBottom addSubview:descLabel];
//    self.descLabel = descLabel;
//    self.descLabel.font = [UIFont systemFontOfSize:13.];
//    self.descLabel.textColor = [UIColor whiteColor];
//    self.descLabel.text = @"您获得一个红包可以分享给好友";
//    
//    JMSelecterButton *shareButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
//    [self.sharBottom addSubview:shareButton];
//    self.shareButton = shareButton;
//    [self.shareButton setSureBackgroundColor:[UIColor buttonEnabledBackgroundColor] CornerRadius:10.];
//    [self.shareButton setTitle:@"立即分享" forState:UIControlStateNormal];
//    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:13.];
//    self.shareButton.tag = 102;
//    [self.shareButton addTarget:self action:@selector(outDateClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.sharBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(weakSelf);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@65);
//    }];
//    
//    self.sharBottom.hidden = YES;
//    self.shareImage.hidden = YES;
//    self.descLabel.hidden = YES;
//    self.shareButton.hidden = YES;
//    
//    [shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.sharBottom).offset(10);
//        make.centerY.equalTo(weakSelf.sharBottom.mas_centerY);
//        make.width.height.mas_equalTo(@28);
//    }];
//    
//    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(shareImage.mas_right).offset(10);
//        make.centerY.equalTo(weakSelf.sharBottom.mas_centerY);
//    }];
//    
//    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.sharBottom).offset(-10);
//        make.centerY.equalTo(weakSelf.sharBottom.mas_centerY);
//        make.width.mas_equalTo(@70);
//        make.height.mas_equalTo(@25);
//    }];
//    
    // 如果是团购 - 订单详情的话,底部视图是一个查看拼团进展的按钮
    self.teamBuyOrderButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.teamBuyOrderButton];
    [self.teamBuyOrderButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"查看拼团进展" TitleFont:16. CornerRadius:20.];
    self.teamBuyOrderButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.teamBuyOrderButton.tag = 103;
    [self.teamBuyOrderButton addTarget:self action:@selector(outDateClick:) forControlEvents:UIControlEventTouchUpInside];
    self.teamBuyOrderButton.hidden = YES;
    [self.teamBuyOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.centerX.equalTo(weakSelf.bottomView.mas_centerX);
        make.width.mas_equalTo(@(SCREENWIDTH - 30));
        make.height.mas_equalTo(@40);
    }];
    
}
- (void)outDateClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeOutDateView:Index:)]) {
        [_delegate composeOutDateView:self Index:button.tag];
    }
}
- (NSString *)formatterTimeString:(NSString *)timeString{
    if ([NSString isStringEmpty:timeString]) {
        return nil;
    }
    return [NSString jm_deleteTimeWithT:timeString];
}



@end








































//        self.orderOutTimer = [NSTimer scheduledTimerWithTimeInterval:0. target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.orderOutTimer forMode:NSRunLoopCommonModes];
//- (void)timerFireMethod:(NSTimer*)theTimer {
//    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
//    [formatter setTimeStyle:NSDateFormatterMediumStyle];
//    //  2015-10-29T15:50:19
////    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
//    NSDate *date = [formatter dateFromString:_dateStr];
//    //  NSLog(@"date = %@", date);
//
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    unsigned int unitFlags = NSCalendarUnitYear |
//    NSCalendarUnitMonth |
//    NSCalendarUnitDay |
//    NSCalendarUnitHour |
//    NSCalendarUnitMinute |
//    NSCalendarUnitSecond;
//    NSDate *todate = [NSDate dateWithTimeInterval:20 * 60 sinceDate:date];
//
//    // NSLog(@"todate = %@", todate);
//    //把目标时间装载入date
//    //用来得到具体的时差
//    NSDateComponents *d = [calendar components:unitFlags fromDate:[NSDate date] toDate:todate options:0];
//    NSString *string = nil;
//    string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
//    // NSLog(@"string = %@", string);
//
//    self.orderOutdateTime.text = string;
//    if ([d minute] < 0 || [d second] < 0) {
//        self.orderOutdateTime.text = @"00:00";
//        self.bottomView.hidden = YES;
//        self.canelOrderButton.hidden = YES;
//        self.sureOrderButton.hidden = YES;
//        self.orderOutdateTime.hidden = YES;
//        self.outDateTitleLabel.hidden = YES;
//        [UIView animateWithDuration:0.3 animations:^{
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(@(0));
//            }];
//        }];
//        if ([self.orderOutTimer isValid]) {
//            [self.orderOutTimer invalidate];
//            self.orderOutTimer = nil;
//        }
////        self.shareImage.hidden = NO;
////        self.descLabel.hidden = NO;
////        self.shareButton.hidden = NO;
////        self.sharBottom.hidden = NO;
//    }else {
//        self.bottomView.hidden = NO;
//        self.canelOrderButton.hidden = NO;
//        self.sureOrderButton.hidden = NO;
//        self.orderOutdateTime.hidden = NO;
//        self.outDateTitleLabel.hidden = NO;
//    }
//}












