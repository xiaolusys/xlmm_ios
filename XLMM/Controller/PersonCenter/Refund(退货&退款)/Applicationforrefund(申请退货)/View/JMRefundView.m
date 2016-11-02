//
//  JMRefundView.m
//  XLMM
//
//  Created by zhang on 16/6/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefundView.h"
#import "JMSelecterButton.h"

@interface JMRefundView ()

@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) JMSelecterButton *cancleBtn;

@end

@implementation JMRefundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
    //@"退货请求提交成功，客服会在24小时完成审核，您可以在退货界面查询进展，审核通过后您需要在退货界面填写退货快递单号，方便我们为你快速处理退款。";
}
+ (instancetype)defaultPopView {
    return [[JMRefundView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT)];
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
    self.titleLabel.backgroundColor = [UIColor lineGrayColor];

    JMSelecterButton *cancleBtn = [[JMSelecterButton alloc] init];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    self.cancleBtn.tag = 100;
    [self.cancleBtn setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"确定" TitleFont:13. CornerRadius:10];
    self.cancleBtn.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    kWeakSelf
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.baseView).offset(10);
        make.bottom.right.equalTo(weakSelf.baseView).offset(-10);
        make.width.mas_equalTo(@200);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@200);
        make.height.mas_equalTo(@40);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.baseView.mas_bottom).offset(20);
    }];
    
}
- (void)btnClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeRefundButton:didClick:)]) {
        [_delegate composeRefundButton:self didClick:button.tag];
    }
}

@end

















