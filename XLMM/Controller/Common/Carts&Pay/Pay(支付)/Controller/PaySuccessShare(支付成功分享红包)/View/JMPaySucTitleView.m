//
//  JMPaySucTitleView.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPaySucTitleView.h"
#import "JMSelecterButton.h"

#define JMSUCTITLEPROPORTION 0.72

@interface JMPaySucTitleView ()

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UILabel *paysuccessLabel;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) JMSelecterButton *shareGetpack;


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
    
    JMSelecterButton *shareGetpack = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:shareGetpack];
    //    [shareGetpack setSureBackgroundColor:[UIColor buttonEnabledBackgroundColor] CornerRadius:20];
    [shareGetpack setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"查看订单" TitleFont:16. CornerRadius:20.];
    //    [shareGetpack setTitle:@"查看订单" forState:UIControlStateNormal];
    //    [shareGetpack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareGetpack = shareGetpack;
    [self.shareGetpack addTarget:self action:@selector(shareRedPackClick:) forControlEvents:UIControlEventTouchUpInside];
    
    kWeakSelf

    
    
    
//    UILabel *descLabel = [UILabel new];
//    [self addSubview:descLabel];
//    self.descLabel = descLabel;
//    self.descLabel.textColor = [UIColor buttonTitleColor];
//    self.descLabel.font = [UIFont systemFontOfSize:14.];
//    self.descLabel.text = @"您的订单已发至仓库，请等待发货";
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(40);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.height.mas_equalTo(@85);
    }];
    
    [self.paysuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImageView.mas_bottom).offset(35);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    [self.shareGetpack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(@40);
    }];
    
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.top.equalTo(weakSelf.paysuccessLabel.mas_bottom).offset(15);
//    }];
    
    
}

- (void)shareRedPackClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(composeGetRedpackBtn:didClick:)]) {
        [_delegate composeGetRedpackBtn:self didClick:sender];
    }
}




@end




























