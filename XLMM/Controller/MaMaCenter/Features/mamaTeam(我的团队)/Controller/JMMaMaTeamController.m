//
//  JMMaMaTeamController.m
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaTeamController.h"
#import "JMMaMateamCell.h"
#import "JMMaMaEarningsRankController.h"
#import "JMMaMaSelfTeamModel.h"
#import "JMSelecterButton.h"
#import "WebViewController.h"

static const NSUInteger ITEM_COUNT = 3;

@interface JMMaMaTeamController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *  妈妈头像
 */
@property (nonatomic, strong) UIImageView *mamaIconImage;
/**
 *  mama团队收益排行
 */
@property (nonatomic, strong) JMSelecterButton *mamaRankButton;

@property (nonatomic, strong) UILabel *buttonLabel;
/**
 *  收益,团队收益排名
 */
@property (nonatomic, strong) UILabel *earningsLabel;
@property (nonatomic, strong) UILabel *teamEarningsRankLabel;


@end

@implementation JMMaMaTeamController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"我的团队" selecotr:@selector(backClick:)];
    [self createTableView];
    [self createHeaderView];
    [self loadDataSource];
    [self loadSelfInfoDataSource];
    [self createRightButonItem];
}
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"团队说明" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightClicked:(UIButton *)button {
    WebViewController *webVC = [[WebViewController alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.explainUrl forKey:@"web_url"];
    webVC.webDiction = dict;
    webVC.isShowNavBar = true;
    webVC.isShowRightShareBtn = false;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)loadDataSource {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/%@/get_team_members",Root_URL,self.mamaID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchTeamData:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchTeamData:(NSArray *)teamArr {
    for (NSDictionary *dic in teamArr) {
        JMMaMaSelfTeamModel *teamModel = [JMMaMaSelfTeamModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:teamModel];
    }
    [self.tableView reloadData];
}
- (void)loadSelfInfoDataSource {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v2/mama/teamrank/self_rank",Root_URL];
//    NSString *urlStr = @"http://192.168.1.56:8000/rest/v2/mama/teamrank/self_rank";
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchSelfTeamInfoData:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];   
}
- (void)fetchSelfTeamInfoData:(NSDictionary *)teamInfoDic {
    [self.mamaIconImage sd_setImageWithURL:[NSURL URLWithString:[teamInfoDic[@"thumbnail"] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    if ([NSString isStringEmpty:teamInfoDic[@"total"]]) {
        return ;
    }else {
        CGFloat total = [teamInfoDic[@"total"] floatValue] / 100.00;
        self.earningsLabel.text = [NSString stringWithFormat:@"收益%.2f元",total];
    }
    
    
//    self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"团队收益第%@",teamInfoDic[@"rank"]];

}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"mamaTeamCell";
    JMMaMateamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMMaMateamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMMaMaSelfTeamModel *model = self.dataSource[indexPath.row];
    [cell config:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor countLabelColor];
    [sectionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(sectionView);
        make.height.mas_equalTo(@1);
    }];
    
    for (int i = 0; i < ITEM_COUNT; i++) {
        UILabel *label = [self getItemViewWithIndex:i];
        [sectionView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(SCREENWIDTH / 3));
            make.height.mas_equalTo(@60);
            make.centerY.equalTo(sectionView.mas_centerY);
            make.centerX.equalTo(sectionView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)ITEM_COUNT + 0));
        }];
        if (i == 2) {
        }else {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor countLabelColor];
            [label addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(label);
                make.height.mas_equalTo(@30);
                make.width.mas_equalTo(@1);
                make.centerY.equalTo(label.mas_centerY);
            }];
        }
    }
    
    return sectionView;
}
- (UILabel *)getItemViewWithIndex:(NSInteger)index {
    NSArray *arr = @[@"昵称",@"订单数",@"收益"];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14.];
    label.textColor = [UIColor buttonTitleColor];
    label.text = arr[index];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)createHeaderView {
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    self.tableView.tableHeaderView = topView;
    topView.image = [UIImage imageNamed:@"wodejingxuanback"];
    topView.userInteractionEnabled = YES;
    
    UIImageView *mamaIconBackImage = [UIImageView new]; //wodejingxuantouxiangicon -- > 妈妈头像底层图片
    [topView addSubview:mamaIconBackImage];
    mamaIconBackImage.image = [UIImage imageNamed:@"wodejingxuantouxiangicon"];
    
    UIImageView *mamaIconImage = [UIImageView new];
    [mamaIconBackImage addSubview:mamaIconImage];
    self.mamaIconImage = mamaIconImage;
    self.mamaIconImage.layer.masksToBounds = YES;
    self.mamaIconImage.layer.cornerRadius = 25.;
    self.mamaIconImage.layer.borderWidth = 1.;
    self.mamaIconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    JMSelecterButton *mamaRankButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:mamaRankButton];
    self.mamaRankButton = mamaRankButton;
    [self.mamaRankButton setSelecterBorderColor:[UIColor whiteColor] TitleColor:[UIColor whiteColor] Title:@"查看团队排名" TitleFont:14. CornerRadius:15.];
    [self.mamaRankButton addTarget:self action:@selector(mamaRankClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *buttonImage = [UIImageView new];
    [topView addSubview:buttonImage];
    buttonImage.backgroundColor = [UIColor clearColor];
    buttonImage.image = [UIImage imageNamed:@"mamaCrown_yellowColor"];
    
    UILabel *buttonLabel = [UILabel new];
    [topView addSubview:buttonLabel];
    self.buttonLabel = buttonLabel;
    self.buttonLabel.textColor = [UIColor whiteColor];
    self.buttonLabel.font = [UIFont systemFontOfSize:14.];
    self.buttonLabel.text = @"团队妈妈";
    
    self.earningsLabel = [UILabel new];
    [topView addSubview:self.earningsLabel];
    self.earningsLabel.textColor = [UIColor buttonTitleColor];
    self.earningsLabel.font = [UIFont systemFontOfSize:14.];
    
    self.teamEarningsRankLabel = [UILabel new];
    [topView addSubview:self.teamEarningsRankLabel];
    self.teamEarningsRankLabel.textColor = [UIColor buttonTitleColor];
    self.teamEarningsRankLabel.font = [UIFont systemFontOfSize:14.];
    
    kWeakSelf

    
    [mamaIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(20);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.mamaIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.height.mas_equalTo(@50);
    }];
    
    [self.mamaRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
    }];
    
    [buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(15);
        make.top.equalTo(mamaIconBackImage).offset(5);
        make.width.mas_equalTo(@18);
        make.height.mas_equalTo(@15);
    }];
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonImage.mas_right).offset(3);
        make.centerY.equalTo(buttonImage.mas_centerY);
    }];
    
    [self.earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(10);
        make.bottom.equalTo(mamaIconBackImage);
    }];
    
    [self.teamEarningsRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.earningsLabel.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.earningsLabel.mas_centerY);
    }];
    
    
    
}
- (void)mamaRankClick:(UIButton *)button {
    JMMaMaEarningsRankController *earningsVC = [[JMMaMaEarningsRankController alloc] init];
    earningsVC.selfInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/teamrank/self_rank",Root_URL];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"/rest/v2/mama/teamrank/carry_total_rank",@"/rest/v2/mama/teamrank/carry_duration_rank", nil];
    earningsVC.urlArray = array;
//    earningsVC.urlArray = @[@"http://s18.xiaolumm.com/rest/v2/mama/teamrank/carry_total_rank",@"http://s18.xiaolumm.com/rest/v2/mama/teamrank/carry_duration_rank"];
//    earningsVC.rankInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/teamrank/carry_total_rank",Root_URL];
    earningsVC.isTeamEarningsRank = YES;
    [self.navigationController pushViewController:earningsVC animated:YES];
}
- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MaMaTeamEarningsRank"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MaMaTeamEarningsRank"];
}
@end

























































































































