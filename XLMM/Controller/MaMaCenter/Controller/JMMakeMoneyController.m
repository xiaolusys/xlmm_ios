//
//  JMMakeMoneyController.m
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMakeMoneyController.h"
#import "MMClass.h"
#import "ShopPreviousViewController.h"
#import "PublishNewPdtViewController.h"
#import "WebViewController.h"
#import "ProductSelectionListViewController.h"
#import "JMMaMaEarningsRankController.h"
#import "JMRewardsController.h"
#import "JMRichTextTool.h"
#import "JMHomeActiveCell.h"
#import "JumpUtils.h"
#import "JMMaMaMessageCell.h"
#import "JMAutoLoopPageView.h"
#import "JMVipRenewController.h"
#import "JMMaMaCenterModel.h"
#import "NSArray+Reverse.h"
#import "FSLineChart.h"
#import "DotLineView.h"
#import "UIColor+FSPalette.h"
#import "TodayVisitorViewController.h"
#import "MaMaOrderListViewController.h"
#import "MaClassifyCarryLogViewController.h"

@interface JMMakeMoneyController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,JMAutoLoopPageViewDataSource,JMAutoLoopPageViewDelegate> {
    NSMutableDictionary *_webDict;
    CGFloat _carryValue;
    int quxiaodays;
    NSMutableArray *allDingdan;
    CGPoint scrollViewContentOffset;
    NSMutableArray *dataArray;
    NSString *_orderRecord;             // 订单记录
    NSString *_earningsRecord;          // 收益记录
    NSString *_historyEarningsRecord;   // 历史收益记录
}

@property (nonatomic, strong)UITableView *tableView;
/**
 *  字典中存储在webView中使用的值
 */
@property (nonatomic,strong) NSMutableDictionary *diction;

@property (nonatomic, copy) NSString *myInvitation;

@property (nonatomic, strong) UILabel *addEarningLabel;

@property (nonatomic, strong) UILabel *weekRankLabel;

@property (nonatomic, strong) UILabel *finishProgressLabel;

@property (nonatomic, strong) JMAutoLoopPageView *pageView;
@property (nonatomic, strong) NSMutableArray *titlesArray;
/**
 *  是否显示消息未读提示
 */
@property (nonatomic, strong) UILabel *messagePromptLabel;
@property (nonatomic, strong) UILabel *memberLabel;            // 会员剩余期限
@property (nonatomic, strong) UIButton *renewButton;           // 续费按钮

@property (nonatomic, strong) NSArray *mamaOrderArray;
/**
 *  折线视图
 */
@property (nonatomic, strong) UIScrollView *foldLineScrollView;
@property (nonatomic, strong) UIImageView *mamaImage;
@property (nonatomic, strong) FSLineChart *lineChart;
@property (nonatomic, strong) UIView *orongeCircleView;
@property (nonatomic, strong) UIView *anotherOrongeView;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *lastweeknames;
@property (nonatomic, strong) NSMutableArray *anotherLabelArray;
@property (nonatomic, strong) NSNumber *visitorDate;

/**
 *  折线图收益按钮
 */
@property (nonatomic, strong) UIView *toolView;
/**
 *  今日收益
 */
@property (nonatomic, strong) UILabel *todayEarningsLabel;
/**
 *  潜在收益
 */
@property (nonatomic, strong) UILabel *futureEarningsLabe;
/**
 *  排名
 */
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) NSNumber *weekDay;

@end

@implementation JMMakeMoneyController

- (NSMutableArray *)titlesArray {
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}
- (NSMutableDictionary *)diction {
    if (!_diction) {
        _diction = [NSMutableDictionary dictionary];
    }
    return _diction;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.visitorDate = [NSNumber numberWithInt:0];
    _webDict = [NSMutableDictionary dictionary];
    dataArray = [[NSMutableArray alloc] initWithCapacity:30];
    allDingdan = [[NSMutableArray alloc] init];
    self.labelArray = [[NSMutableArray alloc] init];
    self.lastweeknames = [[NSMutableArray alloc] init];
    self.anotherLabelArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    [self createHeaderView];
    [self createWeekDay];
    [self createButtons];
    [self createChart:dataArray];
    
}
- (void)setMakeMoneyDic:(NSDictionary *)makeMoneyDic {
    _makeMoneyDic = makeMoneyDic;
    self.myInvitation = makeMoneyDic[@"invite"];
    
    
    
}
- (void)setCenterModel:(JMMaMaCenterModel *)centerModel {
    _centerModel = centerModel;
    NSDictionary *exDic = centerModel.extra_info;
    NSDictionary *extraFiguresDic = centerModel.extra_figures;
    self.addEarningLabel.text = CS_FLOAT([extraFiguresDic[@"today_carry_record"] floatValue]);
    NSString *weekRankStr = CS_STRING(extraFiguresDic[@"week_duration_rank"]);
    NSString *weekRankString = [NSString stringWithFormat:@"本周我的排名 %@",weekRankStr];
    self.weekRankLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:24.] SubColor:[UIColor whiteColor] AllString:weekRankString SubStringArray:@[weekRankStr]];
    CGFloat finisF = [extraFiguresDic[@"task_percentage"] floatValue];
    NSString *finishProStr = [NSString stringWithFormat:@"%.f%%",finisF * 100];
    self.finishProgressLabel.text = CS_DSTRING(@"本周任务已完成 ",finishProStr);
    
    _orderRecord = [NSString stringWithFormat:@"%@", centerModel.order_num];
    _earningsRecord = [NSString stringWithFormat:@"%.2f", [centerModel.carry_value floatValue]];
    _historyEarningsRecord = [NSString stringWithFormat:@"%.2f", [exDic[@"his_confirmed_cash_out"] floatValue]];
    NSString *limtStr = CS_STRING(exDic[@"surplus_days"]);                                              // 会员剩余期限
    if ([NSString isStringEmpty:limtStr]) {
        limtStr = @"0";
    }
    NSString *numStr = [NSString stringWithFormat:@"会员剩余期限%@天",limtStr];
    self.memberLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:numStr SubStringArray:@[limtStr]];
    
    NSString *carryValueStr = [NSString stringWithFormat:@"%.2f",[centerModel.cash_value floatValue]];
    _carryValue = [carryValueStr floatValue];
}
//- (void)setExtraFiguresDic:(NSDictionary *)extraFiguresDic {
//    _extraFiguresDic = extraFiguresDic;
//    
//
//    
//}
- (void)setActiveArray:(NSMutableArray *)activeArray {
    _activeArray = activeArray;
    
    
    [self.tableView reloadData];
}
- (void)setMessageDic:(NSDictionary *)messageDic {
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
- (void)setMamaResults:(NSArray *)mamaResults {
    _mamaResults = mamaResults;
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


- (void)createHeaderView {
    kWeakSelf
    NSArray *imageArr = @[@"mamaeryaoqingColor",@"EverydayPushNormalColor",@"selectionShopNormalColor",@"inviteShopNormalColor"];
    NSArray *titleArr = @[@"分享店铺",@"每日推送",@"选品佣金",@"邀请开店"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 590)];
    self.tableView.tableHeaderView = headerView;
    
    // === 顶部图片 === //
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
    [headerView addSubview:topImageView];
    topImageView.image = [UIImage imageNamed:@"wodejingxuanback"];
    topImageView.userInteractionEnabled = YES;
    
    UILabel *addEarningL = [UILabel new];
    [topImageView addSubview:addEarningL];
    addEarningL.textColor = [UIColor buttonTitleColor];
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
    [addEarningL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView).offset(25);
        make.centerX.equalTo(topImageView.mas_centerX);
    }];
    [addEarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addEarningL.mas_bottom).offset(10);
        make.centerX.equalTo(topImageView.mas_centerX);
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
    [headerView addSubview:foldLineScrollView];
    self.foldLineScrollView = foldLineScrollView;
    
    UIImageView *mamaImage = [UIImageView new];
    [self.foldLineScrollView addSubview:mamaImage];
    self.mamaImage = mamaImage;
    self.mamaImage.image = [UIImage imageNamed:@"mamanodata"];
    
    // 个人收益视图 //
    UIView *toolView = [UIView new];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.frame = CGRectMake(0, 290, SCREENWIDTH, 60);
    [headerView addSubview:toolView];
    self.toolView = toolView;
    
    CGFloat toolW = SCREENWIDTH / 3;
    NSArray *earningsArr = @[@"访客",@"订单",@"收益"];
    NSInteger earningCount = 3;
    for (int i = 0 ; i < earningCount; i++) {
        UIButton *earningsV = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.toolView addSubview:earningsV];
        [earningsV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(toolW));
            make.height.mas_equalTo(@60);
            make.centerY.equalTo(weakSelf.toolView.mas_centerY);
            make.centerX.equalTo(weakSelf.toolView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)earningCount + 0));
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
    self.todayEarningsLabel = (UILabel *)[self.view viewWithTag:210];
    self.futureEarningsLabe = (UILabel *)[self.view viewWithTag:211];
    self.rankingLabel = (UILabel *)[self.view viewWithTag:212];

    
    UIView *selectBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, SCREENWIDTH, 90)];
    selectBoxView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:selectBoxView];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        [selectBoxView addSubview:button];
        button.tag = 103 + i;
        [button addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(SCREENWIDTH / 4 * (i % 4), 0, SCREENWIDTH / 4, 90);
        
        
        UIImageView *iconImage = [UIImageView new];
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

    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 440, SCREENWIDTH, 15)];
    [headerView addSubview:currentView];
    headerView.backgroundColor = [UIColor countLabelColor];
    
    // 续费视图
    UIView *memberView = [[UIView alloc] initWithFrame:CGRectMake(0, 455, SCREENWIDTH, 45)];
    [headerView addSubview:memberView];
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
    
    self.renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [memberView addSubview:self.renewButton];
    [self.renewButton setImage:[UIImage imageNamed:@"MaMa_renew"] forState:UIControlStateNormal];
    self.renewButton.tag = 107;
    [self.renewButton addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [memberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(memberView).offset(10);
        make.centerY.equalTo(memberView.mas_centerY);
    }];
    [memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(memberView).offset(-60);
        make.centerY.equalTo(memberView.mas_centerY);
    }];
    [self.renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(memberView);
        make.centerY.equalTo(memberView.mas_centerY);
        make.width.mas_equalTo(@(60));
        make.height.mas_equalTo(@(45));
    }];

    
    // 消息滚动列表
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 500, SCREENWIDTH, 45)];
    [headerView addSubview:messageView];
    messageView.layer.masksToBounds = YES;
    messageView.layer.borderWidth = 0.5;
    messageView.layer.borderColor = [UIColor countLabelColor].CGColor;
    messageView.backgroundColor = [UIColor whiteColor];
    
//    UILabel *messageLabel = [UILabel new];
//    [messageView addSubview:messageLabel];
//    messageLabel.font = [UIFont systemFontOfSize:14.];
//    messageLabel.textColor = [UIColor buttonTitleColor];
//    messageLabel.text = @"我的消息";
    
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
    [messageView addSubview:self.pageView];
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    [self.pageView registerCellWithClass:[JMMaMaMessageCell class] identifier:@"JMMaMaMessageCell"];
    self.pageView.scrollStyle = JMAutoLoopScrollStyleVertical;
    self.pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
    self.pageView.scrollForSingleCount = YES;
    self.pageView.atuoLoopScroll = YES;
    self.pageView.scrollFuture = YES;
    self.pageView.autoScrollInterVal = 3.0f;
    
    
//    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(messageView).offset(10);
//        make.centerY.equalTo(messageView.mas_centerY);
//    }];
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
    [headerView addSubview:weekTaskView];
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
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidSelectedIndex:(NSUInteger)index {
    WebViewController *message = [[WebViewController alloc] init];
    [self.diction setValue:self.makeMoneyDic[@"notice"] forKey:@"web_url"];
    [self.diction setValue:@"MaMaMessage" forKey:@"type_title"];
    message.webDiction = self.diction;//[NSMutableDictionary dictionaryWithDictionary:_diction];
    message.isShowNavBar = true;
    message.isShowRightShareBtn = false;
    [self.navigationController pushViewController:message animated:YES];
}
#pragma mark 点击事件处理
/**
 *  100 --> 本周我的排名
 *  101 --> 世界排名TOP10
 *  102 --> 马上执行
 *  103 --> 分享店铺
 *  104 --> 每日推送
 *  105 --> 选品佣金
 *  106 --> 邀请开店
 *  107 --> 续费按钮
 *  108 --> 折线图 -- > 访客
 *  109 --> 折线图 -- > 订单
 *  110 --> 折线图 -- > 收益
 */
- (void)mamaButtonClick:(UIButton *)button {
    NSLog(@"button.tag --> %ld",button.tag);
    NSInteger index = button.tag;
    if (index == 100) {
        [self earning:1];
    }else if (index == 101) {
        [self earning:0];
    }else if (index == 102) {
        JMRewardsController *rewardsVC = [[JMRewardsController alloc] init];
        [self.navigationController pushViewController:rewardsVC animated:YES];
    }else if (index == 103) {
        ShopPreviousViewController *previous = [[ShopPreviousViewController alloc] init];
        [self.navigationController pushViewController:previous animated:YES];
    }else if (index == 104) {
        PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
        publish.qrCodeUrlString = self.qrCodeUrlString;
        [self.navigationController pushViewController:publish animated:YES];
    }else if (index == 105) {
        ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
        [self.navigationController pushViewController:product animated:YES];
    }else if (index == 106) {
        if ([NSString isStringEmpty:self.myInvitation]) return;
        WebViewController *activity = [[WebViewController alloc] init];
        NSString *active = @"myInvite";
        NSString *titleName = @"我的邀请";
        [self.diction setValue:@38 forKey:@"activity_id"];
        [self.diction setValue:self.myInvitation forKey:@"web_url"];
        [self.diction setValue:active forKey:@"type_title"];
        [self.diction setValue:titleName forKey:@"name_title"];
        activity.webDiction = _diction;
        activity.isShowNavBar = true;
        activity.isShowRightShareBtn = true;
        [self.navigationController pushViewController:activity animated:YES];
    }else if (index == 107) {
        JMVipRenewController *renewVC = [[JMVipRenewController alloc] init];
        renewVC.cashValue = _carryValue;
        [self.navigationController pushViewController:renewVC animated:YES];
    }else if (index == 108) {
        TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
        today.visitorDate = @7;
        [self.navigationController pushViewController:today animated:YES];
    }else if (index == 109) {
        MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
        order.orderRecord = _orderRecord;
        [self.navigationController pushViewController:order animated:YES];
    }else if (index == 110) {
        MaClassifyCarryLogViewController *carry = [[MaClassifyCarryLogViewController alloc] init];
        carry.earningsRecord = _earningsRecord;
        carry.historyEarningsRecord = _historyEarningsRecord;
        [self.navigationController pushViewController:carry animated:YES];
    }else { }
    
    
}
- (void)earning:(NSInteger)index {
    JMMaMaEarningsRankController *earningsRankVC = [[JMMaMaEarningsRankController alloc] init];
    earningsRankVC.selfInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/self_rank",Root_URL];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"/rest/v2/mama/rank/carry_total_rank",@"/rest/v2/mama/rank/carry_duration_rank", nil];
    earningsRankVC.urlArray = array;
    earningsRankVC.isTeamEarningsRank = NO;
    earningsRankVC.selectIndex = index;
    [self.navigationController pushViewController:earningsRankVC animated:YES];
}





- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 114) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH * 0.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JMHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:JMHomeActiveCellIdentifier];
    if (!cell) {
        cell = [[JMHomeActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMHomeActiveCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.activeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeActiveModel *model = self.activeArray[indexPath.row];
    [self skipWebView:model.act_applink activeDic:model];
    
}

#pragma mark 活动点击事件(跳转webView)
- (void)skipWebView:(NSString *)appLink activeDic:(JMHomeActiveModel *)model {
    if(appLink.length == 0){
        WebViewController *huodongVC = [[WebViewController alloc] init];
        NSString *active = @"active";
        [_webDict setValue:active forKey:@"type_title"];
        [_webDict setValue:model.activeID forKey:@"activity_id"];
        [_webDict setValue:model.act_link forKey:@"web_url"];
        huodongVC.webDiction = _webDict;
        huodongVC.isShowNavBar = true;
        huodongVC.isShowRightShareBtn = true;
        huodongVC.titleName = model.title;
        [self.navigationController pushViewController:huodongVC animated:YES];
    }else{
        [JumpUtils jumpToLocation:appLink viewController:self];
    }
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
                NSLog(@"%@", NSStringFromCGPoint(point));
                
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
            
            NSLog(@"%@", NSStringFromCGPoint(point2));
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
    
    NSLog(@"now = %@", now);
    comps = [calendar components:unitFlags fromDate:now];
    NSLog(@"comps = %@", comps);
    now = [calendar dateFromComponents:comps];
    
    NSLog(@"now = %@", now);
    self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
    
    //self.weekDay
    NSLog(@"%@", self.weekDay);
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
    NSLog(@"lastDay = %d", lastday);
    
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
        
        NSLog(@"lastDate = %@", comps);
        
        NSString *string = [NSString stringWithFormat:@"%ld/%ld", (long)[comps month], (long)[comps day]];
        [self.lastweeknames addObject:string];
    }
    
    NSLog(@"%@", self.lastweeknames);
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
    NSLog(@"quxiazhou");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.foldLineScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)btn1Clicked{
    NSLog(@"qubenzhou");
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
    NSLog(@"第 %ld 周订单数据", week);
    // NSLog(@"weekView subView = %@", [weekView subviews]);
    CGPoint location = [recognizer locationInView:recognizer.view];
    //  NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
    // NSLog(@"width = %f", width);
    CGFloat unitwidth = (SCREENWIDTH - 50)/6;
    //  NSLog(@"unit = %.0f", unitwidth);
    int index = (int)((width + unitwidth/2 - 5 ) /unitwidth);
    
    NSLog(@"index = %d", index);
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
    NSLog(@"days = %ld", days - quxiaodays);
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
        NSLog(@"label = %@", label);
        
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
        NSLog(@"index = %ld", (long)index);
        
        __block UILabel *label = (UILabel *)self.anotherLabelArray[index];
        CGRect rect = label.frame;
        
        label = [self.foldLineScrollView viewWithTag:(80 + index)];
        NSLog(@"label = %@", label);
        
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
    if (scrollView == self.tableView) {
        return ;
    }
    NSInteger page = scrollView.contentOffset.x/SCREENWIDTH;
    
    scrollViewContentOffset = scrollView.contentOffset;
    NSInteger count = allDingdan.count;
    
    NSInteger days = (count - page - 1)*7;
    self.visitorDate = [NSNumber numberWithInteger:days];
    
    NSLog(@"days = %ld", (long)days);
    
    NSDictionary *dic = self.mamaOrderArray[days];
    // NSLog(@"dic = %@", dic);
    
    self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
    self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
    self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
    
    //改变竖线的位置。。。。
    [self createChart:allDingdan];
    
}

@end










































