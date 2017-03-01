//
//  MaClassifyCarryLogViewController.m
//  XLMM
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaClassifyCarryLogViewController.h"
#import "CarryLogModel.h"
#import "CarryLogTableViewCell.h"
#import "CarryLogHeaderView.h"
#import "JMMaMaEarningsRankController.h"

#define BTNWIDTH (SCREENWIDTH * 0.25)

@interface MaClassifyCarryLogViewController ()
@property (nonatomic, strong)UIView *headerV;
@property (nonatomic, strong)UIScrollView *bottomScrollView;
@property (nonatomic, strong)UIView *btnView;
@property (nonatomic, strong)UIView *scrollAndBtnView;

@property (nonatomic, strong)NSMutableArray *tableViewArr;
@property (nonatomic, strong)NSMutableArray *tableViewDataArr;
@property (nonatomic, strong)NSMutableArray *urlArr;
@property (nonatomic, strong)NSMutableArray *btnArr;

@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)NSMutableArray *allkey;
@property (nonatomic, strong)NSMutableDictionary *nextdic;


//存储旧的位置
@property (nonatomic, strong)NSMutableDictionary *oldDic;
@property (nonatomic, strong)NSMutableDictionary *contentOffsetYDic;

@property (nonatomic,strong) UIButton *topButton;

@end

static NSString *cellIdentifier = @"carryLogCell";
@implementation MaClassifyCarryLogViewController {
    NSString *_nextPage;
}

-(NSMutableArray *)tableViewArr {
    if (!_tableViewArr) {
        self.tableViewArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _tableViewArr;
}

- (NSMutableArray *)tableViewDataArr {
    if (!_tableViewDataArr) {
        self.tableViewDataArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 4; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [_tableViewDataArr addObject:dic];
        }
    }
    return _tableViewDataArr;
}

- (NSMutableArray *)urlArr {
    if (!_urlArr) {
        self.urlArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _urlArr;
}

- (NSMutableDictionary *)nextdic {
    if (!_nextdic) {
        self.nextdic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _nextdic;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"MaClassifyCarryLogViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"MaClassifyCarryLogViewController"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"收益记录" selecotr:@selector(backClickAction)];
    
    self.currentIndex = 0;
    [self createRequestURL];
    
    [self createHeader];
    [self createScrollView];
    [self createTableViews];
    
    self.currentIndex = 0;
    for (UIButton *btn in self.btnView.subviews) {
        if (btn.tag == 100) {
            [self titleBtnClickAction:btn];
        }
    }
    [self createButton];
//    [self createRightButonItem];
}
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"收益信息排名" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightClicked:(UIButton *)button {
    JMMaMaEarningsRankController *earningsRankVC = [[JMMaMaEarningsRankController alloc] init];
    earningsRankVC.selfInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/self_rank",Root_URL];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"/rest/v2/mama/rank/carry_total_rank",@"/rest/v2/mama/rank/carry_duration_rank", nil];
    earningsRankVC.urlArray = array;
    //    earningsRankVC.rankInfoUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/rank/carry_total_rank",Root_URL];
    earningsRankVC.isTeamEarningsRank = NO;
    [self.navigationController pushViewController:earningsRankVC animated:YES];
}
- (void)createRequestURL {
    NSArray *urlBefroe = @[@"/rest/v2/mama/carry", @"/rest/v2/mama/awardcarry", @"/rest/v2/mama/clickcarry",
                           @"/rest/v2/mama/ordercarry"];
    for (int i = 0; i < 4; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [self.urlArr addObject:url];
    }
}

- (void)createHeader {
    self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 105)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 15, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"累计收益";
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 50)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:35];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = self.earningsRecord;
    [self.headerV addSubview:titleLabel];
    [self.headerV addSubview:moneyLabel];
//    self.headerV.backgroundColor = [UIColor greenColor];
    
    UILabel *otherEaringsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, 20)];
    [self.headerV addSubview:otherEaringsLabel];
    otherEaringsLabel.font = [UIFont systemFontOfSize:14.];
    otherEaringsLabel.textColor = [UIColor dingfanxiangqingColor];
    otherEaringsLabel.textAlignment = NSTextAlignmentCenter;
    otherEaringsLabel.text = [NSString stringWithFormat:@"2016.3.24号系统升级之前的收益%@",self.historyEarningsRecord];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [self.headerV addSubview:lineView];
    
    [self.view addSubview:self.headerV];
    
    CGFloat headerY = CGRectGetMaxY(self.headerV.frame);
    self.scrollAndBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, headerY, SCREENWIDTH, SCREENHEIGHT - headerY)];
    [self.view addSubview:self.scrollAndBtnView];
    
    self.btnArr = [NSMutableArray arrayWithCapacity:0];
    
    //创建button
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    UIView *btnlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWIDTH, 1)];
    btnlineView.backgroundColor = [UIColor lightGrayColor];
    btnlineView.alpha = 0.3;
    [self.btnView addSubview:btnlineView];
    
    NSArray *nameArr = @[@"全部", @"奖金", @"返现", @"佣金"];
    [self.scrollAndBtnView addSubview:self.btnView];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * BTNWIDTH, 0, BTNWIDTH, 34);
        btn.titleLabel.font =  [UIFont systemFontOfSize: 14];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textDarkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateSelected];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:btn];
        [self.btnArr addObject:btn];
    }
}
- (void)createScrollView {
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, SCREENHEIGHT - 35)];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.contentSize = CGSizeMake(4 * SCREENWIDTH, SCREENHEIGHT -35);
    [self.scrollAndBtnView addSubview:self.bottomScrollView];
}

- (void)createTableViews {
    for (int i = 0; i < 4; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, self.bottomScrollView.frame.size.height - 64) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = 80;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [table registerNib:[UINib nibWithNibName:@"CarryLogTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [self.bottomScrollView addSubview:table];
        [self.tableViewArr addObject:table];
        
        //添加上拉加载
        table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
            NSString *nextStr = [self.nextdic objectForKey:number];
            if ([NSString isStringEmpty:nextStr]) {
                [table.mj_footer endRefreshingWithNoMoreData];
//                [SVProgressHUD showInfoWithStatus:@"加载完成,没有更多数据"];
                return;
            }
            [self loadMore];
        }];
    }
}

- (void)titleBtnClickAction:(UIButton *)btn {
    if (btn.selected == YES)return;
    
    NSInteger btnTag = btn.tag - 100;
    self.bottomScrollView.contentOffset = CGPointMake(SCREENWIDTH * (int)btnTag, 0);

    [self changeBtnSelect:btnTag];
    self.currentIndex = btnTag;
    NSMutableDictionary *dic = [self.tableViewDataArr objectAtIndex:self.currentIndex];
    self.allkey = [[dic allKeys] mutableCopy];
    self.allkey = [self sortAllKeyArray:self.allkey];
    if (dic.count == 0) {
        [self requestAction];
    }
}

- (void)changeBtnSelect:(NSInteger)btnTag {
    for (UIButton *button in self.btnArr) {
        if ((button.tag - 100) == btnTag) {
            button.selected = YES;
            continue;
        }
        button.selected = NO;
    }
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --网络请求
- (void)requestAction {
    [MBProgressHUD showLoading:@"正在加载..."];
    NSString *url = self.urlArr[self.currentIndex];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject)return ;
        [self dataAnalysis:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)loadMore {
    
    NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
    NSString *url = [self.nextdic objectForKey:number];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        UITableView *table = [self.tableViewArr objectAtIndex:self.currentIndex];
        [table.mj_footer endRefreshing];
        
        if (!responseObject)return ;
        [self dataAnalysis:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}


- (void)dataAnalysis:(NSDictionary *)dic {
    NSString *next = dic[@"next"];
    NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
    [self.nextdic setObject:next forKey:number];
    
    NSArray *reults = dic[@"results"];
    
    NSMutableDictionary *currentDataDic = self.tableViewDataArr[self.currentIndex];
    for (NSDictionary *carry in reults) {
        CarryLogModel *carryM = [[CarryLogModel alloc] init];
        [carryM setValuesForKeysWithDictionary:carry];
        NSString *date = [self dateDeal:carryM.date_field];
        NSMutableArray *currentKey = [[currentDataDic allKeys] mutableCopy];
        if ([currentKey containsObject:date]) {
            //已经含有key
            NSMutableArray *orderArr = [currentDataDic objectForKey:date];
            [orderArr addObject:carryM];
        }else {
            //没有key
            NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
            [orderArr addObject:carryM];
            [currentDataDic setObject:orderArr forKey:date];
        }
    }
    
    self.allkey = [[currentDataDic allKeys]mutableCopy];
    self.allkey = [self sortAllKeyArray:self.allkey];
    
    //表刷新
    UITableView *table = self.tableViewArr[self.currentIndex];
    [table reloadData];
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
//    NSString *string = [str substringToIndex:10];
    NSString *date = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return date;
}

//将所有的key排序
- (NSMutableArray *)sortAllKeyArray:(NSMutableArray *)keyArr {
    for (int i = 0; i < keyArr.count; i++) {
        for (int j = 0; j < keyArr.count - i - 1; j++) {
            if ([keyArr[j] intValue] < [keyArr[j + 1] intValue]) {
                NSNumber *temp = keyArr[j + 1];
                keyArr[j + 1] = keyArr[j];
                keyArr[j] = temp;
            }
        }
    }
    return keyArr;
}

#pragma mark --scrollView的代理方法w
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger count = scrollView.contentOffset.x / SCREENWIDTH;
        self.currentIndex = count;
        
        NSMutableDictionary *dic = [self.tableViewDataArr objectAtIndex:self.currentIndex];
        self.allkey = [[dic allKeys] mutableCopy];
        self.allkey = [self sortAllKeyArray:self.allkey];

        if (dic.count == 0) {
            [self requestAction];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.bottomScrollView) {
        NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
        NSNumber *contentOffY = [NSNumber numberWithInteger:scrollView.contentOffset.y];
        [self.contentOffsetYDic setObject:contentOffY forKey:number];
    }
    CGPoint offset = scrollView.contentOffset;
    CGFloat currentOffset = offset.y;
    if (currentOffset > SCREENHEIGHT) {
        self.topButton.hidden = NO;
    }else {
        self.topButton.hidden = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger offX = scrollView.contentOffset.x / SCREENWIDTH;
        [self changeBtnSelect:offX];
    }else {
        CGFloat contentOffY = [[self.contentOffsetYDic objectForKey:[NSNumber numberWithInteger:self.currentIndex]] floatValue];
        if (scrollView.dragging) {
            if ((scrollView.contentOffset.y - contentOffY) > 5.0f) {
                //隐藏
                [UIView animateWithDuration:0.5 animations:^{
                    self.headerV.frame = CGRectMake(0, 41, SCREENWIDTH, 105);
                    self.headerV.alpha = 0.0;
                    self.scrollAndBtnView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 35);
                }];
            }else if((contentOffY - scrollView.contentOffset.y) > 5.0f){
                //显示
                [UIView animateWithDuration:0.5 animations:^{
                    self.headerV.frame = CGRectMake(0, 64, SCREENWIDTH, 105);
                    self.headerV.alpha = 1.0;
                    self.scrollAndBtnView.frame = CGRectMake(0, 64 + 105, SCREENWIDTH, SCREENHEIGHT - 35);
                }];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSNumber *number = [NSNumber numberWithInteger:self.currentIndex];
    NSNumber *oldY = [NSNumber numberWithInteger:scrollView.contentOffset.y];
    [self.oldDic setObject:oldY forKey:number];
}
#pragma mark --tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allkey.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *dic = [self.tableViewDataArr objectAtIndex:self.currentIndex];
    NSString *key = self.allkey[section];
    return [dic[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarryLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CarryLogModel *carryLogM = nil;
    
    if((self.allkey != nil) && (self.allkey.count > 0) && (self.tableViewDataArr != nil) && self.tableViewDataArr.count > 0){
    
        NSString *key = self.allkey[indexPath.section];
        NSMutableDictionary *dic = self.tableViewDataArr[self.currentIndex];
        NSMutableArray *order = nil;
        if((dic != nil) && (dic.count > 0)){
            order = dic[key];
            if((order != nil) && (order.count > 0)){
                carryLogM = order[indexPath.row];
            }
        }
    }
    
    if (!cell) {
        cell = [[CarryLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell fillCarryModel:carryLogM type:self.currentIndex];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CarryLogHeaderView"owner:self options:nil];
    if((nibView == nil) || (nibView.count == 0)){
        return nil;
    }
    CarryLogHeaderView *headerV = [nibView objectAtIndex:0];
    headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
    
    CarryLogModel *carryM = nil;
    if((self.allkey != nil) && (self.allkey.count > 0) && (section < self.allkey.count) && (self.tableViewDataArr != nil) && self.tableViewDataArr.count > 0){
        //NSLog(@"self.allkey.count =%lu section =%lu",(unsigned long)self.allkey.count, (unsigned long)section);
        //NSLog(@"self.tableViewDataArr.count =%lu currentindex=%lu", (unsigned long)self.tableViewDataArr.count ,self.currentIndex);
        //计算金额
        NSString *key = self.allkey[section];
        NSMutableDictionary *dic = self.tableViewDataArr[self.currentIndex];
        NSMutableArray *orderArr = nil;
        if((dic != nil) && (dic.count > 0)){
            //NSLog(@"dic.count =%lu key =%@",(unsigned long)dic.count, key);
            orderArr = dic[key];
            if((orderArr != nil) && (orderArr.count > 0)){
                //NSLog(@"orderArr.count =%lu",(unsigned long)orderArr.count);
                carryM = [orderArr firstObject];
            }
        }
        
    }
    if(carryM != nil){
        [headerV yearLabelAndTotalMoneyLabelText:carryM.date_field total:[NSString stringWithFormat:@"%.2f", [carryM.today_carry floatValue]]];
    }
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
#pragma mark 返回顶部  image == >backTop
- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
}
- (void)topButtonClick:(UIButton *)btn {
    self.topButton.hidden = YES;
    [self searchScrollViewInWindow:self.view];
}
- (void)searchScrollViewInWindow:(UIView *)view {
    for (UIScrollView *scrollView in view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGPoint offect = scrollView.contentOffset;
            offect.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offect animated:YES];
        }
        [self searchScrollViewInWindow:scrollView];
    }
}



@end

















