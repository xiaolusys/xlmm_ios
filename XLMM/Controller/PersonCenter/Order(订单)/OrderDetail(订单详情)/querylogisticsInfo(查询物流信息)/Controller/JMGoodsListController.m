//
//  JMGoodsListController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsListController.h"
#import "JMGoodsListCell.h"
#import "JMOrderGoodsModel.h"

@interface JMGoodsListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation JMGoodsListController
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];

}
- (void)setCount:(NSInteger)count {
    _count = count;
}
- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.count * 110) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;

}
- (void)setGoodsListArr:(NSMutableArray *)goodsListArr {
    _goodsListArr = goodsListArr;
    self.dataSource = goodsListArr;
}
//- (void)setGoodsModel:(JMOrderGoodsModel *)goodsModel {
//    _goodsModel = goodsModel;
//    if(goodsModel != nil){
//        [self.dataSource addObject:goodsModel];
//    }
//    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMOrderGoodsModel *goodsModel = self.dataSource[indexPath.row];
    [cell configData:goodsModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}





@end






























