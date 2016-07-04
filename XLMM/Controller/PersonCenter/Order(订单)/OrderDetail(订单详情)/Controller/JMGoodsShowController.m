//
//  JMGoodsShowController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsShowController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMBaseGoodsCell.h"
#import "JMQueryLogInfoController.h"
#import "UIViewController+NavigationBar.h"
#import "JMPackAgeModel.h"
#import "JMOrderGoodsModel.h"

@interface JMGoodsShowController ()<JMBaseGoodsCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JMGoodsShowController {
    NSInteger _count;
    NSInteger _packageCount;
    BOOL _isExsitingPackage;
    BOOL _isExsitingorder;
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    for (NSArray *arr in dataSource) {
         _count += arr.count;
    }
    
}
- (void)setLogisticsArr:(NSMutableArray *)logisticsArr {
    _logisticsArr = logisticsArr;
//    if (logisticsArr.count == 0) {
//        //没有包裹信息
//        _isExsitingPackage = NO;
//    }else {
//        //有包裹信息
//        _isExsitingPackage = YES;
//    }
}
- (void)setPackOrderID:(NSString *)packOrderID {
    _packOrderID = packOrderID;
    if (packOrderID.length == 0) {
        _packageCount = 0;
        _isExsitingPackage = NO;
    }else {
        _packageCount = _logisticsArr.count;
        _isExsitingPackage = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTableView];
    
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, _count * 90 + _packageCount * 35);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = nil;
    self.tableView.scrollEnabled = NO;
}
#pragma mark ---- 实现tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isExsitingPackage) {
        return 35;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    if (_isExsitingPackage) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        view.frame = CGRectMake(0, 0, SCREENWIDTH, 35);
        view.backgroundColor = [UIColor sectionViewColor];
        UILabel *label = [UILabel new];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        label.font = [UIFont systemFontOfSize:13.];
        label.textColor = [UIColor timeLabelColor];
        if (_isExsitingorder) {
            label.text = [NSString stringWithFormat:@"包裹%@",arr[section]];
        }else {
            label.text = @"无包裹查询信息";
        }
        
        [view addTarget:self action:@selector(packageClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = 100 + section;
        UILabel *descLabel = [UILabel new];
        [view addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        descLabel.font = [UIFont systemFontOfSize:13.];
        descLabel.textColor = [UIColor timeLabelColor];
        self.descLabel = descLabel;
        NSArray *arr = self.logisticsArr[section];
        JMPackAgeModel *packageModel = [[JMPackAgeModel alloc] init];
        packageModel = arr[0];
        self.descLabel.text = packageModel.assign_status_display;
        return view;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //在这里处理数据的赋值
    self.goodsModel = [[JMOrderGoodsModel alloc] init];
    self.packageModel = [[JMPackAgeModel alloc] init];
    self.goodsModel = self.dataSource[indexPath.section][indexPath.row];
    if (_isExsitingPackage) {
        self.packageModel = self.logisticsArr[indexPath.section];
    }else {
        self.packageModel = nil;
    }
    [cell configWithModel:self.goodsModel PackageModel:self.packageModel SectionCount:indexPath.section RowCount:indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;

    cell.delegate = self;
    return cell;
}
// 走代理 或者 模态视图控制器
- (void)packageClick:(UIButton *)btn {
    NSInteger count = btn.tag - 100;
    if (_delegate && [_delegate respondsToSelector:@selector(composeWithLogistics:didClickButton:)]) {
        [_delegate composeWithLogistics:self didClickButton:count];
    }
}
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row {
    if (_delegate && [_delegate respondsToSelector:@selector(composeOptionBtnClick:Button:Section:Row:)]) {
        [_delegate composeOptionBtnClick:self Button:button Section:section Row:row];
    }
}
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row {
    if (_delegate && [_delegate respondsToSelector:@selector(composeOptionTapClick:Tap:Section:Row:)]) {
        [_delegate composeOptionTapClick:self Tap:tap Section:section Row:row];
    }
}

@end

/**
 *      // 100 申请退款 101 确认收货 102 退货退款 103 秒杀不退不换
 switch (button.tag) {
 case 100:
 
 break;
 case 101:
 
 break;
 case 102:
 
 break;
 case 103:
 
 break;
 default:
 break;
 }
 */





































































































