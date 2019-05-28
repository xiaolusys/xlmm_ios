//
//  JMEmptyGoodsView.m
//  XLMM
//
//  Created by zhang on 16/8/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEmptyGoodsView.h"
#import "JMSelecterButton.h"

@interface JMEmptyGoodsView ()

@property (nonatomic, strong) UIImageView *emptyImage;

@property (nonatomic, strong) JMSelecterButton *selectedButton;

@end

@implementation JMEmptyGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self initUI];
        
    }
    return self;
}
- (void)initUI {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyGoods"]];
    [self addSubview:image];
    
    UILabel *label = [UILabel new];
    [self addSubview:label];
    UILabel *label1 = [UILabel new];
    [self addSubview:label1];
    
    label.text = @"暂时没有商品哦~!";
    label1.text = @"去逛逛其他商品吧.....";
    
    label.font = [UIFont systemFontOfSize:16.];
    label.textColor = [UIColor buttonTitleColor];
    
    label1.font = [UIFont systemFontOfSize:14.];
    label1.textColor = [UIColor dingfanxiangqingColor];
    
    self.selectedButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.selectedButton];
    self.selectedButton.tag = 100;
    [self.selectedButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"去逛逛" TitleFont:14. CornerRadius:15.];
    [self.selectedButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    kWeakSelf
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(60);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(30);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@30);
    }];
    
    
}
- (void)buttonClick:(UIButton *)button {
    if (self.block) {
        self.block(button.tag);
    }
}




@end
