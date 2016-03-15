//
//  WuliuCompanyController.m
//  XLMM
//
//  Created by younishijie on 15/11/30.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "WuliuCompanyController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "FillWuliuController.h"


@interface WuliuCompanyController ()

@property (nonatomic, strong) NSArray *companyArray;
@property (nonatomic, strong) NSArray *HeaderArray;

@end

@implementation WuliuCompanyController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)backClicked:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"物流公司" selecotr:@selector(backClicked:)];
    [self prepareDate];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCellIdentifier"];
  //  self.tableView.style = UITableViewStyleGrouped;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)prepareDate{
    self.HeaderArray = @[@"A", @"B", @"D", @"E",
                         @"F", @"G", @"J", @"K",
                         @"M", @"Q", @"R", @"S",
                         @"T", @"W", @"Y", @"Z"];
    self.companyArray = @[@[@"AAE全球传递"],
                          @[@"百世汇通"],
                          @[@"德邦快递"],
                          @[@"EMS"],
                          @[@"FedEx国际件",@"凡客配送",@"凡宇快递"],
                          @[@"国通快递"],
                          @[@"佳吉快运",@"京东快递"],
                          @[@"快捷快递",@"跨越快递"],
                          @[@"民航快递",@"民邦快递"],
                          @[@"全峰快递",@"全一快递",@"全晨快递"],
                          @[@"如风达快递"],
                          @[@"顺丰快递",@"申通快递",@"速尔快递"],
                          @[@"天天快递"],
                          @[@"万象物流"],
                          @[@"圆通快递",@"韵达快递",@"邮政包裹"],
                          @[@"中通快递",@"宅急送"],
                          ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.companyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self.companyArray objectAtIndex:section]).count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellIdentifier" forIndexPath:indexPath];
    NSArray *array = [self.companyArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH , 25)];
    view.backgroundColor = [UIColor backgroundlightGrayColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor dingfanxiangqingColor];
    label.frame = CGRectMake(8, 0, 40, 25);
    label.font = [UIFont systemFontOfSize:16];
    label.text = self.HeaderArray[section];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = self.companyArray[indexPath.section][indexPath.row];
    NSLog(@"string = %@", string);
    NSArray *arrays = self.navigationController.viewControllers;
    FillWuliuController *vc = arrays[arrays.count - 2];
    vc.companyTextField.text = string;
    [self.navigationController popToViewController:vc animated:YES];
}


@end
