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

@interface JMGoodsShowController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;



@end

@implementation JMGoodsShowController {
    NSInteger _count;
    NSInteger _packageCount;
}

//- (void)setGoodsModel:(JMOrderGoodsModel *)goodsModel {
//    _goodsModel = goodsModel;
//}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    for (NSArray *arr in dataSource) {
        _count += arr.count;
    }
}
- (void)setPackNumArr:(NSMutableArray *)packNumArr {
    _packNumArr = packNumArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTableView];
    
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, SCREENWIDTH, _count * 90 + self.dataSource.count * 35);
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    if (section > 1) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, SCREENWIDTH, 35);
        view.backgroundColor = [UIColor lineGrayColor];
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.frame = CGRectMake(10, 10, SCREENWIDTH, 15);
        label.text = arr[section];
        return view;
    }else {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
        view.backgroundColor = [UIColor lineGrayColor];
        return view;
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
    self.goodsModel = self.dataSource[indexPath.section][indexPath.row];
    [cell configWithModel:self.goodsModel];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section > 1) {
//        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
//        //判断组数是否唯一  唯一就只显示 (15)的高度    否则  显示(15)的高度加一个View (30)
//        UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
//        [baseView addSubview:garyView];
//        garyView.backgroundColor = [UIColor grayColor];
//        
//        UIView *packageView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
//        [baseView addSubview:packageView];
//        packageView.backgroundColor = [UIColor orangeColor];
//        
//        UILabel *packLabel = [[UILabel alloc] init];
//        [packageView addSubview:packLabel];
//        packLabel.backgroundColor = [UIColor redColor];
//        
//        UILabel *sendLabel = [[UILabel alloc] init];
//        [packageView addSubview:sendLabel];
//        sendLabel.backgroundColor = [UIColor redColor];
//        
//        UIImageView *rightImage = [[UIImageView alloc] init];
//        [packageView addSubview:rightImage];
//        rightImage.backgroundColor = [UIColor redColor];
//        rightImage.image = [UIImage imageNamed:@"icon-jiantouyou"];
//
//        [packLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(packageView).offset(8);
//            make.left.equalTo(packageView).offset(10);
//        }];
//        
//        [sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(packLabel.mas_centerY);
//            make.left.equalTo(rightImage.mas_left).offset(-10);
//        }];
//        
//        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(packLabel.mas_centerY);
//            make.right.equalTo(packageView).offset(-10);
//        }];
//        
//        return baseView;
//    }else {
//        UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
//        [self.view addSubview:garyView];
//        garyView.backgroundColor = [UIColor grayColor];
//        return garyView;
//        
//    }

//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//    
////    if (section > 1) {
////        return 50;
////    }else {
////        return 20;
////    }
////    
//    return 50;
//}





@end




















