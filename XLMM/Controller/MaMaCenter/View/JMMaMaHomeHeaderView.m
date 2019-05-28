//
//  JMMaMaHomeHeaderView.m
//  XLMM
//
//  Created by zhang on 16/11/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaHomeHeaderView.h"
#import "JMMaMaMessageCell.h"
#import "JMMaMaCenterModel.h"
#import "JMMaMaExtraModel.h"
#import "JMRichTextTool.h"
#import "JMStoreManager.h"
#import "DotLineView.h"
#import "NSArray+Reverse.h"
#import "UIColor+FSPalette.h"


static NSString *currentTurnsNumberString;

@interface JMMaMaHomeHeaderView () <JMAutoLoopPageViewDataSource,JMAutoLoopPageViewDelegate,UIScrollViewDelegate> {
    int quxiaodays;
    NSMutableArray *allDingdan;
    CGPoint scrollViewContentOffset;
    NSMutableArray *dataArray;
    
    UILabel *_lingqianLabel;
    UILabel *_xiaolubiLabel;
    UILabel *_youhuiquanLabel;
    UILabel *_daizhifuLabel;
    UILabel *_daishouhuoLabel;
    UILabel *_tuihuanhuoLabel;
    UILabel *_wodedingdanLabel;
    UILabel *_jinrifangkeLabel;
    UILabel *_jinridingdanLabel;
    UILabel *_jinrishouyiLabel;
    UILabel *_leijishouyiLabel;
    UILabel *_fangkejiluLabel;
    UILabel *_dingdanjuluLabel;
    UILabel *_wodefensiLabel;
    
    UIButton *_headImageButton;
    UIView *_headMamaInfo;
    UILabel *_idLabel;
    UILabel *_mamaTypeLabel;
    UIImageView *_topImageView;
    
}

@property (nonatomic, strong) UIView *wodedianpuView;          // 我的店铺视图

@property (nonatomic, strong) UILabel *idLabel;                // 妈妈ID
@property (nonatomic, strong) UILabel *isMaMaVipLabel;         // 妈妈的VIP状态
@property (nonatomic, strong) UILabel *mamaLeveLabel;          // 妈妈的VIP等级
@property (nonatomic, strong) UIImageView *iconImage;          // 妈妈头像
@property (nonatomic, strong) UILabel *redCircle;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *smallChangeLabel;
@property (nonatomic, strong) UILabel *integralLabel;
@property (nonatomic, strong) UILabel *couponLabel;


@property (nonatomic, strong) UILabel *todayEarningsLabel;
@property (nonatomic, strong) UILabel *futureEarningsLabe;
@property (nonatomic, strong) UILabel *rankingLabel;

@property (nonatomic, strong) UIImageView *animationImage;
@property (nonatomic, strong) UILabel *currentTurnsLabel;
@property (nonatomic, strong) UILabel *finishProgressLabel;
/**
 *  折线视图
 */
@property (nonatomic, strong) UIScrollView *foldLineScrollView;
@property (nonatomic, strong) UIImageView *mamaImage;
@property (nonatomic, strong) UILabel *memberLabel;            // 会员剩余期限
@property (nonatomic, strong) UIButton *renewButton;           // 续费按钮
@property (nonatomic, strong) UILabel *messagePromptLabel;
@property (nonatomic, strong) NSNumber *weekDay;
@property (nonatomic, strong) NSNumber *visitorDate;

@property (nonatomic, strong) UIView *orongeCircleView;
@property (nonatomic, strong) UIView *anotherOrongeView;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *lastweeknames;
@property (nonatomic, strong) NSMutableArray *anotherLabelArray;
@property (nonatomic, strong) NSArray *mamaOrderArray;



@property (nonatomic, strong) NSMutableArray *titlesArray;


@end

@implementation JMMaMaHomeHeaderView

- (NSMutableArray *)titlesArray {
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor countLabelColor];
        self.visitorDate = [NSNumber numberWithInt:0];
        dataArray = [[NSMutableArray alloc] initWithCapacity:30];
        allDingdan = [[NSMutableArray alloc] init];
        self.labelArray = [[NSMutableArray alloc] init];
        self.lastweeknames = [[NSMutableArray alloc] init];
        self.anotherLabelArray = [[NSMutableArray alloc] init];
        [self initUI];
//        [self createWeekDay];
//        [self createButtons];
//        [self createChart:dataArray];
        
    }
    return self;
}
- (void)setCenterModel:(JMMaMaCenterModel *)centerModel {
    _centerModel = centerModel;
    _currentTurnsNum = self.centerModel.current_dp_turns_num;
    
    NSDictionary *extraDic = centerModel.extra_info;
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:extraDic];
//    NSDictionary *exDic = self.centerModel.extra_info;
//    NSDictionary *extraFiguresDic = self.centerModel.extra_figures;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[self.extraModel.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];  // 妈妈头像
    _idLabel.text = [NSString stringWithFormat:@"ID: %@",centerModel.mama_id];                        // 妈妈ID
    _mamaTypeLabel.text = centerModel.mama_level_display;                                       // 妈妈的VIP状态
//    self.mamaLeveLabel.text = self.extraModel.agencylevel_display;                                            // 妈妈的VIP等级
    
//    
//    CGFloat finisF = [extraFiguresDic[@"task_percentage"] floatValue];
//    NSString *finishProStr = [NSString stringWithFormat:@"%.f%%",finisF * 100];
//    self.finishProgressLabel.text = CS_DSTRING(@"本周任务已完成 ",finishProStr);
//    NSString *limtStr = CS_STRING(exDic[@"surplus_days"]);                                              // 会员剩余期限
//    if ([NSString isStringEmpty:limtStr]) {
//        limtStr = @"0";
//    }
//    NSString *numStr = [NSString stringWithFormat:@"会员剩余期限%@天",limtStr];
//    self.memberLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:numStr SubStringArray:@[limtStr]];
    
    NSString *currentTime = [NSString getCurrentYMD];
    if ([JMStoreManager isFileExist:@"currentTurnsData.plist"]) { // 存在这个字典
        NSDictionary *dict = [JMStoreManager getDataDictionary:@"currentTurnsData.plist"];
        NSString *saveTime = dict[@"currentTime"];
        NSString *saveNum = dict[@"currentNum"];
        [JMStoreManager removeFileByFileName:@"currentTurnsData.plist"];
        NSDictionary *currentDict = [NSDictionary dictionaryWithObjectsAndKeys:currentTime,@"currentTime",_currentTurnsNum,@"currentNum", nil];
        [JMStoreManager saveDataFromDictionary:@"currentTurnsData.plist" WithData:currentDict];
        if ([currentTime isEqualToString:saveTime]) { // 判断是否为当天
            NSInteger turnsNum = labs([_currentTurnsNum integerValue] - [saveNum integerValue] + [currentTurnsNumberString integerValue]);
            _currentTurnsNum = [NSString stringWithFormat:@"%ld",turnsNum];
        }else {
        }
    }else {  // 不存在这个字典
        NSDictionary *currentDict = [NSDictionary dictionaryWithObjectsAndKeys:currentTime,@"currentTime",_currentTurnsNum,@"currentNum", nil];
        [JMStoreManager saveDataFromDictionary:@"currentTurnsData.plist" WithData:currentDict];
    }
    currentTurnsNumberString = _currentTurnsNum;
    self.currentTurnsNum = [NSString stringWithFormat:@"%@",currentTurnsNumberString];
    [self currentTurnsNum:currentTurnsNumberString];
    
//    _wodetixianLabel.text = [NSString stringWithFormat:@"%.2f元",[self.centerModel.cash_value floatValue]];                   // 我的提现
    _leijishouyiLabel.text = [NSString stringWithFormat:@"%.2f元",[self.centerModel.carry_value floatValue]];                  // 累计收益
    _fangkejiluLabel.text = @"查看访客记录";                                                                                   // 访客记录
    _dingdanjuluLabel.text = [NSString stringWithFormat:@"%@个",self.centerModel.order_num];                                   // 订单记录
//    _label5.text = [NSString stringWithFormat:@"%@点",self.centerModel.active_value_num];                            // 活跃度
    _wodefensiLabel.text = [NSString stringWithFormat:@"%@人",self.centerModel.fans_num];                                    // 我的粉丝
    //    self.label7.text = @"个人排名Top10";                                                                                 // 个人收益排名

}
- (void)setUserInfoDic:(NSDictionary *)userInfoDic {
    _userInfoDic = userInfoDic;
    if (_userInfoDic != nil) {
        BOOL isXLMM = [JMUserDefaults boolForKey:kISXLMM];
        if (isXLMM) {
            self.wodedianpuView.hidden = NO;
            CGFloat space = 40 * HomeCategoryRatio;
            [_headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_topImageView).offset(space);
            }];
            _headMamaInfo.hidden = NO;
        }else {
            [_headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_topImageView).offset(SCREENWIDTH / 2 - 45);
            }];
            _headMamaInfo.hidden = YES;
            self.wodedianpuView.hidden = YES;
        }
        NSString *nickName = [userInfoDic objectForKey:@"nick"];
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[userInfoDic objectForKey:@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        if (nickName.length > 0 || [nickName class] != [NSNull null]) {
            self.userNameLabel.text = [userInfoDic objectForKey:@"nick"];
        }
        _xiaolubiLabel.text = [NSString stringWithFormat:@"%.2f",[userInfoDic[@"xiaolu_coin"] floatValue]];//[[dict objectForKey:@"xiaolu_coin"] stringValue];
        //判断是否为0
        if ([[userInfoDic objectForKey:@"user_budget"] isKindOfClass:[NSNull class]]) {
            _lingqianLabel.text  = [NSString stringWithFormat:@"0.00"];
        }else {
            NSDictionary *xiaolumeimei = [userInfoDic objectForKey:@"user_budget"];
            NSNumber *num = [xiaolumeimei objectForKey:@"budget_cash"];
            _lingqianLabel.text  = [NSString stringWithFormat:@"%.2f", [num floatValue]];
        }
        _youhuiquanLabel.text = [NSString stringWithFormat:@"%@", userInfoDic[@"coupon_num"]];
        
        //应用打开时判断是否是小鹿妈妈
//        NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//        if ([[userInfoDic objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]) {
//            [users setBool:YES forKey:@"isXLMM"];
//        }else {
//            [users setBool:NO forKey:@"isXLMM"];
//        }
//        [users synchronize];
        //判断是否绑定手机号或者设置密码
        NSString *mobile = [userInfoDic objectForKey:@"mobile"];
        if ([[userInfoDic objectForKey:@"has_password"] integerValue] == 0 ||  ([mobile class] == [NSNull null] || [mobile isEqualToString:@""])) {
            [self setRedCircleDisplay];
        }else {
            self.redCircle.hidden = YES;
        }
        NSString *waitPayString = userInfoDic[@"waitpay_num"];
        NSString *waitGoodsString = userInfoDic[@"waitgoods_num"];
        NSString *refundString = userInfoDic[@"refunds_num"];
        if ([waitPayString integerValue] != 0) {
            _daizhifuLabel.hidden = NO;
            _daizhifuLabel.text = CS_STRING(waitPayString);
        }else {
            _daizhifuLabel.hidden = YES;
        }
        if ([waitGoodsString integerValue] != 0) {
            _daishouhuoLabel.hidden = NO;
            _daishouhuoLabel.text = CS_STRING(waitGoodsString);
        }else {
            _daishouhuoLabel.hidden = YES;
        }
        if ([refundString integerValue] != 0) {
            _tuihuanhuoLabel.hidden = NO;
            _tuihuanhuoLabel.text = CS_STRING(refundString);
        }else {
            _tuihuanhuoLabel.hidden = YES;
        }

    }else { // 退出登录
        [_headImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topImageView).offset(SCREENWIDTH / 2 - 45);
        }];
        _headMamaInfo.hidden = YES;
        self.wodedianpuView.hidden = YES;
        
        self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
        self.userNameLabel.text = @"点击登录";
        self.redCircle.hidden = YES;
        _lingqianLabel.text = @"0.00";
        _xiaolubiLabel.text = @"0";
        _youhuiquanLabel.text = @"0";
        _daizhifuLabel.hidden = YES;
        _daishouhuoLabel.hidden = YES;
        _tuihuanhuoLabel.hidden = YES;
        
    }
}
- (void)setRedCircleDisplay {
    self.redCircle.backgroundColor = [UIColor redColor];
    self.redCircle.layer.cornerRadius = 5;
    self.redCircle.layer.masksToBounds = YES;
    self.redCircle.hidden = NO;
}
- (void)currentTurnsNum:(NSString *)currentTurnsNum {
    if ([currentTurnsNum isEqual:@"0"]) {
    }else {
        self.currentTurnsLabel.hidden = NO;
        self.currentTurnsLabel.text = currentTurnsNum;
    }
}


- (void)setMamaNotReadNotice:(NSString *)mamaNotReadNotice {
    _mamaNotReadNotice = mamaNotReadNotice;
}
//- (void)setWithDrawMoney:(NSString *)withDrawMoney {
//    _withDrawMoney = withDrawMoney;
//    
//}
- (void)setMamaResults:(NSArray *)mamaResults {
    [self mamaResults:mamaResults];
}
- (void)mamaResults:(NSArray *)mamaResults {
    NSArray *data = [NSArray reverse:mamaResults];
    self.mamaOrderArray = data;
    NSDictionary *dic = data[0];
    data = mamaResults;
    
    _jinrifangkeLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
    _jinridingdanLabel.text = [dic[@"order_num"] stringValue];                           // 订单
    _jinrishouyiLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益

}


- (void)initUI {
    kWeakSelf
    // ==== 顶部视图 ==== //  按钮tag --> 头像:100  零钱,小鹿币,优惠券 101:102:103
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    _topImageView.image = [UIImage imageNamed:@"wodejingxuanback"];
    _topImageView.userInteractionEnabled = YES;
    [self addSubview:_topImageView];
    
    CGFloat headButtonSpace = 20 * HomeCategoryRatio;
    
    _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topImageView addSubview:_headImageButton];
    _headImageButton.tag = 100;
    [_headImageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.iconImage = [UIImageView new];
    self.iconImage.backgroundColor = [UIColor whiteColor];
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 1;
    [_headImageButton addSubview:self.iconImage];
    
    self.redCircle = [UILabel new];
    [_headImageButton addSubview:self.redCircle];
    self.redCircle.hidden = YES;
    
    self.userNameLabel = [UILabel new];
    self.userNameLabel.font = CS_UIFontSize(12.);
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.text = @"点击登录";
    [_headImageButton addSubview:self.userNameLabel];
    
    _headMamaInfo = [UIView new];
    [_topImageView addSubview:_headMamaInfo];
    _headMamaInfo.hidden = YES;
    _idLabel = [UILabel new];
    [_headMamaInfo addSubview:_idLabel];
    _idLabel.font = [UIFont boldSystemFontOfSize:16.];
    _idLabel.textColor = [UIColor blackColor];
    _idLabel.text = @"ID:";
    
    _mamaTypeLabel = [UILabel new];
    [_headMamaInfo addSubview:_mamaTypeLabel];
    _mamaTypeLabel.font = [UIFont systemFontOfSize:15.];
    _mamaTypeLabel.textColor = [UIColor buttonTitleColor];
//    mamaTypeLabel.text = @"";
    [_headMamaInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImageView).offset(30);
        make.right.equalTo(_topImageView).offset(-headButtonSpace);
        make.width.mas_equalTo(@(SCREENWIDTH / 2 - headButtonSpace));
        make.height.mas_equalTo(@(90));
    }];
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headMamaInfo.mas_centerX);
        make.top.equalTo(_headMamaInfo).offset(20);
    }];
    [_mamaTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headMamaInfo.mas_centerX);
        make.top.equalTo(_idLabel.mas_bottom).offset(5);
    }];
    
    [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImageView).offset(30);
//        make.centerX.equalTo(topImageView.mas_centerX);
        make.left.equalTo(_topImageView).offset(SCREENWIDTH / 2 - 45);
        make.width.height.mas_equalTo(@90);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.center.equalTo(headImageButton);
        make.centerX.equalTo(_headImageButton.mas_centerX);
        make.top.equalTo(_headImageButton);
        make.width.height.mas_equalTo(@60);
    }];
    [self.redCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(headImageButton.mas_centerX).offset(20);
        //        make.centerY.equalTo(headImageButton.mas_centerY).offset(-20);
        make.top.equalTo(_headImageButton).offset(5);
        make.right.equalTo(_headImageButton).offset(-20);
        make.width.height.mas_equalTo(@10);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.mas_centerX);
        make.top.equalTo(self.iconImage.mas_bottom).offset(10);
    }];
    CGFloat buttonW = (SCREENWIDTH - headButtonSpace * 2) / 3;
    NSArray *imageArr0 = @[@"accounticon",@"pointicon",@"coupon"];
    NSArray *titleArr0 = @[@"零钱",@"小鹿币",@"优惠券"];
    for (int i = 0; i < titleArr0.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topImageView addSubview:button];
        button.frame = CGRectMake(headButtonSpace + buttonW * i, 130, buttonW, 40);
        button.tag = 101 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *valueLabel = [UILabel new];
        [button addSubview:valueLabel];
        valueLabel.font = CS_UIFontSize(16.);
        valueLabel.textColor = [UIColor buttonTitleColor];
        valueLabel.tag = 200 + i;
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setImage:[UIImage imageNamed:imageArr0[i]] forState:UIControlStateNormal];
        [button1 setTitle:titleArr0[i] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:11.];
        button1.userInteractionEnabled = NO;
        [button addSubview:button1];

        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(button).offset(4);
        }];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(valueLabel.mas_bottom).offset(2);
        }];
        
    }
//    self.smallChangeLabel = (UILabel *)[self viewWithTag:10];
//    self.integralLabel = (UILabel *)[self viewWithTag:11];
//    self.couponLabel = (UILabel *)[self viewWithTag:12];

    
    // ==== 我的订单 ==== // 按钮tag --> 待支付.....  104 ... 107
    CGFloat sectionSpace = (SCREENWIDTH / 2 - 130) / 2;
    CGFloat itemSizeWidth = SCREENWIDTH / 4;
    UIView *wodeOrder = [[UIView alloc] initWithFrame:CGRectMake(0, _topImageView.mj_max_Y, SCREENWIDTH, itemSizeWidth + 20)];
    [self addSubview:wodeOrder];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [wodeOrder addSubview:sectionView];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleSectionLabel = [UILabel new];
    [sectionView addSubview:titleSectionLabel];
    titleSectionLabel.font = [UIFont systemFontOfSize:13.];
    titleSectionLabel.textColor = [UIColor buttonTitleColor];
    titleSectionLabel.text = @"我的订单";
    
    UILabel *leftLabel = [UILabel new];
    [sectionView addSubview:leftLabel];
    leftLabel.backgroundColor = [UIColor dingfanxiangqingColor];
    
    UILabel *rightLabel = [UILabel new];
    [sectionView addSubview:rightLabel];
    rightLabel.backgroundColor = [UIColor dingfanxiangqingColor];
    
    [titleSectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.centerY.equalTo(sectionView.mas_centerY);
//        make.width.mas_equalTo(@(100));
    }];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleSectionLabel.mas_centerY);
        make.left.equalTo(sectionView).offset(sectionSpace);
        make.size.mas_offset(CGSizeMake(80, 0.5));
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleSectionLabel.mas_centerY);
        make.right.equalTo(sectionView).offset(-sectionSpace);
        make.size.mas_offset(CGSizeMake(80, 0.5));
    }];
    
//    UIView *orderSectionView = [self createSectionViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20) Title:@"我的订单"];
//    [wodeOrder addSubview:orderSectionView];
    
    NSArray *imageArr1 = @[@"waitpay",@"waitsend",@"refund",@"alltrades"];
    NSArray *titleArr1 = @[@"待支付",@"待收货",@"退换货",@"全部订单"];
    for (int i = 0; i < titleArr1.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        [wodeOrder addSubview:button];
        button.tag = 104 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(itemSizeWidth * (i % 4), 30, itemSizeWidth, itemSizeWidth - 10);
        
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr1[i]];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(@24);
        }];
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr1[i];
        titleLabel.font = [UIFont systemFontOfSize:12.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-15);
            make.centerX.equalTo(iconImage.mas_centerX);
        }];
        UILabel *oederNumLabel = [UILabel new];
        [iconImage addSubview:oederNumLabel];
        oederNumLabel.textColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
        oederNumLabel.backgroundColor = [UIColor whiteColor];
        oederNumLabel.textAlignment = NSTextAlignmentCenter;
        oederNumLabel.font = CS_UIFontBoldSize(11.);
        oederNumLabel.layer.masksToBounds = YES;
        oederNumLabel.layer.cornerRadius = 9.;
        oederNumLabel.layer.borderWidth = 1.5;
        oederNumLabel.layer.borderColor = [UIColor colorWithR:255 G:56 B:64 alpha:1].CGColor;
        oederNumLabel.hidden = YES;
        oederNumLabel.tag = 203 + i;
        [oederNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconImage).offset(10);
            make.centerY.equalTo(iconImage).offset(-10);
            make.width.height.mas_equalTo(@(18));
        }];
    }
    // ==== 我的店铺 ==== // 按钮tag --> 今日访客.....  108 ... 119
    UIView *wodedianpuView = [[UIView alloc] initWithFrame:CGRectMake(0, wodeOrder.mj_max_Y + 15, SCREENWIDTH, 425)];
    [self addSubview:wodedianpuView];
    self.wodedianpuView = wodedianpuView;
    wodedianpuView.hidden = YES;
    
    UIView *sectionView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [wodedianpuView addSubview:sectionView1];
    sectionView1.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel1 = [UILabel new];
    titleLabel1.font = [UIFont systemFontOfSize:13.];
    titleLabel1.textColor = [UIColor buttonTitleColor];
    titleLabel1.text = @"我的店铺";
    [sectionView1 addSubview:titleLabel1];
    
    UILabel *leftLabel1 = [UILabel new];
    [sectionView1 addSubview:leftLabel1];
    leftLabel1.backgroundColor = [UIColor dingfanxiangqingColor];
    
    UILabel *rightLabel1 = [UILabel new];
    [sectionView1 addSubview:rightLabel1];
    rightLabel1.backgroundColor = [UIColor dingfanxiangqingColor];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sectionView1);
    }];
    [leftLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel1.mas_centerY);
        make.left.equalTo(sectionView).offset(sectionSpace);
        make.size.mas_offset(CGSizeMake(80, 0.5));
    }];
    [rightLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel1.mas_centerY);
        make.right.equalTo(sectionView).offset(-sectionSpace);
        make.size.mas_offset(CGSizeMake(80, 0.5));
    }];
    
//    UIView *wodedianpuSectionView = [self createSectionViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20) Title:@"我的店铺"];
//    [wodedianpuView addSubview:wodedianpuSectionView];
    
    // 消息滚动列表
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 45)];
    [wodedianpuView addSubview:messageView];
    messageView.layer.masksToBounds = YES;
    messageView.layer.borderWidth = 0.5;
    messageView.layer.borderColor = [UIColor countLabelColor].CGColor;
    messageView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *promptImage = [UIImageView new];
    [messageView addSubview:promptImage];
    promptImage.image = [UIImage imageNamed:@"messageImage"];
    
    UILabel *unReadMessageLabel = [UILabel new];
    [promptImage addSubview:unReadMessageLabel];
    unReadMessageLabel.textColor = [UIColor whiteColor];
    unReadMessageLabel.font = CS_UIFontSize(10.);
    unReadMessageLabel.backgroundColor = [UIColor redColor];
    unReadMessageLabel.layer.cornerRadius = 5.;
    unReadMessageLabel.layer.masksToBounds = YES;
    self.messagePromptLabel = unReadMessageLabel;
    self.messagePromptLabel.hidden = YES;
    
    UIView *messageScrollView = [UIView new];
    [messageView addSubview:messageScrollView];
    
    self.pageView = [[JMAutoLoopPageView alloc] init];
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    self.pageView.isCreatePageControl = NO;
    [self.pageView registerCellWithClass:[JMMaMaMessageCell class] identifier:@"JMMaMaMessageCell"];
    self.pageView.scrollStyle = JMAutoLoopScrollStyleVertical;
    self.pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
    self.pageView.scrollForSingleCount = YES;
    self.pageView.atuoLoopScroll = YES;
    self.pageView.scrollFuture = YES;
    self.pageView.autoScrollInterVal = 3.0f;
    [messageView addSubview:self.pageView];
    
    [promptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageView).offset(15);
        make.width.height.mas_equalTo(@18);
        make.centerY.equalTo(messageView.mas_centerY);
    }];
    [unReadMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptImage).offset(-5);
        make.right.equalTo(promptImage).offset(5);
        make.width.height.mas_equalTo(10);
    }];
    [messageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptImage.mas_right).offset(15);
        make.top.bottom.right.equalTo(messageView);
    }];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(messageScrollView);
        make.centerY.equalTo(messageScrollView.mas_centerY);
        make.height.mas_equalTo(@40);
    }];
    
    // 个人收益视图 //
    UIView *toolView = [UIView new];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.frame = CGRectMake(0, 75, SCREENWIDTH, 60);
    [wodedianpuView addSubview:toolView];
    
    CGFloat toolW = SCREENWIDTH / 3;
    NSArray *earningsArr = @[@"访客",@"订单",@"收益"];
    NSInteger earningCount = 3;
    for (int i = 0 ; i < earningCount; i++) {
        UIButton *earningsV = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolView addSubview:earningsV];
        [earningsV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(toolW));
            make.height.mas_equalTo(@60);
            make.centerY.equalTo(toolView.mas_centerY);
            make.centerX.equalTo(toolView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)earningCount + 0));
        }];
        earningsV.tag = 108 + i;
        [earningsV addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *earningsLabel = [UILabel new];
        [earningsV addSubview:earningsLabel];
        earningsLabel.font = [UIFont systemFontOfSize:14.];
        earningsLabel.textColor = [UIColor buttonTitleColor];
        earningsLabel.text = earningsArr[i];
        [earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(earningsV).offset(10);
            make.centerX.equalTo(earningsV.mas_centerX);
        }];
        UILabel *earningsValueLabel = [UILabel new];
        [earningsV addSubview:earningsValueLabel];
        earningsValueLabel.font = [UIFont boldSystemFontOfSize:18.];
        earningsValueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
        [earningsValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(earningsLabel.mas_bottom).offset(5);
            make.centerX.equalTo(earningsV.mas_centerX);
        }];
        earningsValueLabel.tag = 207 + i;
    }


    
    NSArray *imageArr2 = @[@"mamaeryaoqingColor",@"EverydayPushNormalColor",@"selectionShopNormalColor",@"inviteShopNormalColor"];
    NSArray *titleArr2 = @[@"分享店铺",@"每日推送",@"选品佣金",@"邀请开店"];
    UIView *selectBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, SCREENWIDTH, 90)];
    selectBoxView.backgroundColor = [UIColor whiteColor];
    [wodedianpuView addSubview:selectBoxView];
    for (int i = 0; i < titleArr2.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        [selectBoxView addSubview:button];
        button.tag = 111 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(SCREENWIDTH / 4 * (i % 4), 0, SCREENWIDTH / 4, 90);
        
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.tag = 10 + i;
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr2[i]];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(button).offset(25);
            //            make.width.height.mas_equalTo(@25);
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr2[i];
        titleLabel.font = [UIFont systemFontOfSize:12.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-15);
            make.centerX.equalTo(iconImage.mas_centerX);
        }];
        
        
    }
    self.animationImage = (UIImageView *)[self viewWithTag:11];
    self.currentTurnsLabel = [UILabel new];
    [self.animationImage addSubview:self.currentTurnsLabel];
    self.currentTurnsLabel.textColor = [UIColor whiteColor];
    self.currentTurnsLabel.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    self.currentTurnsLabel.textAlignment = NSTextAlignmentCenter;
    self.currentTurnsLabel.font = CS_UIFontSize(9.);
    self.currentTurnsLabel.layer.masksToBounds = YES;
    self.currentTurnsLabel.layer.cornerRadius = 7.;
    self.currentTurnsLabel.hidden = YES;
    [self.currentTurnsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.animationImage).offset(15);
        make.centerY.equalTo(weakSelf.animationImage).offset(-15);
        make.width.height.mas_equalTo(@(14));
    }];
    
    
    NSArray *imageArr3 = @[@"leijishouyi",@"fangkejilu",@"dingdanjilu",@"wodefensi"]; // ,@"gerenpaiming",@"tuanduipaiming"
    NSArray *titleArr3 = @[@"累计收益",@"访客记录",@"订单记录",@"我的粉丝"];
    NSArray *titleDescArr3 = @[@"88.88元",@"查看访客记录",@"88个",@"88人"];
    
    UIView *selectBoxView2 = [[UIView alloc] initWithFrame:CGRectMake(0, selectBoxView.mj_max_Y + 15, SCREENWIDTH, 130)];
    //    selectBoxView.backgroundColor = [UIColor countLabelColor];
    [wodedianpuView addSubview:selectBoxView2];
    
    CGFloat buttonWidth = SCREENWIDTH / 2;
    for (int i = 0; i < titleArr3.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        button.backgroundColor = [UIColor whiteColor];
        [selectBoxView2 addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBoxView2).offset(65 * (i / 2) + (i / 4) * 15);
            make.left.equalTo(selectBoxView2).offset((i % 2) * buttonWidth);
            make.width.mas_equalTo(@(buttonWidth));
            make.height.mas_equalTo(@65);
        }];
        
        button.tag = 115 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr3[i]];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(15);
            //            make.width.height.mas_equalTo(@25);
            make.centerY.equalTo(button.mas_centerY);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr3[i];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(10);
            make.left.equalTo(iconImage.mas_right).offset(15);
        }];
        
        UILabel *detailLabel = [UILabel new];
        detailLabel.tag = 210 + i;
        [button addSubview:detailLabel];
        detailLabel.text = titleDescArr3[i];
        detailLabel.font = [UIFont systemFontOfSize:12.];
        detailLabel.textColor = [UIColor dingfanxiangqingColor];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-10);
            make.left.equalTo(titleLabel);
        }];
        
    }

    _lingqianLabel = (UILabel *)[self viewWithTag:200];
    _xiaolubiLabel = (UILabel *)[self viewWithTag:201];
    _youhuiquanLabel = (UILabel *)[self viewWithTag:202];
    _daizhifuLabel = (UILabel *)[self viewWithTag:203];
    _daishouhuoLabel = (UILabel *)[self viewWithTag:204];
    _tuihuanhuoLabel = (UILabel *)[self viewWithTag:205];
    _wodedingdanLabel = (UILabel *)[self viewWithTag:206];
    _jinrifangkeLabel = (UILabel *)[self viewWithTag:207];
    _jinridingdanLabel = (UILabel *)[self viewWithTag:208];
    _jinrishouyiLabel = (UILabel *)[self viewWithTag:209];
    _leijishouyiLabel = (UILabel *)[self viewWithTag:210];
    _fangkejiluLabel = (UILabel *)[self viewWithTag:211];
    _dingdanjuluLabel = (UILabel *)[self viewWithTag:212];
    _wodefensiLabel = (UILabel *)[self viewWithTag:213];
    _lingqianLabel.text = @"0.00";
    _xiaolubiLabel.text = @"0";
    _youhuiquanLabel.text = @"0";


//    // === 顶部图片 === //
//    UIView *mineInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
//    mineInfoView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:mineInfoView];
//    UIImageView *iconImage = [UIImageView new];
//    [mineInfoView addSubview:iconImage];
//    iconImage.layer.masksToBounds = YES;
//    iconImage.layer.cornerRadius = 30.;
//    self.iconImage = iconImage;
//    self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
//    
//    UILabel *idLabel = [UILabel new];
//    [mineInfoView addSubview:idLabel];
//    idLabel.textColor = [UIColor blackColor];
//    idLabel.font = [UIFont systemFontOfSize:18.];
//    idLabel.text = @"ID:666";
//    self.idLabel = idLabel;
//    
//    UIImageView *isMaMaVipImage = [UIImageView new];
//    [mineInfoView addSubview:isMaMaVipImage];
//    isMaMaVipImage.backgroundColor = [UIColor clearColor];
//    isMaMaVipImage.image = [UIImage imageNamed:@"mamaUser_DiamondsIcon"];
//    
//    UILabel *isMaMaVipLabel = [UILabel new];
//    [mineInfoView addSubview:isMaMaVipLabel];
//    self.isMaMaVipLabel = isMaMaVipLabel;
//    isMaMaVipLabel.font = [UIFont systemFontOfSize:14.];
//    isMaMaVipLabel.text = @"普通妈妈";
//    
//    
//    UIImageView *levelImage = [UIImageView new];
//    [mineInfoView addSubview:levelImage];
//    levelImage.image = [UIImage imageNamed:@"mamaCrown_orangeColor"];
//    
//    UILabel *mamaLeveLabel = [UILabel new];
//    [mineInfoView addSubview:mamaLeveLabel];
//    self.mamaLeveLabel = mamaLeveLabel;
//    mamaLeveLabel.font = [UIFont boldSystemFontOfSize:12.];
//    mamaLeveLabel.text = @"VIP1";
//    
//    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(mineInfoView).offset(15);
//        make.centerY.equalTo(mineInfoView.mas_centerY);
//        make.width.height.mas_equalTo(@60);
//    }];
//    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(iconImage.mas_right).offset(15);
//        make.top.equalTo(iconImage).offset(5);
//        //        make.centerY.equalTo(iconImage.mas_centerY);
//    }];
//    
//    [isMaMaVipImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(idLabel);
//        //        make.centerY.equalTo(idLabel.mas_centerY);
//        make.top.equalTo(idLabel.mas_bottom).offset(10);
//        make.width.mas_equalTo(@15);
//        make.height.mas_equalTo(@12);
//    }];
//    [isMaMaVipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(isMaMaVipImage.mas_right).offset(2);
//        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
//    }];
//    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(isMaMaVipLabel.mas_right).offset(15);
//        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
//        make.width.mas_equalTo(@15);
//        make.height.mas_equalTo(@12);
//    }];
//    [mamaLeveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(levelImage.mas_right).offset(2);
//        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
//    }];
//
    
    
    
//    UILabel *memberLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 149, SCREENWIDTH, 1)];
//    memberLine.backgroundColor = [UIColor countLabelColor];
//    [messageView addSubview:memberLine];
    
    
    
    // == 折线图视图 == //
//    UIScrollView *foldLineScrollView = [UIScrollView new];
//    foldLineScrollView.backgroundColor = [UIColor whiteColor];
//    foldLineScrollView.frame = CGRectMake(0, messageView.mj_max_Y + 15, SCREENWIDTH, 150);
//    [self addSubview:foldLineScrollView];
//    self.foldLineScrollView = foldLineScrollView;
//    
//    UIImageView *mamaImage = [UIImageView new];
//    [self.foldLineScrollView addSubview:mamaImage];
//    self.mamaImage = mamaImage;
//    self.mamaImage.image = [UIImage imageNamed:@"mamanodata"];
    
    
    
    
    
    
    
//    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, selectBoxView.mj_max_Y, SCREENWIDTH, 15)];
//    [self addSubview:currentView];
    
    
    
    
    
    

    
    
}
- (void)setMessageDic:(NSDictionary *)messageDic {
    _messageDic = messageDic;
    NSArray *resultsArr = messageDic[@"results"];
    if (resultsArr.count == 0) {
        self.titlesArray = [NSMutableArray arrayWithObjects:@"暂时没有新消息通知~!", nil];
    }else {
        if ([messageDic[@"unread_cnt"] integerValue] == 0) {
            self.messagePromptLabel.hidden = YES;
        }else {
            self.messagePromptLabel.hidden = NO;
            //            self.messagePromptLabel.text = CS_STRING(messageDic[@"unread_cnt"]);
        }
        for (NSDictionary *dic in resultsArr) {
            [self.titlesArray addObject:dic[@"title"]];
        }
    }
    [self.pageView reloadData];
}

#pragma mark 顶部视图滚动协议方法
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView {
    return self.titlesArray.count;
}
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    JMMaMaMessageCell *testCell = cell;
    NSString *string = self.titlesArray[index];
    testCell.messageString = string;
}
- (NSString *)cellIndentifierWithIndex:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    return @"JMMaMaMessageCell";
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidScrollToIndex:(NSUInteger)index {
//    NSLog(@"JMMaMaHomeHeaderView ---> pageView滚动");
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidSelectedIndex:(NSUInteger)index {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.mamaNotReadNotice forKey:@"web_url"];
    [dict setValue:@"MaMaMessage" forKey:@"type_title"];
//    [self pushWebView:dict ShowNavBar:YES ShowRightShareBar:NO Title:@"消息通知"];
    if (self.loopPageBlock) {
        self.loopPageBlock(pageView, dict);
    }
}

#pragma mark 点击事件处理
/**
 *  100 --> 登录
 *  101 --> 零钱
 *  102 --> 小鹿币
 *  103 --> 优惠券
 *  104 --> 待支付
 *  105 --> 待收货
 *  106 --> 退换货
 *  107 --> 全部订单
 *  108 --> 折线图 -- > 访客
 *  109 --> 折线图 -- > 订单
 *  110 --> 折线图 -- > 收益
 *  111 --> 分享店铺
 *  112 --> 每日推送
 *  113 --> 选品佣金
 *  114 --> 邀请开店
 *  115 --> 我的提现
 *  116 --> 累计收益
 *  117 --> 访客记录
 *  118 --> 订单记录
 *  119 --> 我的粉丝
 */
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 112) {
        currentTurnsNumberString = @"0";
        self.currentTurnsLabel.hidden = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(composeHomeHeader:ButtonActionClick:)]) {
        [_delegate composeHomeHeader:self ButtonActionClick:button];
    }

}








@end
















































/*
 // 折线图视图
 - (void)setMamaResults:(NSArray *)mamaResults {
 [self mamaResults:mamaResults];
 }
 - (void)mamaResults:(NSArray *)mamaResults {
 NSArray *data = [NSArray reverse:mamaResults];
 self.mamaOrderArray = data;
 NSDictionary *dic = data[0];
 data = mamaResults;
 
 self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
 self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
 self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
 
 NSMutableArray *weekArray = [[NSMutableArray alloc] init];
 int xingqiji = (int)[self.weekDay integerValue];
 switch (xingqiji) {
 case 1:
 quxiaodays = 0;
 break;
 case 2:
 quxiaodays = 6;
 break;
 case 3:
 quxiaodays = 5;
 break;
 case 4:
 quxiaodays = 4;
 break;
 case 5:
 quxiaodays = 3;
 break;
 case 6:
 quxiaodays = 2;
 break;
 case 7:
 quxiaodays = 1;
 break;
 
 default:
 break;
 }
 for (int i = quxiaodays; i < data.count + quxiaodays; i++) {
 if (i>data.count - 1) {
 [weekArray addObject:@0.01];
 } else {
 float number = [[data[i] objectForKey:@"carry"] floatValue] + 0.01;
 NSNumber *order_num = [NSNumber numberWithFloat:number];
 [weekArray addObject:order_num];
 }
 if ((i + 1 - quxiaodays)% 7 == 0) {
 float sum = [self sumofoneWeek:weekArray];
 if (sum == 0) {
 break;
 }
 [allDingdan addObject:[weekArray copy]];
 [weekArray removeAllObjects];
 }
 }
 if (allDingdan.count > 0) {
 self.mamaImage.hidden = YES;
 }
 scrollViewContentOffset = CGPointMake(SCREENWIDTH * allDingdan.count - SCREENWIDTH, 0);
 [self createChart:allDingdan];
 }
 // 返回一周的订单数。。。。
 - (float)sumofoneWeek:(NSArray *)weekArray{
 float sum = 0.0;
 for (int i = 0; i < weekArray.count; i++) {
 sum += [weekArray[i] floatValue];
 }
 return sum;
 }
 
 
 #pragma mark -- 创建折线图
 - (void)createChart:(NSMutableArray *)chartData {
 NSInteger count = [chartData count];
 self.foldLineScrollView.contentSize = CGSizeMake(SCREENWIDTH * count, 120);
 self.foldLineScrollView.bounces = NO;
 self.foldLineScrollView.showsHorizontalScrollIndicator = NO;
 self.foldLineScrollView.delegate = self;
 self.foldLineScrollView.contentOffset = scrollViewContentOffset;
 self.foldLineScrollView.pagingEnabled = YES;
 
 NSArray *array = self.foldLineScrollView.subviews;
 for (UIView *view in array) {
 [view removeFromSuperview];
 }
 if (allDingdan.count == 0) {
 self.foldLineScrollView.scrollEnabled = NO;
 return;
 } else {
 self.foldLineScrollView.scrollEnabled = YES;
 }
 for (int i = 0; i < allDingdan.count; i++) {
 UIView *shartView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * i + 20, 30, SCREENWIDTH - 40, 150)];
 shartView.tag = 1001 + i;
 
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
 [shartView addGestureRecognizer:tap];
 
 NSMutableArray *mutabledingdan = [allDingdan[i] mutableCopy];
 
 FSLineChart *linechart = [self chart2:mutabledingdan];
 [shartView addSubview:linechart];
 
 UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
 circleView.backgroundColor = [UIColor orangeThemeColor];
 circleView.layer.cornerRadius = 3;
 circleView.tag = 300;
 [shartView addSubview:circleView];
 UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
 lineView.backgroundColor = [UIColor orangeThemeColor];
 lineView.tag = 400;
 [shartView addSubview:lineView];
 if (i == 0) {
 CGPoint point = [linechart getPointForIndex:6];
 circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
 lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
 
 } else {
 CGPoint point = [linechart getPointForIndex:(6 - quxiaodays)];
 circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
 lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
 if (6 - quxiaodays + 1 < 7) {
 point = [linechart getPointForIndex:(6 - quxiaodays + 1)];
 //                NSLog(@"%@", NSStringFromCGPoint(point));
 
 UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y - 1, SCREENWIDTH - point.x, 2)];
 whiteLine.backgroundColor = [UIColor whiteColor];
 [shartView addSubview:whiteLine];
 }
 }
 [self.foldLineScrollView addSubview:shartView];
 self.orongeCircleView = [[UIView alloc] init];
 self.orongeCircleView.layer.cornerRadius = 10;
 self.orongeCircleView.backgroundColor = [UIColor orangeThemeColor];
 [self.foldLineScrollView addSubview:self.orongeCircleView];
 
 self.anotherOrongeView = [[UIView alloc] init];
 self.anotherOrongeView.layer.cornerRadius = 10;
 self.anotherOrongeView.backgroundColor = [UIColor orangeThemeColor];
 [self.foldLineScrollView addSubview:self.anotherOrongeView];
 
 
 for (int j = 0; j < 7; j++) {
 CGPoint point2 = [linechart getPointForIndex:j];
 
 //            NSLog(@"%@", NSStringFromCGPoint(point2));
 UIColor *lineColor = [UIColor orangeColor];
 if (i == 1) {
 if ([self.weekDay integerValue] != 1 && [self.weekDay integerValue] < j+2  ) {
 lineColor = [UIColor buttonDisabledBorderColor];
 }
 }
 DotLineView *line = [[DotLineView alloc] initWithFrame:CGRectMake(point2.x, 0 , 1, point2.y) andColor:lineColor];
 line.backgroundColor = [UIColor clearColor];
 
 [shartView addSubview:line];
 }
 }
 UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, 148, SCREENWIDTH - 40, 0.5)];
 bottomLine.backgroundColor = [UIColor lineGrayColor];
 [self.foldLineScrollView addSubview:bottomLine];
 
 bottomLine = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH + 20, 148, SCREENWIDTH - 40, 0.5)];
 bottomLine.backgroundColor = [UIColor lineGrayColor];
 [self.foldLineScrollView addSubview:bottomLine];
 
 //本周日期
 NSArray *text = @[@"一", @"二", @"三", @"四",@"五",@"六",@"日"];
 for (int i = 0; i < 7; i++) {
 UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(SCREENWIDTH + i * (SCREENWIDTH - 50)/6 + 5, 8, 40, 20)];
 label.text = text[i];
 label.font = [UIFont systemFontOfSize:14];
 label.textAlignment = NSTextAlignmentCenter;
 label.textColor = [UIColor orangeThemeColor];
 label.tag = 8000+ i;
 label.userInteractionEnabled = NO;
 [self.foldLineScrollView addSubview:label];
 [self.labelArray addObject:label];
 }
 //下周日期
 NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 NSDate *now;
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
 NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
 now=[NSDate date];
 
 //    NSLog(@"now = %@", now);
 comps = [calendar components:unitFlags fromDate:now];
 //    NSLog(@"comps = %@", comps);
 now = [calendar dateFromComponents:comps];
 
 //    NSLog(@"now = %@", now);
 self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
 
 //self.weekDay
 //    NSLog(@"%@", self.weekDay);
 int today = (int)[self.weekDay integerValue];
 int lastday = 0;
 switch (today) {
 case 1:
 lastday = 7;
 break;
 case 2:
 lastday = 1;
 break;
 case 3:
 lastday = 2;
 break;
 case 4:
 lastday = 3;
 break;
 case 5:
 lastday = 4;
 break;
 case 6:
 lastday = 5;
 break;
 case 7:
 lastday = 6;
 break;
 
 default:
 break;
 }
 lastday += 7;
 //    NSLog(@"lastDay = %d", lastday);
 
 int tag = (today + 6)%7;
 if (tag == 0) {
 tag = 7;
 }
 UILabel *label = [self.foldLineScrollView viewWithTag:8000 + tag - 1];
 // label.textColor = [UIColor redColor];
 [UIView animateWithDuration:0 animations:^{
 self.orongeCircleView.frame = label.frame;
 } completion:^(BOOL finished) {
 label.textColor = [UIColor whiteColor];
 }];
 
 [self.lastweeknames removeAllObjects];
 for (int i = 0; i < 7; i++) {
 NSTimeInterval timeInterval = -(lastday - i - 1) * 24 * 60 * 60;
 NSDate *lastDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
 
 comps = [calendar components:unitFlags fromDate:lastDate];
 
 //        NSLog(@"lastDate = %@", comps);
 
 NSString *string = [NSString stringWithFormat:@"%ld/%ld", (long)[comps month], (long)[comps day]];
 [self.lastweeknames addObject:string];
 }
 
 //    NSLog(@"%@", self.lastweeknames);
 for (int i = 0; i < 7; i++) {
 UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(i * (SCREENWIDTH - 50)/6 + 5, 8, 40, 20)];
 label.text = self.lastweeknames[i];
 label.font = [UIFont systemFontOfSize:14];
 label.textAlignment = NSTextAlignmentCenter;
 label.textColor = [UIColor orangeThemeColor];
 label.tag = 80+ i;
 label.userInteractionEnabled = NO;
 [self.foldLineScrollView addSubview:label];
 [self.anotherLabelArray addObject:label];
 if (i == 6) {
 label.textColor = [UIColor whiteColor];
 self.anotherOrongeView.frame = label.frame;
 }
 }
 [self createButtons];
 }
 - (void)createButtons{
 UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
 btn1.frame = CGRectMake(SCREENWIDTH - 20, 60, 20, 30);
 [btn1 addTarget:self action:@selector(btn1Clicked) forControlEvents:UIControlEventTouchUpInside];
 [self.foldLineScrollView addSubview:btn1];
 [btn1 setBackgroundImage:[UIImage imageNamed:@"zhexianyou.png"] forState:UIControlStateNormal];
 
 UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
 btn2.frame = CGRectMake(SCREENWIDTH, 60, 20, 30);
 [btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
 [self.foldLineScrollView addSubview:btn2];
 [btn2 setBackgroundImage:[UIImage imageNamed:@"zhexianzuo.png"] forState:UIControlStateNormal];
 
 UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
 btn4.frame = CGRectMake(0, 60, 20, 30);
 [self.foldLineScrollView addSubview:btn4];
 [btn4 setBackgroundImage:[UIImage imageNamed:@"zhexianzuo.png"] forState:UIControlStateNormal];
 
 }
 - (void)btn2Clicked{
 //    NSLog(@"quxiazhou");
 
 [UIView animateWithDuration:0.3 animations:^{
 self.foldLineScrollView.contentOffset = CGPointMake(0, 0);
 } completion:^(BOOL finished) {
 
 }];
 }
 - (void)btn1Clicked{
 //    NSLog(@"qubenzhou");
 [UIView animateWithDuration:0.3 animations:^{
 self.foldLineScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
 } completion:^(BOOL finished) {
 
 }];
 }
 #pragma mark 点击表格 更新数据
 - (void)tapClicked:(UITapGestureRecognizer *)recognizer {
 UIView *weekView = [recognizer view];
 weekView.backgroundColor = [UIColor redColor];
 NSInteger week = weekView.tag - 1000;
 if (week == 2) {
 week =1;
 } else if (week == 1){
 week = 2;
 }
 //    NSLog(@"第 %ld 周订单数据", week);
 // NSLog(@"weekView subView = %@", [weekView subviews]);
 CGPoint location = [recognizer locationInView:recognizer.view];
 //  NSLog(@"location = %@", NSStringFromCGPoint(location));
 CGFloat width = location.x;
 // NSLog(@"width = %f", width);
 CGFloat unitwidth = (SCREENWIDTH - 50)/6;
 //  NSLog(@"unit = %.0f", unitwidth);
 int index = (int)((width + unitwidth/2 - 5 ) /unitwidth);
 
 //    NSLog(@"index = %d", index);
 NSInteger days = (6 - index) + (week - 1)*7;
 if (days - quxiaodays < 0) {
 return;
 }
 FSLineChart *linechart = [weekView subviews][0];
 UIView *circleView = [weekView viewWithTag:300];
 UIView *lineView = [weekView viewWithTag:400];
 
 CGPoint point = [linechart getPointForIndex:index];
 // NSLog(@"point = %@", NSStringFromCGPoint(point));
 
 circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
 lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
 
 self.visitorDate = [NSNumber numberWithInteger:days - quxiaodays];
 //    NSLog(@"days = %ld", days - quxiaodays);
 // NSLog(@"array = %@", self.mamaOrderArray);
 // NSLog(@"%ld", quxiaodays);
 NSDictionary *dic = self.mamaOrderArray[days - quxiaodays];
 
 self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
 self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
 self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
 
 if (week == 1) {
 
 __block UILabel *label = (UILabel *)self.labelArray[index];
 CGRect rect = label.frame;
 
 label = [self.foldLineScrollView viewWithTag:(8000 + index)];
 //        NSLog(@"label = %@", label);
 
 for (int i = 0; i < 7; i++) {
 UILabel *theLabel = [self.foldLineScrollView viewWithTag:(8000 + i)];
 theLabel.textColor = [UIColor orangeThemeColor];
 }
 [UIView animateWithDuration:0.3 animations:^{
 self.orongeCircleView.frame = rect;
 } completion:^(BOOL finished) {
 label.textColor = [UIColor whiteColor];
 }];
 } else if(week == 2) {
 //        NSLog(@"index = %ld", (long)index);
 
 __block UILabel *label = (UILabel *)self.anotherLabelArray[index];
 CGRect rect = label.frame;
 
 label = [self.foldLineScrollView viewWithTag:(80 + index)];
 //        NSLog(@"label = %@", label);
 
 for (int i = 0; i < 7; i++) {
 UILabel *theLabel = [self.foldLineScrollView viewWithTag:(80 + i)];
 theLabel.textColor = [UIColor orangeThemeColor];
 }
 [UIView animateWithDuration:0.3 animations:^{
 self.anotherOrongeView.frame = rect;
 } completion:^(BOOL finished) {
 label.textColor = [UIColor whiteColor];
 }];
 }
 }
 #pragma mark 制作表格
 -(FSLineChart*)chart2:(NSMutableArray *)chartData {
 // Creating the line chart
 self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 120)];
 self.lineChart.verticalGridStep = 1;
 self.lineChart.horizontalGridStep = 6;
 self.lineChart.color = [UIColor fsOrange];
 self.lineChart.fillColor = nil;
 self.lineChart.bezierSmoothing = NO;
 self.lineChart.animationDuration = 1;
 self.lineChart.drawInnerGrid = NO;
 [self.lineChart setChartData:chartData];
 [self.lineChart showLineViewAfterDelay:self.lineChart.animationDuration];
 return self.lineChart;
 }
 
 
 #pragma mark 获得星期数
 - (void)createWeekDay{
 NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 NSDate *now;
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
 NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
 now=[NSDate date];
 comps = [calendar components:unitFlags fromDate:now];
 self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
 }
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
 //    if (scrollView == self.tableView) {
 //        return ;
 //    }
 NSInteger page = scrollView.contentOffset.x/SCREENWIDTH;
 
 scrollViewContentOffset = scrollView.contentOffset;
 NSInteger count = allDingdan.count;
 
 NSInteger days = (count - page - 1)*7;
 self.visitorDate = [NSNumber numberWithInteger:days];
 
 //    NSLog(@"days = %ld", (long)days);
 
 NSDictionary *dic = self.mamaOrderArray[days];
 // NSLog(@"dic = %@", dic);
 
 self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
 self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
 self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
 
 //改变竖线的位置。。。。
 [self createChart:allDingdan];
 
 }
 //- (void)viewDidDisappear:(BOOL)animated {
 //    self.lineChart = nil;
 //}
 
 
 
 

 */



































