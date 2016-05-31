//
//  JMOrderNumTimeView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//
/**
 *  这个界面是显示待支付 -- 待发货   等详细信息
 */
#import "JMOrderNumTimeView.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMOrderNumTimeModel.h"

@interface JMOrderNumTimeView ()

@property (nonatomic,strong) UIView *bakeView;

@property (nonatomic,strong) UILabel *orderLabel;

@property (nonatomic,strong) UILabel *orderNumLabel;

@property (nonatomic,strong) UILabel *payStateLabel;

@property (nonatomic,strong) UILabel *ordersTimeLabel;



@end

@implementation JMOrderNumTimeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIView *backView = [UIView new];
    [self addSubview:backView];
    self.bakeView = backView;
    
    UILabel *orderLabel = [[UILabel alloc] init];
    [self.bakeView addSubview:orderLabel];
    self.orderLabel = orderLabel;
    
    UILabel *orderNumLabel = [[UILabel alloc] init];
    [self.bakeView addSubview:orderNumLabel];
    self.orderNumLabel = orderNumLabel;
    
    
    UILabel *payStateLabel = [[UILabel alloc] init];
    [self.bakeView addSubview:payStateLabel];
    self.payStateLabel = payStateLabel;
    
    
    UILabel *ordersTimeLabel = [[UILabel alloc] init];
    [self addSubview:ordersTimeLabel];
    self.ordersTimeLabel = ordersTimeLabel;
    self.orderNumLabel.textAlignment = NSTextAlignmentRight;
    self.orderNumLabel.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf
    
    [self.bakeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@40);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.payStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.ordersTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bakeView.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@20);
    }];
    
    
}


- (void)setModel:(JMOrderNumTimeModel *)model {
    _model = model;
    
    self.orderNumLabel.text = model.orderNum;
    self.payStateLabel.text = model.orderState;
    self.ordersTimeLabel.text = model.orderTime;
    
}

@end




























