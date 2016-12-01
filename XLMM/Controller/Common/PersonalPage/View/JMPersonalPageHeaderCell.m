//
//  JMPersonalPageHeaderCell.m
//  XLMM
//
//  Created by zhang on 16/11/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPersonalPageHeaderCell.h"

@interface JMPersonalPageHeaderCell ()


@property (nonatomic, strong) UIImageView *userIconImage;
@property (nonatomic, strong) UILabel *redCircle;
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *smallChangeLabel;
@property (nonatomic, strong) UILabel *integralLabel;
@property (nonatomic, strong) UILabel *couponLabel;




@end

@implementation JMPersonalPageHeaderCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    if (dict == nil) {
        self.userIconImage.image = nil;
        self.userNameLabel.text = @"未登录";
        self.integralLabel.text = @"0";
        self.couponLabel.text = @"0";
        self.smallChangeLabel.text = @"0.00";
        self.redCircle.hidden = YES;
        return ;
    }
    
    NSString *nickName = [dict objectForKey:@"nick"];
    [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"thumbnail"]]];
    if (nickName.length > 0 || [nickName class] != [NSNull null]) {
        self.userNameLabel.text = [dict objectForKey:@"nick"];
    }
    self.integralLabel.text = [[dict objectForKey:@"score"] stringValue];
    //判断是否为0
    if ([[dict objectForKey:@"user_budget"] isKindOfClass:[NSNull class]]) {
        self.smallChangeLabel.text  = [NSString stringWithFormat:@"0.00"];
    }else {
        NSDictionary *xiaolumeimei = [dict objectForKey:@"user_budget"];
        NSNumber *num = [xiaolumeimei objectForKey:@"budget_cash"];
        self.smallChangeLabel.text  = [NSString stringWithFormat:@"%.2f", [num floatValue]];
    }
    self.couponLabel.text = [NSString stringWithFormat:@"%@", dict[@"coupon_num"]];
    
    //应用打开时判断是否是小鹿妈妈
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    if ([[dict objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]) {
        [users setBool:YES forKey:@"isXLMM"];
    }else {
        [users setBool:NO forKey:@"isXLMM"];
    }
    [users synchronize];
    
    //判断是否绑定手机号或者设置密码
    NSString *mobile = [dict objectForKey:@"mobile"];
    if ([[dict objectForKey:@"has_password"] integerValue] == 0 ||  ([mobile class] == [NSNull null] || [mobile isEqualToString:@""])) {
        [self setRedCircleDisplay];
    }else {
        self.redCircle.hidden = YES;
    }
    
    
    
    
}
- (void)setRedCircleDisplay {
    self.redCircle.backgroundColor = [UIColor redColor];
    self.redCircle.layer.cornerRadius = 5;
    self.redCircle.layer.masksToBounds = YES;
    self.redCircle.hidden = NO;
}

- (void)setUpUI {
  
    CGFloat headerH = 180;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, headerH)];
    topImageView.image = [UIImage imageNamed:@"wodejingxuanback"];
    topImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:topImageView];
    
    UIButton *headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topImageView addSubview:headImageButton];
    headImageButton.tag = 100;
    [headImageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.userIconImage = [UIImageView new];
    self.userIconImage.backgroundColor = [UIColor whiteColor];
    self.userIconImage.layer.cornerRadius = 30;
    self.userIconImage.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
    self.userIconImage.layer.masksToBounds = YES;
    self.userIconImage.layer.borderWidth = 1;
    [headImageButton addSubview:self.userIconImage];
    
    self.redCircle = [UILabel new];
    [headImageButton addSubview:self.redCircle];
    self.redCircle.hidden = YES;
    
    self.userNameLabel = [UILabel new];
    self.userNameLabel.font = CS_SYSTEMFONT(12.);
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.text = @"未登录";
    [topImageView addSubview:self.userNameLabel];
    
    [headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView).offset(30);
        make.centerX.equalTo(topImageView.mas_centerX);
        make.width.height.mas_equalTo(@60);
    }];
    [self.userIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headImageButton);
        make.width.height.mas_equalTo(@60);
    }];
    [self.redCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImageButton.mas_centerX).offset(20);
        make.centerY.equalTo(headImageButton.mas_centerY).offset(-20);
        make.width.height.mas_equalTo(@10);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImageView.mas_centerX);
        make.top.equalTo(self.userIconImage.mas_bottom).offset(10);
    }];
    
    CGFloat headButtonSpace = 20 * HomeCategoryRatio;
    CGFloat buttonW = (SCREENWIDTH - headButtonSpace * 2) / 3;
    NSArray *imageArr = @[@"accounticon",@"pointicon",@"coupon"];
    NSArray *titleArr = @[@"零钱",@"积分",@"优惠券"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [topImageView addSubview:button];
        button.frame = CGRectMake(headButtonSpace + buttonW * i, headerH - 50, buttonW, 40);
        button.tag = 101 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *valueLabel = [UILabel new];
        [button addSubview:valueLabel];
        valueLabel.font = CS_SYSTEMFONT(16.);
        valueLabel.textColor = [UIColor buttonTitleColor];
        valueLabel.tag = 10 + i;
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button1 setTitle:titleArr[i] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:11.];
        [button addSubview:button1];
        

        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(button).offset(4);
        }];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(valueLabel.mas_bottom).offset(2);
        }];
        
    }
    
    self.smallChangeLabel = (UILabel *)[self.contentView viewWithTag:10];
    self.integralLabel = (UILabel *)[self.contentView viewWithTag:11];
    self.couponLabel = (UILabel *)[self.contentView viewWithTag:12];
    self.smallChangeLabel.text = @"0.00";
    self.integralLabel.text = @"0";
    self.couponLabel.text = @"0";
    

    
    
    
}
- (void)buttonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeActionView:Button:)]) {
        [_delegate composeActionView:self Button:button];
    }
    
    
}



@end








//        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:9.] forKey:NSFontAttributeName];
//        CGSize size = [titleArr[i] sizeWithAttributes:dic];















































