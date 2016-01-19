
//
//  MaMaCarryLogViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaCarryLogViewController.h"
#import "UIViewController+NavigationBar.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "CarryLogModel.h"

@interface MaMaCarryLogViewController ()
@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation MaMaCarryLogViewController
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
    
    [self createNavigationBarWithTitle:@"历史收益" selecotr:@selector(backClickAction)];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/carrylog", Root_URL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark ---数据处理
- (void)dataAnalysis:(NSDictionary *)data {
    NSArray *results = data[@"results"];
    for (NSDictionary *carry in results) {
        CarryLogModel *carryM = [[CarryLogModel alloc] init];
        [carryM setValuesForKeysWithDictionary:carry];
        [self.dataArr addObject:carryM];
    }
    NSLog(@"-------%@", self.dataArr);
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
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
