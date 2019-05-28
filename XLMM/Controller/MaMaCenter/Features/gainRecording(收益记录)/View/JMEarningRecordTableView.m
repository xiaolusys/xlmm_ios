
//
//  JMEarningRecordTableView.m
//  XLMM
//
//  Created by zhang on 17/3/2.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMEarningRecordTableView.h"
#import "CarryLogModel.h"
#import "JMEarningRecordCell.h"
#import "JMReloadEmptyDataView.h"


@interface JMEarningRecordTableView () <UITableViewDelegate, UITableViewDataSource, CSTableViewPlaceHolderDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *itemDataArr;
@property (nonatomic, strong) NSMutableArray *itemDataSource;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

static NSString *const JMEarningRecordCellIdentifier = @"JMEarningRecordCellIdentifier";

@implementation JMEarningRecordTableView

- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有收益哦..." DescTitle:@"暂时还没有收益记录哦~" ButtonTitle:@"" Image:@"emptyJifenIcon" ReloadBlcok:^{
            
        }];
        _reload = reload;
    }
    return _reload;
}

- (NSMutableArray *)itemDataSource {
    if (!_itemDataSource) {
        _itemDataSource = [NSMutableArray array];
    }
    return _itemDataSource;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
//        self.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
        [self registerClass:[JMEarningRecordCell class] forCellReuseIdentifier:JMEarningRecordCellIdentifier];
        
    }
    return self;
}

- (void)refreshWithData:(id)numberOfRows atIndex:(NSInteger)index {
    self.itemDataSource = numberOfRows[index];
    self.currentIndex = index;
    [self reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.itemDataSource[section];
    return sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMEarningRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:JMEarningRecordCellIdentifier];
    if (!cell) {
        cell = [[JMEarningRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMEarningRecordCellIdentifier];
    }
    CarryLogModel *model = self.itemDataSource[indexPath.section][indexPath.row];
    [cell configModel:model Index:self.currentIndex];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    sectionView.backgroundColor = [UIColor lineGrayColor];
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:14.];
    timeLabel.textColor = [UIColor buttonTitleColor];
    [sectionView addSubview:timeLabel];
    
    UILabel *totalEarningLabel = [UILabel new];
    totalEarningLabel.font = [UIFont systemFontOfSize:14.];
    totalEarningLabel.textColor = [UIColor buttonTitleColor];
    [sectionView addSubview:totalEarningLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(10);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    [totalEarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView).offset(-10);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    CGFloat totalValue;
    NSArray *rowArr = self.itemDataSource[section];
    for (CarryLogModel *model in rowArr) {
        totalValue += [model.carry_value floatValue];
        if ([NSString isStringEmpty:timeLabel.text]) {
            timeLabel.text = model.date_field;
        }
    }
    totalEarningLabel.text = [NSString stringWithFormat:@"总收益 : %.2f",totalValue];
    
    return sectionView;
}

@end





































































