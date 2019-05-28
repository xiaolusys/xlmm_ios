//
//  ProductSelectionListViewController.m
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ProductSelectionListViewController.h"
#import "YixuanTableViewController.h"
#import "JMProductSelectionListModel.h"
#import "JMProductSelectListCell.h"
#import "JMGoodsDetailController.h"
#import "JMPopMenuView.h"
#import "JMReloadEmptyDataView.h"


#define HeadViewHeight 35

@interface ProductSelectionListViewController ()<UIAlertViewDelegate,CSTableViewPlaceHolderDelegate> //JMProductSelectListCellDelegate
{
    int count;
    
    int category;
    NSInteger reverseCode;
    NSMutableArray *itemNameArray;
    NSMutableArray *itemCidArray;
    NSString *cidString;
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

@property (nonatomic, strong) NSMutableDictionary *param;
//@property (nonatomic, copy) NSString *numbersOfSelected;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;

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
//@property (nonatomic, strong) JMEmptyView *empty;

@end

@implementation ProductSelectionListViewController {
    NSString *_urlStr;
}
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (itemNameArray.count == 0) {
        [self itemData];
    }else {
        [self createPopMenuView:itemNameArray];
    }
    
    [MobClick beginLogPageView:@"ProductSelectionListViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view];
    [JMPopMenuView clearMenu];
    [MobClick endLogPageView:@"ProductSelectionListViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"选品上架" selecotr:@selector(backClickAction)];
    reverseCode = 0;
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    //    [self performSelector:@selector(downloadAlllist) title1:@"全部" title2:@"女装" title3:@"童装"];
    //    self.numberLabel.text = self.numbersOfSelected;
    [self numbersOfSelected];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HeadViewHeight, SCREENWIDTH, SCREENHEIGHT - HeadViewHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 96;
    category = 0;
    //注册cell
    [self.view addSubview:self.tableView];
    [self createHeadView];
//    [self emptyView];
//    [self itemData];
    // --> 不需要删除,先注释掉
    //    [self createrightItem];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    [self.tableView.mj_header beginRefreshing];
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

- (void)numbersOfSelected{
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=1", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return;
        }else {
            NSString *string = [NSString stringWithFormat:@"%@", [[[responseObject objectForKey:@"results"][0] objectForKey:@"shop_product_num"] stringValue]];
            self.numberLabel.text = string;
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //    if(data != nil){
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //        NSString *string = [NSString stringWithFormat:@"%@", [[[dic objectForKey:@"results"][0] objectForKey:@"shop_product_num"] stringValue]];
    //        NSLog(@"count = %@", string);
    //
    //        return string;
    //    }
    //    else{
    //        return nil;
    //    }
    
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
    //    [self.allButton setImage:[UIImage imageNamed:@"downarrowicon"] forState:UIControlStateNormal];
    //    [self.allButton setImage:[UIImage imageNamed:@"uparrowicon"] forState:UIControlStateSelected];
    //    self.allButton.selected = NO;
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 +27, 12, 12, 12)];
    self.selectImageView.backgroundColor = [UIColor clearColor];
    
    self.selectImageView.image = [UIImage imageNamed:@"downarrowicon"];
    
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
    
    //    [self createSeletedView];
    
}

- (void)yongjinorder:(UIButton *)button{
    //    [MBProgressHUD showLoading:@"加载中..."];
    if (reverseCode == 0) {
        reverseCode = 1;
    }else {
        reverseCode = 0;
    }
    [self downloadOrderlist1:reverseCode];
    
    
}

- (void)xiangliangorder:(UIButton *)button{
    //    [MBProgressHUD showLoading:@"加载中..."];
    if (reverseCode == 0) {
        reverseCode = 1;
    }else {
        reverseCode = 0;
    }
    [self downloadOrderlist2:reverseCode];
    
}
- (void)itemData {
    itemNameArray = [NSMutableArray array];
    itemCidArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/categorys",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            [self fetchItemData:responseObject];
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
    
    //    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *path=[paths objectAtIndex:0];
    //    NSString *jsonPath=[path stringByAppendingPathComponent:@"GoodsItemFile.json"];
    //    //==Json数据
    //    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    //    //==JsonObject
    //    if (data == nil) {
    //        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/categorys/latest_version",Root_URL];
    //        [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
    //            if (!responseObject) {
    //                return ;
    //            }else {
    //                [self fetchItemize:responseObject];
    //            }
    //        } WithFail:^(NSError *error) {
    //        } Progress:^(float progress) {
    //        }];
    //    }else {
    //        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //        [self fetchItemData:arr];
    //    }
    
}
//- (void)fetchItemize:(NSDictionary *)dic {
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:dic[@"download_url"] WithParaments:nil WithSuccess:^(id responseObject) {
//        if (!responseObject) {
//            return ;
//        }else {
//            [self fetchItemData:responseObject];
//        }
//    } WithFail:^(NSError *error) {
//    } Progress:^(float progress) {
//    }];

//}
- (void)fetchItemData:(NSArray *)arr {
    [itemNameArray addObject:@"全部"];
    for (NSDictionary *dic in arr) {
        [itemNameArray addObject:dic[@"name"]];
        [itemCidArray addObject:dic[@"cid"]];
    }
    [self createPopMenuView:itemNameArray];
}
- (void)createPopMenuView:(NSArray *)itemArr {
    kWeakSelf
    [JMPopMenuView createMenuWithFrame:CGRectZero target:self dataArray:itemArr itemsClickBlock:^(NSString *str, NSInteger tag) {
        weakSelf.selectImageView.image = [UIImage imageNamed:@"downarrowicon"];
        [weakSelf.allButton setTitle:str forState:UIControlStateNormal];
        if (tag == 1) {
            [weakSelf downloadAlllist:nil];
        }else {
            [weakSelf downloadAlllist:itemCidArray[tag - 2]];
        }
    } backViewTap:^{
        weakSelf.selectImageView.image = [UIImage imageNamed:@"downarrowicon"];
        [JMPopMenuView hidden];
    }];
}

- (void)selectedClicked:(UIButton *)button{
    if (itemNameArray.count == 0) {
        return ;
    }
    self.selectImageView.image = [UIImage imageNamed:@"uparrowicon"];
    CGFloat originX = SCREENWIDTH / 6;
    CGFloat originY = 80;
    CGPoint point = CGPointMake(originX, originY);
    
    [JMPopMenuView showMenuPoint:point];
    
}
- (void)dealloc{
    [JMPopMenuView clearMenu];   // 移除菜单
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [self downloadAlllist:nil];
    }];
}
- (void)createPullFooterRefresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
//- (void)emptyView {
//    kWeakSelf
//    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 160, SCREENWIDTH, SCREENHEIGHT - 160) Title:@"还没有商品哦~" DescTitle:@"去看看其他分类吧~" BackImage:@"gouwucheemptyimage" InfoStr:@"查看分类"];
//    [self.view addSubview:self.empty];
//    self.empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [weakSelf selectedClicked:nil];
//        }
//    };
//    self.empty.hidden = YES;
//}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"还没有商品哦~" DescTitle:@"去看看其他分类吧~" ButtonTitle:@"查看分类" Image:@"gouwucheemptyimage" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}

- (void)fetchedDatalist:(NSDictionary *)dic{
    self.nextUrl = nil;
    NSArray *array = [dic objectForKey:@"results"];
    self.nextUrl = dic[@"next"];
    NSLog(@"next = %@", self.nextUrl);
    if (array.count != 0) {
        for (NSDictionary *dict in array) {
            self.listModel = [JMProductSelectionListModel mj_objectWithKeyValues:dict];
            [self.dataArr addObject:self.listModel];
        }
    }
    [self.tableView cs_reloadData];
}
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:nil  WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.dataArr removeAllObjects];
        [self fetchedDatalist:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark 数据请求 (主要)
- (void)loadDataSource:(NSMutableDictionary *)param {
    [MBProgressHUD showLoading:@"小鹿努力加载中~" ToView:self.view];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:param WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.dataArr removeAllObjects];
        [self fetchedDatalist:responseObject];
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:self.nextUrl]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextUrl WithParaments:self.param WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchedDatalist:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

/**
 *  全部
 */
- (void)downloadAlllist:(NSString *)cid {
    [JMPopMenuView hidden];
    cidString = cid;
    //    [MBProgressHUD showLoading:@"加载中..."];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/product_choice?page=1", Root_URL];
    if (cid == nil) {
        //        self.param[@"page"] = @"1";
        [self loadDataSource:nil];
    }else {
        //        self.param[@"page"] = @"1";
        self.param[@"cid"] = cid;
        [self loadDataSource:self.param];
    }
    
    
    
}
///**
// *  童装
// */
//- (void)downloadChildliat{
////    [MBProgressHUD showLoading:@"加载中..."];
//    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
//    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
//    category = 1;
//    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
//    [self loadDataSource];
//}
///**
// *  女装
// */
//- (void)downloadLadylist{
////    [MBProgressHUD showLoading:@"加载中..."];
//    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
//    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
//    category = 2;
//    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
//    [self loadDataSource];
//
//}
/**
 *  佣金排序
 */
- (void)downloadOrderlist1:(NSInteger)code {
    [self.orderByPriceButton setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    //    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d&sort_field=%@&reverse=%ld", Root_URL, category, @"rebet_amount",code];
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/product_choice?page=1",Root_URL];
    //    self.param[@"page"] = @"1";
    self.param[@"sort_field"] = @"rebet_amount";
    self.param[@"cid"] = cidString;
    self.param[@"reverse"] = [NSString stringWithFormat:@"%ld",code];
    
    [self loadDataSource:self.param];
}
/**
 *  售卖排序
 */
- (void)downloadOrderlist2:(NSInteger)code {
    [self.orderBySaleButon setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    //     _urlStr = [NSString stringWithFormat:@"%@/rest/v2/products/my_choice_pro?page_size=20&category=%d&sort_field=%@&reverse=%ld", Root_URL, category, @"sale_num",code];
    _urlStr = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/product_choice?page=1",Root_URL];
    //    self.param[@"page"] = @"1";
    self.param[@"sort_field"] = @"sale_num";
    self.param[@"cid"] = cidString;
    self.param[@"reverse"] = [NSString stringWithFormat:@"%ld",code];
    
    [self loadDataSource:self.param];
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
    //    cell.delegate = self;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMProductSelectionListModel *listModel = self.dataArr[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = listModel.goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ---cell的代理方法
//- (void)composeProductSelectionList:(JMProductSelectListCell *)selectList addButton:(UIButton *)button {
//    [MBProgressHUD showLoading:@"加载中，请稍后..."];
//    if (button.selected) {
//        //网络请求
//        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
//        NSDictionary *parameters = @{@"product":selectList.pdtID};
//        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:url WithParaments:parameters WithSuccess:^(id responseObject) {
//            [MBProgressHUD showSuccess:@"下架成功"];
//            [button setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiajia.png"] forState:UIControlStateNormal];
//            selectList.statusLabel.text = @"加入精选";
//            button.selected = NO;
//            //            [btn setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
//            //修改数据源中的数据
//            selectList.listModel.in_customer_shop = @0;
//
////            self.numberLabel.text = self.numbersOfSelected;
//            [self numbersOfSelected];
//        } WithFail:^(NSError *error) {
//            NSLog(@"上下架－－Error: %@", error);
//        } Progress:^(float progress) {
//
//        }];
//
//    }else {
//        //网络请求
//        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/add_pro_to_shop", Root_URL];
//        NSDictionary *parameters = @{@"product":selectList.pdtID};
//        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:url WithParaments:parameters WithSuccess:^(id responseObject) {
//            //已上架
//            [MBProgressHUD showSuccess:@"上架成功"];
//            //[btn setTitle:@"下架" forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiaright.png"] forState:UIControlStateNormal];;
//            selectList.statusLabel.text = @"已加入";
//
//            button.selected = YES;
//            //            [btn setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
//            //修改数据源中的数据
//            selectList.listModel.in_customer_shop = @1;
//
////            self.numberLabel.text = self.numbersOfSelected;
//            [self numbersOfSelected];
//        } WithFail:^(NSError *error) {
//            NSLog(@"上下架－－Error: %@", error);
//        } Progress:^(float progress) {
//            
//        }];
//    }
//
//    
//}



@end
