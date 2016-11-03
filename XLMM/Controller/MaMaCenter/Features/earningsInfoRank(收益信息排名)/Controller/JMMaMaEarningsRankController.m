//
//  JMMaMaEarningsRankController.m
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaEarningsRankController.h"
#import "JMEarningsRankModel.h"
#import "JMEarningsRankCell.h"
#import "JMMaMaTeamModel.h"

@interface JMMaMaEarningsRankController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;

//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIImageView *mamaIconImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UILabel *earningsLabel;

@property (nonatomic, strong) UILabel *teamEarningsRankLabel;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, strong)UIScrollView *bottomScrollView;

@property (nonatomic, strong) NSMutableArray *tableViewDataArr;

//存储旧的位置
@property (nonatomic, strong)NSMutableDictionary *oldDic;
@property (nonatomic, strong)NSMutableDictionary *contentOffsetYDic;

@end

static NSString *JMMaMaEarningsRankIdfier = @"JMMaMaEarningsRankController";

@implementation JMMaMaEarningsRankController {
    NSDictionary *_selfInfoDic;
    NSMutableArray *_buttonArr;
    NSMutableArray *_tableArr;
    NSInteger _currentIndex;
    NSMutableArray *_allKeys;
        
    NSMutableArray *_dataArray;
    NSMutableArray *_allDataArray;
    NSMutableArray *_weekDataArray;
}
- (NSMutableDictionary *)oldDic {
    if (!_oldDic) {
        self.oldDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _oldDic;
}

- (NSMutableDictionary *)contentOffsetYDic {
    if (!_contentOffsetYDic) {
        self.contentOffsetYDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _contentOffsetYDic;
}

- (NSMutableArray *)tableViewDataArr {
    if (!_tableViewDataArr) {
        self.tableViewDataArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 2; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [_tableViewDataArr addObject:dic];
        }
    }
    return _tableViewDataArr;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    _currentIndex = _selectIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isTeamEarningsRank) {
        [self createNavigationBarWithTitle:@"团队妈妈收益排名" selecotr:@selector(backClick:)];
//        self.urlArray = @[@"s18.xiaolumm.com/rest/v2/mama/teamrank/carry_total_rank",@"s18.xiaolumm.com/rest/v2/mama/teamrank/carry_duration_rank"];
        [self loadTeamData];
    }else {
        [self createNavigationBarWithTitle:@"收益信息排名" selecotr:@selector(backClick:)];
//        self.urlArray = @[@"s18.xiaolumm.com/rest/v2/mama/rank/carry_total_rank ",@"s18.xiaolumm.com/rest/v2/mama/rank/carry_duration_rank"];
        [self loadNoTeamData];
    }
    _currentIndex = _selectIndex;

    _allDataArray = [NSMutableArray array];
    _weekDataArray = [NSMutableArray array];
    _dataArray = [NSMutableArray arrayWithObjects:_allDataArray,_weekDataArray, nil];
//    [self createTableView];
    [self createHeaderView];
//    [self loadDataSource];
    [self createSegmentView];
    [self loadSelfInfoDataSource];
    
    _currentIndex = _selectIndex;
    for (UIButton *btn in self.btnView.subviews) {
        if (btn.tag == 100 + _currentIndex) {
            [self titleBtnClickAction:btn];
        }
    }
    
}
- (void)loadNoTeamData {
    NSArray *urlArr = @[@"/rest/v2/mama/rank/carry_total_rank",@"/rest/v2/mama/rank/carry_duration_rank"];
    for (int i = 0; i < urlArr.count; i++) {
        [self loadDataSource:urlArr[i]];
    }
}

- (void)loadTeamData {
    NSArray *urlArr = @[@"/rest/v2/mama/teamrank/carry_total_rank",@"/rest/v2/mama/teamrank/carry_duration_rank"];
    for (int i = 0; i < urlArr.count; i++) {
        [self loadDataSource:urlArr[i]];
    }
}

- (NSArray *)urlArray {
    // 接口数组 -- > (团队周排名,团队总排名) 根据点击的按钮来判断选择了那个接口
    NSArray *urlArray = [NSArray array];
    if (self.isTeamEarningsRank) {
        urlArray = @[@"/rest/v2/mama/teamrank/carry_total_rank",@"/rest/v2/mama/teamrank/carry_duration_rank"];
    }else {
        urlArray = @[@"/rest/v2/mama/rank/carry_total_rank",@"/rest/v2/mama/rank/carry_duration_rank"];
    }
    return urlArray;
}


- (void)loadDataSource:(NSString *)string{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",Root_URL,string];
//    NSString *urlString = [NSString stringWithFormat:@"%@",string];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        if ([string isEqualToString:[self urlArray][0]]) {
//            _dataArray[0] = responseObject;
            [self fetchData1:responseObject];
        }else if ([string isEqualToString:[self urlArray][1]]) {
//            _dataArray[1] = responseObject;
            [self fetchData2:responseObject];
        }else {
            
        }
//        [self fetchData:responseObject];
        
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchData1:(NSArray *)teamArr {
    
    if (self.isTeamEarningsRank == YES) {
        for (NSDictionary *dic in teamArr) {
            JMMaMaTeamModel *earningModel = [JMMaMaTeamModel mj_objectWithKeyValues:dic];
            [_allDataArray addObject:earningModel];
        }
    }else {
        for (NSDictionary *dic in teamArr) {
            JMEarningsRankModel *earningModel = [JMEarningsRankModel mj_objectWithKeyValues:dic];
            [_allDataArray addObject:earningModel];
        }
    }
    UITableView *table = _tableArr[0];
    [table reloadData];
}
- (void)fetchData2:(NSArray *)teamArr {
    if (self.isTeamEarningsRank == YES) {
        for (NSDictionary *dic in teamArr) {
            JMMaMaTeamModel *earningModel = [JMMaMaTeamModel mj_objectWithKeyValues:dic];
            [_weekDataArray addObject:earningModel];
        }
    }else {
        for (NSDictionary *dic in teamArr) {
            JMEarningsRankModel *earningModel = [JMEarningsRankModel mj_objectWithKeyValues:dic];
            [_weekDataArray addObject:earningModel];
        }
    }
    UITableView *table = _tableArr[1];
    [table reloadData];
}

- (void)loadSelfInfoDataSource {
//    NSString *urlString = @"http://192.168.1.56:8000/rest/v2/mama/rank/self_rank";
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.selfInfoUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchSelfInfoData:responseObject];
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchSelfInfoData:(NSDictionary *)selfInfoDic {
    _selfInfoDic = selfInfoDic;
    self.nameLabel.text = selfInfoDic[@"mama_nick"];
    [self.mamaIconImage sd_setImageWithURL:[NSURL URLWithString:[selfInfoDic[@"thumbnail"] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    if ([selfInfoDic[@"rank"] integerValue] == 0) {
        self.rankLabel.text = @"";
    }else {
        self.rankLabel.text = [NSString stringWithFormat:@"第%@名",selfInfoDic[@"rank"]];
    }
    
    if (self.isTeamEarningsRank == YES) {
        
        CGFloat total = [selfInfoDic[@"total"] floatValue] / 100.00;
        self.earningsLabel.text = [NSString stringWithFormat:@"总收益额%.2f元",total];
//        NSInteger rankChange = [selfInfoDic[@"rank"] integerValue];
//        NSInteger rankAdd = labs(rankChange);
//        self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"团队妈妈第%ld名",rankAdd];

    }else {
        CGFloat total = [selfInfoDic[@"total"] floatValue] / 100.00;
        self.earningsLabel.text = [NSString stringWithFormat:@"收益%.2f元",total];
        NSInteger rankChange = [selfInfoDic[@"rank_add"] integerValue];
        NSInteger rankAdd = labs(rankChange);
        if (rankChange >= 0) {
            self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"比上周上升%ld名",(long)rankAdd];
        }else {
            self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"比上周下降%ld名",(long)rankAdd];
        }
    }

}


- (void)createSegmentView {
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 244, SCREENWIDTH, SCREENHEIGHT - 244)];
    [self.view addSubview:self.contentView];
    
    _buttonArr = [NSMutableArray array];
    
    NSArray *nameArr = @[@"总排行", @"周排行"];
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    self.btnView.backgroundColor = [UIColor whiteColor];
    self.btnView.layer.masksToBounds = YES;
    self.btnView.layer.borderWidth = 1.;
    self.btnView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    [self.contentView addSubview:self.btnView];
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * SCREENWIDTH / 2, 0, SCREENWIDTH / 2, 35);
        button.titleLabel.font =  [UIFont systemFontOfSize: 14];
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor textDarkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateSelected];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:button];
        [_buttonArr addObject:button];
    }
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, SCREENHEIGHT - 35)];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.contentSize = CGSizeMake(2 * SCREENWIDTH, SCREENHEIGHT -35);
    [self.contentView addSubview:self.bottomScrollView];
    
    _tableArr = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, self.bottomScrollView.frame.size.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 60.;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [tableView registerClass:[JMEarningsRankCell class] forCellReuseIdentifier:JMMaMaEarningsRankIdfier];
        [self.bottomScrollView addSubview:tableView];
        [_tableArr addObject:tableView];
    }
    
}
- (void)titleBtnClickAction:(UIButton *)button {
    if (button.selected) {
        return ;
    }else {
        NSInteger btnTag = button.tag - 100;
        self.bottomScrollView.contentOffset = CGPointMake(SCREENWIDTH * btnTag, 0);
        [self changeBtnSelect:btnTag];
        _currentIndex = btnTag;

        UITableView *table = _tableArr[btnTag];
        [table reloadData];
    }
    
}
- (void)changeBtnSelect:(NSInteger)btnTag {
    for (UIButton *button in _buttonArr) {
        if ((button.tag - 100) == btnTag) {
            button.selected = YES;
            continue;
        }
        button.selected = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableArr[0]) {
        return _allDataArray.count;
    }else {
        return _weekDataArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMEarningsRankCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[JMEarningsRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMMaMaEarningsRankIdfier];
    }
    if (self.isTeamEarningsRank == YES) {
        if (tableView == _tableArr[0]) {
            JMMaMaTeamModel *model = _allDataArray[indexPath.row];
            [cell configTeamModel:model Index:indexPath.row];
        }else {
            JMMaMaTeamModel *model = _weekDataArray[indexPath.row];
            [cell configTeamModel:model Index:indexPath.row];
        }
    }else {
        if (tableView == _tableArr[0]) {
            JMEarningsRankModel *model = _allDataArray[indexPath.row];
            [cell config:model Index:indexPath.row];
        }else {
            JMEarningsRankModel *model = _weekDataArray[indexPath.row];
            [cell config:model Index:indexPath.row];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark --scrollView的代理方法w
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger count = scrollView.contentOffset.x / SCREENWIDTH;
        _currentIndex = count;

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.bottomScrollView) {
        NSNumber *number = [NSNumber numberWithInteger:_currentIndex];
        NSNumber *contentOffY = [NSNumber numberWithInteger:scrollView.contentOffset.y];
        [self.contentOffsetYDic setObject:contentOffY forKey:number];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger offX = scrollView.contentOffset.x / SCREENWIDTH;
        [self changeBtnSelect:offX];
    }else {
        CGFloat contentOffY = [[self.contentOffsetYDic objectForKey:[NSNumber numberWithInteger:_currentIndex]] floatValue];
        if (scrollView.dragging) {
            if ((scrollView.contentOffset.y - contentOffY) > 5.0f) {
                //隐藏
                [UIView animateWithDuration:0.5 animations:^{
                    self.topView.frame = CGRectMake(0, 64, SCREENWIDTH, 180);
                    self.topView.alpha = 0.0;
                    self.contentView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 35);
                }];
            }else if((contentOffY - scrollView.contentOffset.y) > 5.0f){
                //显示
                [UIView animateWithDuration:0.5 animations:^{
                    self.topView.frame = CGRectMake(0, 64, SCREENWIDTH, 180);
                    self.topView.alpha = 1.0;
                    self.contentView.frame = CGRectMake(0, 64 + 180, SCREENWIDTH, SCREENHEIGHT - 35);
                }];
            }
        }
    }
}
- (void)createHeaderView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 180)];
//    self.tableView.tableHeaderView = topView;
    self.topView = topView;
    [self.view addSubview:topView];
    
    UIImageView *contentView = [UIImageView new];
    [topView addSubview:contentView];
    contentView.image = [UIImage imageNamed:@"wodejingxuanback"];
    contentView.userInteractionEnabled = YES;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(topView);
        make.height.mas_equalTo(@120);
    }];
    
    UIImageView *mamaIconBackImage = [UIImageView new]; //wodejingxuantouxiangicon -- > 妈妈头像底层图片
    [contentView addSubview:mamaIconBackImage];
    mamaIconBackImage.image = [UIImage imageNamed:@"wodejingxuantouxiangicon"];
    
    UIImageView *mamaIconImage = [UIImageView new];
    [mamaIconBackImage addSubview:mamaIconImage];
    self.mamaIconImage = mamaIconImage;
    self.mamaIconImage.layer.masksToBounds = YES;
    self.mamaIconImage.layer.cornerRadius = 25.;
    self.mamaIconImage.layer.borderWidth = 1.;
    self.mamaIconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.nameLabel = [UILabel new];
    [contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:12.];
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    
    self.rankLabel = [UILabel new];
    [contentView addSubview:self.rankLabel];
    self.rankLabel.font = [UIFont systemFontOfSize:24.];
    self.rankLabel.textColor = [UIColor whiteColor];
    
    
    self.earningsLabel = [UILabel new];
    [contentView addSubview:self.earningsLabel];
    self.earningsLabel.textColor = [UIColor buttonTitleColor];
    self.earningsLabel.font = [UIFont systemFontOfSize:14.];
    
    self.teamEarningsRankLabel = [UILabel new];
    [contentView addSubview:self.teamEarningsRankLabel];
    self.teamEarningsRankLabel.textColor = [UIColor buttonTitleColor];
    self.teamEarningsRankLabel.font = [UIFont systemFontOfSize:14.];
    
    kWeakSelf
    
    
    [mamaIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.mamaIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.height.mas_equalTo(@50);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mamaIconBackImage.mas_bottom).offset(5);
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(15);
        make.top.equalTo(mamaIconBackImage).offset(5);
    }];
    
    [self.earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(15);
        make.bottom.equalTo(mamaIconBackImage);
    }];
    
    [self.teamEarningsRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.earningsLabel.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.earningsLabel.mas_centerY);
    }];
    
    
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:sectionView];
    
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(topView);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mamaGoldCup"]];
    UILabel *label = [UILabel new];
    if (self.isTeamEarningsRank == YES) {
        label.text = @"团队收益排行榜TOP10";
    }else {
        label.text = @"个人收益排行榜TOP10";
    }
    
    [sectionView addSubview:image];
    [sectionView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_left).offset(-10);
    }];
    
}

- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MaMaEarningsRank"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MaMaEarningsRank"];
}
@end


































































































































