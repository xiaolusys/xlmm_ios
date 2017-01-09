//
//  JMSearchController.m
//  XLMM
//
//  Created by zhang on 17/1/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSearchController.h"
#import "PYSearch.h"


@interface JMSearchController ()<UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *navRightButton;


@end

@implementation JMSearchController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMSearchController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMSearchController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClick)];
    [self createTableView];
    
    
    
    
    
    
    
    
    

}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.f;

    NSString *titleStr = @"搜索";
    CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
    self.navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
    [self.navRightButton addTarget:self action:@selector(rightNavigationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton setTitle:titleStr forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    
}
- (void)rightNavigationClick:(UIButton *)button {
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        //        [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];
    searchViewController.hotSearchStyle = 0; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default
    searchViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据 ---- 第 %ld 行",indexPath.row];
    return cell;
}



- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}












@end




















































































