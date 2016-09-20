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

@interface JMMakeMoneyController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *  字典中存储在webView中使用的值
 */
@property (nonatomic,strong) NSMutableDictionary *diction;

@property (nonatomic, copy) NSString *myInvitation;

@property (nonatomic, strong) UILabel *addEarningLabel;

@property (nonatomic, strong) UILabel *weekRankLabel;

@property (nonatomic, strong) UILabel *finishProgressLabel;

@end

@implementation JMMakeMoneyController
- (NSMutableDictionary *)diction {
    if (!_diction) {
        _diction = [NSMutableDictionary dictionary];
    }
    return _diction;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    [self createHeaderView];
    
}
- (void)setMakeMoneyDic:(NSDictionary *)makeMoneyDic {
    _makeMoneyDic = makeMoneyDic;
    self.myInvitation = makeMoneyDic[@"invite"];
    
    
    
}
- (void)setExtraFiguresDic:(NSDictionary *)extraFiguresDic {
    _extraFiguresDic = extraFiguresDic;
    self.addEarningLabel.text = CS_FLOAT([extraFiguresDic[@"week_duration_total"] floatValue]);
    NSString *weekRankStr = CS_STRING(extraFiguresDic[@"week_duration_rank"]);
    NSString *weekRankString = [NSString stringWithFormat:@"本周我的排名 %@",weekRankStr];
    self.weekRankLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:24.] SubColor:[UIColor whiteColor] AllString:weekRankString SubStringArray:@[weekRankStr]];
    CGFloat finisF = [extraFiguresDic[@"task_percentage"] floatValue];
    NSString *finishProStr = [NSString stringWithFormat:@"%.f%%",finisF * 100];
    self.finishProgressLabel.text = CS_DSTRING(@"本周任务已完成 ",finishProStr);

    
}
- (void)setActiveArray:(NSMutableArray *)activeArray {
    _activeArray = activeArray;
    
    
    [self.tableView reloadData];
}


- (void)createHeaderView {
    NSArray *imageArr = @[@"mamaeryaoqingColor",@"EverydayPushNormalColor",@"selectionShopNormalColor",@"inviteShopNormalColor"];
    NSArray *titleArr = @[@"分享店铺",@"每日推送",@"选品佣金",@"邀请开店"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 290)];
    self.tableView.tableHeaderView = headerView;
    
    // === 顶部图片 === //
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
    [headerView addSubview:topImageView];
    topImageView.image = [UIImage imageNamed:@"wodejingxuanback"];
    topImageView.userInteractionEnabled = YES;
    
    UILabel *addEarningL = [UILabel new];
    [topImageView addSubview:addEarningL];
    addEarningL.textColor = [UIColor buttonTitleColor];
    addEarningL.font = [UIFont systemFontOfSize:12.];
    addEarningL.text = @"本周累计收益";
    
    UILabel *addEarningLabel = [UILabel new];
    [topImageView addSubview:addEarningLabel];
    addEarningLabel.textColor = [UIColor whiteColor];
    addEarningLabel.font = [UIFont systemFontOfSize:36.];
    addEarningLabel.text = @"666.66";
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
    
    
    
    UIView *selectBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 90)];
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
            make.top.equalTo(button).offset(25);
//            make.width.height.mas_equalTo(@25);
            make.centerX.equalTo(button.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:12.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImage.mas_bottom).offset(10);
            make.centerX.equalTo(iconImage.mas_centerX);
        }];
        
    
    }
    
    
    
    
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, SCREENWIDTH, 15)];
    [headerView addSubview:currentView];
    headerView.backgroundColor = [UIColor countLabelColor];
    
    
    UIView *weekTaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 245, SCREENWIDTH, 45)];
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
/**
 *  100 --> 本周我的排名
 *  101 --> 世界排名TOP10
 *  102 --> 马上执行
 *  103 --> 分享店铺
 *  104 --> 每日推送
 *  105 --> 选品佣金
 *  106 --> 邀请开店
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
        [self.navigationController pushViewController:publish animated:YES];
    }else if (index == 105) {
        ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
        [self.navigationController pushViewController:product animated:YES];
    }else if (index == 106) {
        if ([self.myInvitation isKindOfClass:[NSNull class]] || self.myInvitation == nil || [self.myInvitation isEqual:@""]) return;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 108) style:UITableViewStylePlain];
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




@end










































