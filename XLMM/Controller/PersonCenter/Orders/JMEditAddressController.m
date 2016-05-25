//
//  JMEditAddressController.m
//  XLMM
//
//  Created by zhang on 16/5/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEditAddressController.h"


@interface JMEditAddressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableViews;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation JMEditAddressController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
}

- (void)createTableView {
    
    UITableView *tableViews = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableViews = tableViews;
    [self.view addSubview:self.tableViews];
    
    
    
    
}

- (void)createDataSource {
    NSMutableArray *dataSource = [NSMutableArray array];
    self.dataSource = dataSource;
    
    
    
    
}

@end
