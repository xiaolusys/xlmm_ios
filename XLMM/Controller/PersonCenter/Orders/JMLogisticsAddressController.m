//
//  JMLogisticsAddressController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLogisticsAddressController.h"
#import "JMLogisticsAddressModel.h"
#import "MMClass.h"
#import "Masonry.h"

@interface JMLogisticsAddressController ()

@property (nonatomic,strong) UIView *editerAddView;

@property (nonatomic,strong) UIView *logisticsView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *logisticsLabel;

@property (nonatomic,strong) UILabel *recommendLabel;

@property (nonatomic,strong) UIImageView *rightImage;

@end

@implementation JMLogisticsAddressController

- (void)setLogAddModel:(JMLogisticsAddressModel *)logAddModel {
    _logAddModel = logAddModel;
    self.nameLabel.text = logAddModel.receiver_name;
    self.phoneLabel.text = logAddModel.receiver_phone;
//    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",]
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)createUI {
    
    UIView *editerAddView = [[UIView alloc] init];
    [self.view addSubview:editerAddView];
    self.editerAddView = editerAddView;
    self.editerAddView.backgroundColor = [UIColor orangeColor];
    UITapGestureRecognizer *editerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editerTapClick:)];
    [self.editerAddView addGestureRecognizer:editerTap];
    self.editerAddView.userInteractionEnabled = YES;
    
    
    UIView *logisticsView = [[UIView alloc] init];
    [self.view addSubview:logisticsView];
    self.logisticsView = logisticsView;
    self.logisticsView.backgroundColor = [UIColor orangeColor];
    UITapGestureRecognizer *logisticsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logisticsTapClick:)];
    [self.logisticsView addGestureRecognizer:logisticsTap];
    self.logisticsView.userInteractionEnabled = YES;
    
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    self.lineView = lineView;
    self.lineView.backgroundColor = [UIColor redColor];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    [self.editerAddView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.image = [UIImage imageNamed:@"address_icon"];
    
    //icon-jiantouyou
    UIImageView *rightImage = [[UIImageView alloc] init];
    [self.logisticsView addSubview:rightImage];
    self.rightImage = rightImage;
    self.rightImage.image = [UIImage imageNamed:@"icon-jiantouyou"];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.editerAddView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.backgroundColor = [UIColor redColor];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    [self.editerAddView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    self.phoneLabel.backgroundColor = [UIColor redColor];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [self.editerAddView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    self.addressLabel.backgroundColor = [UIColor redColor];
    
    UILabel *logisticsLabel = [[UILabel alloc] init];
    [self.logisticsView addSubview:logisticsLabel];
    self.logisticsLabel = logisticsLabel;
    self.logisticsLabel.backgroundColor = [UIColor redColor];
    
    UILabel *recommendLabel = [[UILabel alloc] init];
    [self.logisticsView addSubview:recommendLabel];
    self.recommendLabel = recommendLabel;
    self.recommendLabel.backgroundColor = [UIColor redColor];
    
    
}
#pragma mark ---- 点击这里进入地址修改界面
- (void)editerTapClick:(UITapGestureRecognizer *)tap {
    
}
#pragma mark ---- 点击这里进入物流选择界面
- (void)logisticsTapClick:(UITapGestureRecognizer *)tap {
    
}
- (void)prepareUI {
    kWeakSelf
    
    [self.editerAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    
    [self.logisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@30);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.view).offset(15);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.iconImage);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(15);
        make.height.mas_equalTo(@1);
    }];
    
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage);
        make.top.equalTo(weakSelf.lineView).offset(8);
    }];
    
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.logisticsLabel.mas_centerY);
        make.right.equalTo(weakSelf.rightImage.mas_left).offset(-10);
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.logisticsLabel.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(@19);
        make.width.mas_equalTo(@12);
    }];
    
}







@end
























































