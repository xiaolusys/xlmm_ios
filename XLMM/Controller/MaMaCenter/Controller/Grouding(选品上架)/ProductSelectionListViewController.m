//
//  ProductSelectionListViewController.m
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ProductSelectionListViewController.h"
#import "MMClass.h"
#import "YixuanTableViewController.h"
#import "JMProductSelectionListModel.h"
#import "JMProductSelectListCell.h"
#import "JMGoodsDetailController.h"



#define HeadViewHeight 35

@interface ProductSelectionListViewController ()<UIAlertViewDelegate,JMProductSelectListCellDelegate>
{
    int count;
   
    int category;
}
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy) NSString *nextUrl;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *orderByPriceButton;
@property (nonatomic, strong) UIButton *orderBySaleButon;
@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIImageView *backImageView;


@property (nonatomic, strong) UILabel *numberLabel;


@property (nonatomic, copy) NSString *numbersOfSelected;
/**
 *  下拉的标志
 */
@property (nonatomic,assign) BOOL isPullDown;
/**
 *  上拉的标志
 */
@property (nonatomic, assign) BOOL isLoadMore;
/**
 *  选品上架数据源
 */
@property (nonatomic, strong) JMProductSelectionListModel *listModel;

@end

@implementation ProductSelectionListViewController {
    NSString *_urlStr;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView.mj_header beginRefreshing];
    
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    
    [self performSelector:@selector(downloadAlllist) title1:@"全部" title2:@"女装" title3:@"童装"];

    self.numberLabel.text = self.numbersOfSelected;
    
    [MobClick beginLogPageView:@"ProductSelectionListViewController"];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"ProductSelectionListViewController"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"选品上架" selecotr:@selector(backClickAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HeadViewHeight, SCREENWIDTH, SCREENHEIGHT - HeadViewHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 96;
    category = 0;
    //注册cell
    [self.view addSubview:self.tableView];

    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self createHeadView];
   
    // --> 不需要删除,先注释掉
//    [self createrightItem];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
}
#pragma mark --- 加载数据

- (void)createrightItem{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    //已选label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    label.text = @"已选";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithR:98 G:98 B:98 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    //number
    
    UIView *orongeView = [[UIView alloc] initWithFrame:CGRectMake(40, 10, 22, 22)];
    orongeView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [view addSubview:orongeView];
    orongeView.layer.cornerRadius = 11;

    self.numberLabel = [[UILabel alloc] initWithFrame:orongeView.bounds];
    self.numberLabel.text = @"0";
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    [orongeView addSubview:self.numberLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = view.bounds;
    [btn addTarget:self action:@selector(yixuanClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


- (void)yixuanClicked{
    NSLog(@"yixuan de");
    
    YixuanTableViewController *vc = [[YixuanTableViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSString *)numbersOfSelected{
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=1", Root_URL];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if(data != nil){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *string = [NSString stringWithFormat:@"%@", [[[dic objectForKey:@"results"][0] objectForKey:@"shop_product_num"] stringValue]];
        NSLog(@"count = %@", string);
        
        return string;
    }
    else{
        return nil;
    }
    
}

- (void)createHeadView{
    CGFloat height = HeadViewHeight;
    CGFloat width = SCREENWIDTH/3;
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, height)];
    [self.view addSubview:self.headView];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.allButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.allButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.allButton setTitle:@"全部" forState:UIControlStateNormal];
    self.allButton.frame = CGRectMake(0, 0, width, height);
    [self.headView addSubview:self.allButton];
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 +15, 12, 12, 12)];
    self.selectImageView.backgroundColor = [UIColor clearColor];
    
    self.selectImageView.image = [UIImage imageNamed:@"downarrowicon.png"];
    
    [self.allButton addSubview:self.selectImageView];
    
    
    self.orderByPriceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitle:@"佣金排序" forState:UIControlStateNormal];
    self.orderByPriceButton.frame = CGRectMake(width, 0, width, height);
    [self.headView addSubview:self.orderByPriceButton];
    
    self.orderBySaleButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderBySaleButon setTitle:@"售卖排序" forState:UIControlStateNormal];
    self.orderBySaleButon.frame = CGRectMake(width + width, 0, width, height);
    [self.headView addSubview:self.orderBySaleButon];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lineGrayColor];
    [self.headView addSubview:lineView];
    
    [self.allButton addTarget:self action:@selector(selectedClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderByPriceButton addTarget:self action:@selector(yongjinorder:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderBySaleButon addTarget:self action:@selector(xiangliangorder:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSeletedView];
    
}

- (void)yongjinorder:(UIButton *)button{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self downloadOrderlist1];
}

- (void)xiangliangorder:(UIButton *)button{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self downloadOrderlist2];
}

- (void)selectedClicked:(UIButton *)button{
    self.selectedView.hidden = NO;
    self.selectImageView.image = [UIImage imageNamed:@"uparrowicon.png"];
}

- (void)createSeletedView{
    CGFloat width = 75;
    CGFloat height = 100;
    CGFloat originX = SCREENWIDTH/6 - 30;
    CGFloat originY = 90;
    

    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    self.backImageView = [[UIImageView alloc ] initWithFrame:self.selectedView.bounds];
    self.backImageView.image = [UIImage imageNamed:@"selectedImageView.png"];
    [self.selectedView addSubview:self.backImageView];
    [self.view addSubview:self.selectedView];
    self.selectedView.hidden = YES;
    
    self.secondButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, width, 44)];
    [self.secondButton setTitle:@"童装" forState:UIControlStateNormal];
    [self.secondButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.selectedView addSubview:self.secondButton];
   
    self.firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, width, 44)];
    [self.firstButton setTitle:@"女装" forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.selectedView addSubview:self.firstButton];
    
    [self.firstButton addTarget:self action:@selector(firstbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondButton addTarget:self action:@selector(secondButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)hiddeSeletedView{
    self.selectedView.hidden = YES;
    self.selectImageView.image = [UIImage imageNamed:@"downarrowicon"];
    
    
}
- (void)performSelector:(SEL)aSelector title1:(NSString *)title1 title2:(NSString *)title2 title3:(NSString*)title3{
    if ([self respondsToSelector:aSelector]) {
        [self performSelector:aSelector withObject:nil];
    }
    [self hiddeSeletedView];
    [self.allButton setTitle:title1 forState:UIControlStateNormal];
    [self.firstButton setTitle:title2 forState:UIControlStateNormal];
    [self.secondButton setTitle:title3 forState:UIControlStateNormal];
    
    
}
- (void)firstbuttonClicked:(UIButton *)button{
   
    if ([self.firstButton.currentTitle isEqualToString:@"女装"]) {
        [self performSelector:@selector(downloadLadylist) title1:@"女装" title2:@"全部" title3:@"童装"];
      
    } else if ([self.firstButton.currentTitle isEqualToString:@"全部"]){
        [self performSelector:@selector(downloadAlllist) title1:@"全部" title2:@"女装" title3:@"童装"];
    }
   
}
- (void)secondButtonClicked:(UIButton *)button{
    if ([self.secondButton.currentTitle isEqualToString:@"女装"]) {
        [self performSelector:@selector(downloadLadylist) title1:@"女装" title2:@"全部" title3:@"童装"];
      
        
    } else if ([self.secondButton.currentTitle isEqualToString:@"童装"]){
        [self performSelector:@selector(downloadChildliat) title1:@"童装" title2:@"全部" title3:@"女装"];
    
    }
}

#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)fetchedDatalist:(NSDictionary *)dic{
    [SVProgressHUD dismiss];

    self.nextUrl = nil;

    NSArray *array = [dic objectForKey:@"results"];
    self.nextUrl = dic[@"next"];
    
    NSLog(@"next = %@", self.nextUrl);
    if (array.count == 0) {
        return;
    }

    for (NSDictionary *dic in array) {
        self.listModel = [JMProductSelectionListModel mj_objectWithKeyValues:dic];
        [self.dataArr addObject:self.listModel];
    }
    
}
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.dataArr removeAllObjects];
        [self fetchedDatalist:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([self.nextUrl class] == [NSNull class]) {
        [self endRefresh];
        [SVProgressHUD showInfoWithStatus:@"加载完成,没有更多数据"];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchedDatalist:responseObject];
        [self endRefresh];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
/**
 *  全部
 */
- (void)downloadAlllist{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    category = 0;
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
    
    [self loadDataSource];
    
}
/**
 *  童装
 */
- (void)downloadChildliat{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    category = 1;
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
    [self loadDataSource];
}
/**
 *  女装
 */
- (void)downloadLadylist{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    category = 2;
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
    [self loadDataSource];
    
}
/**
 *  佣金排序
 */
- (void)downloadOrderlist1{
    [self.orderByPriceButton setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d&sort_field=%@", Root_URL, category, @"rebet_amount"];
    [self loadDataSource];
}
/**
 *  售卖排序
 */
- (void)downloadOrderlist2{
    [self.orderBySaleButon setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
     _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d&sort_field=%@", Root_URL, category, @"sale_num"];
    [self loadDataSource];
}
- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- uitableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"productSelection";
    JMProductSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[JMProductSelectListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    JMProductSelectionListModel *listModel = self.dataArr[indexPath.row];
    [cell configListCell:listModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMProductSelectionListModel *listModel = self.dataArr[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = listModel.goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ---cell的代理方法
- (void)composeProductSelectionList:(JMProductSelectListCell *)selectList addButton:(UIButton *)button {
    [SVProgressHUD showWithStatus:@"加载中，请稍后..."];
    if (button.selected) {
        //网络请求
        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
        NSDictionary *parameters = @{@"product":selectList.pdtID};
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:url WithParaments:parameters WithSuccess:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"下架成功"];
            [button setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiajia.png"] forState:UIControlStateNormal];
            selectList.statusLabel.text = @"加入精选";
            button.selected = NO;
            //            [btn setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
            //修改数据源中的数据
            selectList.listModel.in_customer_shop = @0;
            
            self.numberLabel.text = self.numbersOfSelected;
        } WithFail:^(NSError *error) {
            NSLog(@"上下架－－Error: %@", error);
        } Progress:^(float progress) {
            
        }];
    
    }else {
        //网络请求
        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/add_pro_to_shop", Root_URL];
        NSDictionary *parameters = @{@"product":selectList.pdtID};
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:url WithParaments:parameters WithSuccess:^(id responseObject) {
            //已上架
            [SVProgressHUD showSuccessWithStatus:@"上架成功"];
            //[btn setTitle:@"下架" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiaright.png"] forState:UIControlStateNormal];;
            selectList.statusLabel.text = @"已加入";
            
            button.selected = YES;
            //            [btn setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
            //修改数据源中的数据
            selectList.listModel.in_customer_shop = @1;
            
            self.numberLabel.text = self.numbersOfSelected;
        } WithFail:^(NSError *error) {
            NSLog(@"上下架－－Error: %@", error);
        } Progress:^(float progress) {
            
        }];
    }

    
}



@end
