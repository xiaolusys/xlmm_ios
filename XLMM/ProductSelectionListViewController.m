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
#import "MaMaSelectProduct.h"


@interface ProductSelectionListViewController ()
{
    int count;
}
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)UITableView *tableView;

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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [self createNavigationBarWithTitle:@"选品上架" selecotr:@selector(backClickAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 118;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSelectionListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/products/my_choice_pro", Root_URL];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --数据处理
- (void)dealData:(NSArray *)data {
    for (NSDictionary *pdt in data) {
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        [productM setValuesForKeysWithDictionary:pdt];
        [self.dataArr addObject:productM];
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    
}

#pragma mark -- uitableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductSelectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;

    if (count < 6) {
        CGPoint originPoint = cell.center;
        cell.center = CGPointMake(SCREENWIDTH, originPoint.y);
        
        [UIView animateWithDuration:0.5 animations:^{
            cell.center = CGPointMake(SCREENWIDTH * 0.5, originPoint.y);
        }];
        count++;
    }
    
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
        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/cushoppros/remove_pro_from_shop", Root_URL];
        NSDictionary *parameters = @{@"product":cell.pdtID};
        
        [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"下架成功"];
            btn.selected = NO;
            [btn setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
            //修改数据源中的数据
            cell.pdtModel.in_customer_shop = @0;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"上下架－－Error: %@", error);
        }];
        
    }else {
        //网络请求
        NSString *url = [NSString stringWithFormat:@"%@/rest/v1/cushoppros/add_pro_to_shop", Root_URL];
        NSDictionary *parameters = @{@"product":cell.pdtID};
        [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //已上架
            [SVProgressHUD showSuccessWithStatus:@"上架成功"];
            btn.selected = YES;
            [btn setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
            //修改数据源中的数据
            cell.pdtModel.in_customer_shop = @1;
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