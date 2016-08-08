//
//  JMEmptyView.m
//  XLMM
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEmptyView.h"
#import "MMClass.h"
#import "JMSelecterButton.h"

@interface JMEmptyView ()

@property (nonatomic, strong) UIImageView *emptyImage;

@property (nonatomic, strong) JMSelecterButton *selectedButton;

@end

@implementation JMEmptyView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self initUI];
        
    }
    return self;
}
- (void)initUI {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyStoreUp"]];
    [self addSubview:image];
    
    UILabel *label = [UILabel new];
    [self addSubview:label];
    UILabel *label1 = [UILabel new];
    [self addSubview:label1];
    
    label.text = @"您还没有收藏的商品哦....";
    label1.text = @"赶紧把你喜欢的商品加入收藏吧~";
    
    label.font = [UIFont systemFontOfSize:16.];
    label.textColor = [UIColor buttonTitleColor];
    
    label1.font = [UIFont systemFontOfSize:14.];
    label1.textColor = [UIColor dingfanxiangqingColor];
    
    self.selectedButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.selectedButton];
    self.selectedButton.tag = 100;
    [self.selectedButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"快去抢购" TitleFont:14. CornerRadius:15.];
    [self.selectedButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    kWeakSelf
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-200);
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

- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    
    
}









@end













































































