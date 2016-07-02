//
//  JMNORefundView.m
//  XLMM
//
//  Created by zhang on 16/6/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

//
//  JMRefundView.m
//  XLMM
//
//  Created by zhang on 16/6/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMNORefundView.h"
#import "UIColor+RGBColor.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMSelecterButton.h"

@interface JMNORefundView ()

@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) JMSelecterButton *cancleBtn;

@end

@implementation JMNORefundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}

+ (instancetype)defaultPopView {
    return [[JMNORefundView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 100 , (SCREENWIDTH - 160) + 60)];
}

- (void)createUI {
    
    UIView *baseView = [UIView new];
    [self addSubview:baseView];
    self.baseView = baseView;
    self.baseView.backgroundColor = [UIColor lineGrayColor];
    self.baseView.layer.cornerRadius = 10.0;
    self.baseView.layer.masksToBounds = YES;
    
    
    UILabel *titleLabel = [UILabel new];
    [self.baseView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:13.];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor dingfanxiangqingColor];
    self.titleLabel.text = @"您的订单已经向工厂订货，暂不支持退款，请您耐心等待，在收货确认签收后申请退货，如有疑问请咨询小鹿美美公众号或客服4008235355。";
    
    
    JMSelecterButton *cancleBtn = [[JMSelecterButton alloc] init];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    self.cancleBtn.tag = 100;
    [self.cancleBtn setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"确定" TitleFont:13. CornerRadius:10];
    self.cancleBtn.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat W = (self.frame.size.width - 100) - 20;
    
    kWeakSelf
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.bottom.equalTo(weakSelf).offset(-100);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.baseView.mas_centerX);
        make.centerY.equalTo(weakSelf.baseView.mas_centerY);
        make.width.mas_equalTo(W);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.baseView.mas_width);
        make.height.mas_equalTo(@40);
        make.centerX.equalTo(weakSelf.baseView.mas_centerX);
        make.top.equalTo(weakSelf.baseView.mas_bottom).offset(20);
    }];
    
}
- (void)btnClick:(JMSelecterButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeNoRefundButton:didClick:)]) {
        [_delegate composeNoRefundButton:self didClick:button.tag];
    }
}

@end



















