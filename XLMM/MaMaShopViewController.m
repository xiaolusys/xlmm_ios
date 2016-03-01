//
//  MaMaShopViewController.m
//  XLMM
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//


#import "MaMaShopViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "ProductSelectionListCell.h"
#import "MaMaSelectProduct.h"
#import "ShopPreviousViewController.h"
#import "WXApi.h"


@interface MaMaShopViewController ()
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign)BOOL isRequest;



@end

static NSString *cellIdentifier = @"SelectedListCell";
@implementation MaMaShopViewController
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
    
    self.isRequest = NO;
    
    [self createNavigationBarWithTitle:@"我的精选" selecotr:@selector(backClickAction)];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(previewAction)];

    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItems = @[rightItem2, rightItem1];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 118;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    self.tableView.tableHeaderView = tableHeaderView;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSelectionListCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros", Root_URL];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



//预览
- (void)previewAction {
    ShopPreviousViewController *previous = [[ShopPreviousViewController alloc] init];
    [self.navigationController pushViewController:previous animated:YES];
}

//分享
- (void)shareAction {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"小鹿妈妈店铺分享" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
        }
    }];
}

#pragma mark --数据处理
- (void)dealData:(NSArray *)data {
    for ( NSDictionary *pdt in data) {
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        [productM setValuesForKeysWithDictionary:pdt];
        [self.dataArr addObject:productM];
    }
    [self.tableView reloadData];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- uitableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductSelectionListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MaMaSelectProduct *product = self.dataArr[indexPath.row];
    if (!cell) {
        cell = [[ProductSelectionListCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell fillMyChoice:product];
    return cell;
}

#pragma mark-- cell的代理方法
- (void)productSelectionListBtnClick:(ProductSelectionListCell *)cell btn:(UIButton *)btn {
    if (self.isRequest)return;
    self.isRequest = YES;
    //网络请求
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
    NSDictionary *parameters = @{@"product":cell.pdtID};
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *rows = [NSArray arrayWithObject:indexPath];
    
    [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.isRequest = NO;
        [self.dataArr removeObject:cell.pdtModel];
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"店铺－－Error: %@", error);
    }];

}

- (void)productSelectionShareClick:(ProductSelectionListCell *)cell btn:(UIButton *)btn{
    NSLog(@"share");
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
