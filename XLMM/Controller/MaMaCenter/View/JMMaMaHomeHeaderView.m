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
}

@property (nonatomic, strong) UILabel *addWeekEarningLabel;
@property (nonatomic, strong) UILabel *addEarningLabel;
@property (nonatomic, strong) UILabel *weekRankLabel;

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
        [self createWeekDay];
        [self createButtons];
        [self createChart:dataArray];
        
    }
    return self;
}
- (void)setCenterModel:(JMMaMaCenterModel *)centerModel {
    _centerModel = centerModel;
    _currentTurnsNum = self.centerModel.current_dp_turns_num;
    
    NSDictionary *extraDic = centerModel.extra_info;
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:extraDic];
    NSDictionary *exDic = self.centerModel.extra_info;
    NSDictionary *extraFiguresDic = self.centerModel.extra_figures;
    self.addEarningLabel.text = CS_FLOAT([extraFiguresDic[@"today_carry_record"] floatValue]);
    self.addWeekEarningLabel.text = CS_FLOAT([extraFiguresDic[@"week_duration_total"] floatValue]);
    NSString *weekRankStr = CS_STRING(extraFiguresDic[@"week_duration_rank"]);
    NSString *weekRankString = [NSString stringWithFormat:@"本周我的排名 %@",weekRankStr];
    self.weekRankLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:24.] SubColor:[UIColor whiteColor] AllString:weekRankString SubStringArray:@[weekRankStr]];
    CGFloat finisF = [extraFiguresDic[@"task_percentage"] floatValue];
    NSString *finishProStr = [NSString stringWithFormat:@"%.f%%",finisF * 100];
    self.finishProgressLabel.text = CS_DSTRING(@"本周任务已完成 ",finishProStr);
    NSString *limtStr = CS_STRING(exDic[@"surplus_days"]);                                              // 会员剩余期限
    if ([NSString isStringEmpty:limtStr]) {
        limtStr = @"0";
    }
    NSString *numStr = [NSString stringWithFormat:@"会员剩余期限%@天",limtStr];
    self.memberLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:numStr SubStringArray:@[limtStr]];
    
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
    
}
- (void)currentTurnsNum:(NSString *)currentTurnsNum {
    if ([currentTurnsNum isEqual:@"0"]) {
    }else {
        self.currentTurnsLabel.hidden = NO;
        self.currentTurnsLabel.text = currentTurnsNum;
    }
}

- (void)setMamaResults:(NSArray *)mamaResults {
    [self mamaResults:mamaResults];
}
- (void)setMamaNotReadNotice:(NSString *)mamaNotReadNotice {
    _mamaNotReadNotice = mamaNotReadNotice;
}



- (void)initUI {
    kWeakSelf
    NSArray *imageArr = @[@"mamaeryaoqingColor",@"EverydayPushNormalColor",@"selectionShopNormalColor",@"inviteShopNormalColor"];
    NSArray *titleArr = @[@"分享店铺",@"每日推送",@"选品佣金",@"邀请开店"];
    // === 顶部图片 === //
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
    [self addSubview:topImageView];
    topImageView.image = [UIImage imageNamed:@"wodejingxuanback"];
    topImageView.userInteractionEnabled = YES;
    
    
    UILabel *addWeekEarningL = [UILabel new];
    [topImageView addSubview:addWeekEarningL];
    addWeekEarningL.textColor = [UIColor buttonTitleColor];
    addWeekEarningL.textAlignment = NSTextAlignmentCenter;
    addWeekEarningL.font = [UIFont systemFontOfSize:14.];
    addWeekEarningL.text = @"本周累计收益";

    UILabel *addWeekEarningLabel = [UILabel new];
    [topImageView addSubview:addWeekEarningLabel];
    addWeekEarningLabel.textColor = [UIColor whiteColor];
    addWeekEarningLabel.font = [UIFont systemFontOfSize:36.];
    //    addEarningLabel.text = @"666.66";
    self.addWeekEarningLabel = addWeekEarningLabel;
    
    UILabel *addEarningL = [UILabel new];
    [topImageView addSubview:addEarningL];
    addEarningL.textColor = [UIColor buttonTitleColor];
    addEarningL.textAlignment = NSTextAlignmentCenter;
    addEarningL.font = [UIFont systemFontOfSize:14.];
    addEarningL.text = @"今日累计收益";
    
    UILabel *addEarningLabel = [UILabel new];
    [topImageView addSubview:addEarningLabel];
    addEarningLabel.textColor = [UIColor whiteColor];
    addEarningLabel.font = [UIFont systemFontOfSize:36.];
    //    addEarningLabel.text = @"666.66";
    self.addEarningLabel = addEarningLabel;
    
    UILabel *lineView = [UILabel new];
    [topImageView addSubview:lineView];
    lineView.backgroundColor = [UIColor mamaCenterBorderColor];
    
    UIButton *weekRankbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topImageView addSubview:weekRankbutton];
    weekRankbutton.tag = 100;
    [weekRankbutton addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *worldRankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topImageView addSubview:worldRankButton];
    worldRankButton.tag = 101;
    [worldRankButton addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weekRankLabel = [UILabel new];
    [weekRankbutton addSubview:weekRankLabel];
    weekRankLabel.font = [UIFont systemFontOfSize:12.];
    weekRankLabel.textColor = [UIColor buttonTitleColor];
    weekRankLabel.text = @"本周我的排名";
    self.weekRankLabel = weekRankLabel;
    
    UILabel *worldRankLabel = [UILabel new];
    [worldRankButton addSubview:worldRankLabel];
    worldRankLabel.font = [UIFont systemFontOfSize:12.];
    worldRankLabel.textColor = [UIColor buttonTitleColor];
    worldRankLabel.text = @"世界排名TOP10";
    
    [addWeekEarningL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView).offset(25);
        make.left.equalTo(topImageView);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
    }];
    [addWeekEarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addWeekEarningL.mas_bottom).offset(10);
        make.centerX.equalTo(addWeekEarningL.mas_centerX);
    }];
    [addEarningL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView).offset(25);
        make.right.equalTo(topImageView);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
    }];
    [addEarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addEarningL.mas_bottom).offset(10);
        make.centerX.equalTo(addEarningL.mas_centerX);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topImageView);
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(topImageView).offset(-40);
    }];
    [weekRankbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(topImageView);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
        make.height.mas_equalTo(@40);
    }];
    [worldRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(topImageView);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
        make.height.mas_equalTo(@40);
    }];
    [weekRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weekRankbutton.mas_centerY);
        make.left.equalTo(weekRankbutton).offset(10);
    }];
    [worldRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(worldRankButton.mas_centerY);
        make.right.equalTo(worldRankButton).offset(-10);
    }];
    
    
    // == 折线图视图 == //
    UIScrollView *foldLineScrollView = [UIScrollView new];
    foldLineScrollView.backgroundColor = [UIColor whiteColor];
    foldLineScrollView.frame = CGRectMake(0, 140, SCREENWIDTH, 150);
    [self addSubview:foldLineScrollView];
    self.foldLineScrollView = foldLineScrollView;
    
    UIImageView *mamaImage = [UIImageView new];
    [self.foldLineScrollView addSubview:mamaImage];
    self.mamaImage = mamaImage;
    self.mamaImage.image = [UIImage imageNamed:@"mamanodata"];
    
    // 个人收益视图 //
    UIView *toolView = [UIView new];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.frame = CGRectMake(0, 290, SCREENWIDTH, 60);
    [self addSubview:toolView];
    
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
        [earningsV addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        earningsValueLabel.tag = 210 + i;
    }
    self.todayEarningsLabel = (UILabel *)[self viewWithTag:210];
    self.futureEarningsLabe = (UILabel *)[self viewWithTag:211];
    self.rankingLabel = (UILabel *)[self viewWithTag:212];
    
    
    UIView *selectBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, SCREENWIDTH, 90)];
    selectBoxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:selectBoxView];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        [selectBoxView addSubview:button];
        button.tag = 103 + i;
        [button addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(SCREENWIDTH / 4 * (i % 4), 0, SCREENWIDTH / 4, 90);
        
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.tag = 10 + i;
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr[i]];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(button).offset(25);
            //            make.width.height.mas_equalTo(@25);
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr[i];
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
    self.currentTurnsLabel.font = CS_SYSTEMFONT(9.);
    self.currentTurnsLabel.layer.masksToBounds = YES;
    self.currentTurnsLabel.layer.cornerRadius = 7.;
    self.currentTurnsLabel.hidden = YES;
    [self.currentTurnsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.animationImage).offset(15);
        make.centerY.equalTo(weakSelf.animationImage).offset(-15);
        make.width.height.mas_equalTo(@(14));
    }];
    
    
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 440, SCREENWIDTH, 15)];
    [self addSubview:currentView];
    
    
    // 续费视图
    UIView *memberView = [[UIView alloc] initWithFrame:CGRectMake(0, 455, SCREENWIDTH, 45)];
    [self addSubview:memberView];
    memberView.backgroundColor = [UIColor whiteColor];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    //    [memberView addGestureRecognizer:tap];
    
    UILabel *memberL = [UILabel new];
    [memberView addSubview:memberL];
    memberL.font = [UIFont systemFontOfSize:14.];
    memberL.textColor = [UIColor buttonTitleColor];
    memberL.text = @"我的会员";
    
    UILabel *memberLabel = [UILabel new];
    [memberView addSubview:memberLabel];
    memberLabel.font = [UIFont systemFontOfSize:12.];
    memberLabel.textColor = [UIColor buttonTitleColor];
    self.memberLabel = memberLabel;
    
//    self.renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [memberView addSubview:self.renewButton];
//    [self.renewButton setImage:[UIImage imageNamed:@"MaMa_renew"] forState:UIControlStateNormal];
//    self.renewButton.tag = 107;
//    [self.renewButton addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [memberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(memberView).offset(10);
        make.centerY.equalTo(memberView.mas_centerY);
    }];
    [memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(memberView).offset(-10);
        make.centerY.equalTo(memberView.mas_centerY);
    }];
//    [self.renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(memberView);
//        make.centerY.equalTo(memberView.mas_centerY);
//        make.width.mas_equalTo(@(60));
//        make.height.mas_equalTo(@(45));
//    }];

    // 消息滚动列表
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 500, SCREENWIDTH, 45)];
    [self addSubview:messageView];
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
    unReadMessageLabel.font = CS_SYSTEMFONT(10.);
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
    
    UILabel *memberLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 499, SCREENWIDTH, 1)];
    memberLine.backgroundColor = [UIColor countLabelColor];
    [messageView addSubview:memberLine];
    
    
    
    UIView *weekTaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 545, SCREENWIDTH, 45)];
    [self addSubview:weekTaskView];
    weekTaskView.backgroundColor = [UIColor whiteColor];
    UILabel *finishProgressLabel = [UILabel new];
    [weekTaskView addSubview:finishProgressLabel];
    finishProgressLabel.textColor = [UIColor buttonTitleColor];
    finishProgressLabel.font = [UIFont systemFontOfSize:14.];
    finishProgressLabel.text = @"本周任务已完成 --%";
    self.finishProgressLabel = finishProgressLabel;
    
    UIButton *gotoExecutionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weekTaskView addSubview:gotoExecutionButton];
    
    gotoExecutionButton.layer.cornerRadius = 12.5;
    gotoExecutionButton.backgroundColor = [UIColor wechatBackColor];
    [gotoExecutionButton setTitle:@"马上执行" forState:UIControlStateNormal];
    [gotoExecutionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoExecutionButton.titleLabel.font = [UIFont systemFontOfSize:12.];
    gotoExecutionButton.tag = 102;
    [gotoExecutionButton addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [finishProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weekTaskView.mas_centerY);
        make.left.equalTo(weekTaskView).offset(10);
    }];
    [gotoExecutionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weekTaskView.mas_centerY);
        make.right.equalTo(weekTaskView).offset(-10);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@(25));
    }];

    
    
    
    
    
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
 *  100 --> 本周我的排名
 *  101 --> 世界排名TOP10
 *  102 --> 马上执行
 *  103 --> 分享店铺
 *  104 --> 每日推送
 *  105 --> 精品汇
 *  106 --> 邀请开店
 *  107 --> 续费按钮
 *  108 --> 折线图 -- > 访客
 *  109 --> 折线图 -- > 订单
 *  110 --> 折线图 -- > 收益
 */
- (void)mamaButtonClick:(UIButton *)button {
    if (button.tag == 104) {
        currentTurnsNumberString = @"0";
        self.currentTurnsLabel.hidden = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(composeHomeHeader:ButtonActionClick:)]) {
        [_delegate composeHomeHeader:self ButtonActionClick:button];
    }
//    if (self.buttonActionBlock) {
//        self.buttonActionBlock(button);
//    }
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










@end




















































































