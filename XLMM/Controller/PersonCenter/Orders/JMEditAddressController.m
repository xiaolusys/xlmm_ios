//
//  JMEditAddressController.m
//  XLMM
//
//  Created by zhang on 16/5/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEditAddressController.h"


@interface JMEditAddressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation JMEditAddressController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    
    
    
}

- (void)createDataSource {
    NSMutableArray *dataSource = [NSMutableArray array];
    self.dataSource = dataSource;
    
    
    
    
}









@end
