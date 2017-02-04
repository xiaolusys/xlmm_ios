//
//  JMPaySucTitleView.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPaySucTitleView.h"

#define JMSUCTITLEPROPORTION 0.72

@interface JMPaySucTitleView ()

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UILabel *paysuccessLabel;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JMPaySucTitleView

+ (instancetype)enterHeaderView {
    JMPaySucTitleView *headView = [[JMPaySucTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTopUI];
    }
    return self;
}

- (void)setUpTopUI {
    UIImageView *topImageView = [UIImageView new];
    [self addSubview:topImageView];
    self.topImageView = topImageView;
    self.topImageView.image = [UIImage imageNamed:@"pay_successTopIcon"];
    
    UILabel *paysuccessLabel = [UILabel new];
    [self addSubview:paysuccessLabel];
    self.paysuccessLabel = paysuccessLabel;
    self.paysuccessLabel.font = [UIFont boldSystemFontOfSize:32.];
    self.paysuccessLabel.text = @"支付成功!";
    
//    UILabel *descLabel = [UILabel new];
//    [self addSubview:descLabel];
//    self.descLabel = descLabel;
//    self.descLabel.textColor = [UIColor buttonTitleColor];
//    self.descLabel.font = [UIFont systemFontOfSize:14.];
//    self.descLabel.text = @"您的订单已发至仓库，请等待发货";
    
    kWeakSelf
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(40);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.height.mas_equalTo(@85);
    }];
    
    [self.paysuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImageView.mas_bottom).offset(35);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.top.equalTo(weakSelf.paysuccessLabel.mas_bottom).offset(15);
//    }];
    
    
}



@end




























