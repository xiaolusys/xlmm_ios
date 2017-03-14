//
//  CSCustomerTableView.m
//  XLMM
//
//  Created by zhang on 17/3/14.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSCustomerTableView.h"
#import "JMRootGoodsModel.h"


@interface CSCustomerTableView () <UITableViewDataSource, UITableViewDelegate> {
    BOOL                _isPullDown;
}

@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, assign) NSMutableArray *dataArray;



@end

@implementation CSCustomerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = [UIColor lineGrayColor];
        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"CSCustomerTableViewIndentifier"];
        self.tableFooterView = [UIView new];
        [self createPullHeaderRefresh];
        [self.mj_header beginRefreshing];
        
    }
    return self;
}
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
//        [weakSelf.mj_footer resetNoMoreData];
        [weakSelf loadData];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.mj_header endRefreshing];
    }
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}

- (void)refreshWithCustomerTableViewData:(id)data atIndex:(NSInteger)index {
    self.dataArray = (NSMutableArray *)[data objectForKey:[NSString stringWithFormat:@"%ld",index]];
    self.itemIndex = index;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CSCustomerTableViewIndentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSCustomerTableViewIndentifier"];
    }
    JMRootGoodsModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:11.f];
    cell.textLabel.text = [NSString stringWithFormat:@"ItemView_%ld -- %ld -- %@",_itemIndex,indexPath.row,model.name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}





@end





































































