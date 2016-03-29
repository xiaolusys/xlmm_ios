//
//  ProductSelectionListViewController.m
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ProductSelectionListViewController.h"
#import "UIViewController+NavigationBar.h"
#import "ProductSelectionListCell.h"
#import "MMClass.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "YixuanTableViewController.h"

#import "MaMaSelectProduct.h"



#define HeadViewHeight 35

@interface ProductSelectionListViewController ()<UIAlertViewDelegate>
{
    int count;
   
    int category;
}
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)UITableView *tableView;

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



@end

static NSString *cellIdentifier = @"productSelection";
@implementation ProductSelectionListViewController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    
    [self performSelector:@selector(downloadAlllist) title1:@"全部" title2:@"女装" title3:@"童装"];
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=20", Root_URL];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    self.numberLabel.text = self.numbersOfSelected;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [self createNavigationBarWithTitle:@"选品上架" selecotr:@selector(backClickAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HeadViewHeight, SCREENWIDTH, SCREENHEIGHT - HeadViewHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 96;
    category = 0;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSelectionListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self createHeadView];
   
    [self createrightItem];
    
}

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
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=1", Root_URL];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *string = [NSString stringWithFormat:@"%@", [[[dic objectForKey:@"results"][0] objectForKey:@"shop_product_num"] stringValue]];
    NSLog(@"count = %@", string);
    
    return string;
    
    
    
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

- (void)fetchedDatalist:(NSData *)data{
    [SVProgressHUD dismiss];
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"error = %@", error);
        return;
    }
    NSArray *array = [dic objectForKey:@"results"];
    if (array.count == 0) {
        return;
    }
  //  NSLog(@"list = %@", array);
    [self.dataArr removeAllObjects];
    for (NSDictionary *pdt in array) {
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        [productM setValuesForKeysWithDictionary:pdt];
        [self.dataArr addObject:productM];
    }
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}



- (void)downloadAlllist{
    [SVProgressHUD showWithStatus:@"加载中..."];
  //  NSLog(@"all");
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    category = 0;
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedDatalist:)];
    
}
- (void)downloadChildliat{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
  //  NSLog(@"child");
    category = 1;
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedDatalist:)];
    
}
- (void)downloadLadylist{
    [SVProgressHUD showWithStatus:@"加载中..."];
   // NSLog(@"lady");
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    category = 2;
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=20&category=%d", Root_URL, category];
    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedDatalist:)];
}

- (void)downloadOrderlist1{
    [self.orderByPriceButton setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [self.orderBySaleButon setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
  //  NSLog(@"yongjin");
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=20&category=%d&sort_field=%@", Root_URL, category, @"rebet_amount"];
   // NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedDatalist:)];
}
- (void)downloadOrderlist2{
    [self.orderBySaleButon setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
    [self.orderByPriceButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
   // NSLog(@"xiaoliang");
     NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro?page_size=20&category=%d&sort_field=%@", Root_URL, category, @"sale_num"];
//    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedDatalist:)];
}
- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --数据处理
- (void)dealData:(NSDictionary *)data {
    
    [self.dataArr removeAllObjects];
    NSArray *array = data[@"results"];
    
    
    for (NSDictionary *pdt in array) {
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        [productM setValuesForKeysWithDictionary:pdt];
        [self.dataArr addObject:productM];
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [SVProgressHUD dismiss];
    
    [self.tableView reloadData];
    
    
   
}


#pragma mark -- uitableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    
    MaMaSelectProduct *product = self.dataArr[indexPath.row];
    if (!cell) {
        cell = [[ProductSelectionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        
    }
    [cell fillCell:product];
    return cell;
    
}


#pragma mark ---cell的代理方法
- (void)productSelectionListBtnClick:(ProductSelectionListCell *)cell btn:(UIButton *)btn {
    [SVProgressHUD showWithStatus:@"加载中，请稍后..."];
    if (btn.selected) {
        //网络请求
        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
        NSDictionary *parameters = @{@"product":cell.pdtID};
        
        [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"下架成功"];
            [btn setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiajia.png"] forState:UIControlStateNormal];
            cell.statusLabel.text = @"加入精选";
           btn.selected = NO;
//            [btn setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
            //修改数据源中的数据
            cell.pdtModel.in_customer_shop = @0;
            
            self.numberLabel.text = self.numbersOfSelected;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"上下架－－Error: %@", error);
        }];
        
    }else {
        //网络请求
        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/add_pro_to_shop", Root_URL];
        NSDictionary *parameters = @{@"product":cell.pdtID};
        [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //已上架
            [SVProgressHUD showSuccessWithStatus:@"上架成功"];
            //[btn setTitle:@"下架" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiaright.png"] forState:UIControlStateNormal];;
            cell.statusLabel.text = @"已加入";

           btn.selected = YES;
//            [btn setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
            //修改数据源中的数据
            cell.pdtModel.in_customer_shop = @1;
            
            self.numberLabel.text = self.numbersOfSelected;

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"上下架－－Error: %@", error);
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
