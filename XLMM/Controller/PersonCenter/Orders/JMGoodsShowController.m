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

@interface JMGoodsShowController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;



@end

@implementation JMGoodsShowController

- (void)setGoodsModel:(JMOrderGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.frame;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

#pragma mark ---- 实现tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //在这里处理数据的赋值
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        //判断组数是否唯一  唯一就只显示 (15)的高度    否则  显示(15)的高度加一个View (30)
        UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
        [baseView addSubview:garyView];
        garyView.backgroundColor = [UIColor grayColor];
        
        UIView *packageView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
        [baseView addSubview:packageView];
        packageView.backgroundColor = [UIColor orangeColor];
        
        UILabel *packLabel = [[UILabel alloc] init];
        [packageView addSubview:packLabel];
        packLabel.backgroundColor = [UIColor redColor];
        
        UILabel *sendLabel = [[UILabel alloc] init];
        [packageView addSubview:sendLabel];
        sendLabel.backgroundColor = [UIColor redColor];
        
        UIImageView *rightImage = [[UIImageView alloc] init];
        [packageView addSubview:rightImage];
        rightImage.backgroundColor = [UIColor redColor];
        rightImage.image = [UIImage imageNamed:@"icon-jiantouyou"];

        [packLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(packageView).offset(8);
            make.left.equalTo(packageView).offset(10);
        }];
        
        [sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(packLabel.mas_centerY);
            make.left.equalTo(rightImage.mas_left).offset(-10);
        }];
        
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(packLabel.mas_centerY);
            make.right.equalTo(packageView).offset(-10);
        }];
        
        return baseView;
    }else {
        UIView *garyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
        [self.view addSubview:garyView];
        garyView.backgroundColor = [UIColor grayColor];
        return garyView;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    if (section > 1) {
        return 50;
    }else {
        return 15;
    }
    
    
}





@end




















