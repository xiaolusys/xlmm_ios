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



- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle BackImage:(NSString *)imageStr InfoStr:(NSString *)infoStr {
    if (self == [super initWithFrame:frame]) {
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
        [self addSubview:image];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *label = [UILabel new];
        [self addSubview:label];
        UILabel *label1 = [UILabel new];
        [self addSubview:label1];
        
        label.text = title;
        label1.text = descTitle;
        
        label.font = [UIFont systemFontOfSize:16.];
        label.textColor = [UIColor buttonTitleColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        
        label1.font = [UIFont systemFontOfSize:14.];
        label1.textColor = [UIColor dingfanxiangqingColor];
        label1.numberOfLines = 0;
        label1.textAlignment = NSTextAlignmentCenter;
        
        
        self.selectedButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.selectedButton];
        self.selectedButton.tag = 100;
        [self.selectedButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:infoStr TitleFont:14. CornerRadius:15.];
        [self.selectedButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (infoStr.length == 0) {
            self.selectedButton.hidden = YES;
        }
        
        kWeakSelf
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.top.equalTo(weakSelf).offset(10);
            make.width.height.mas_equalTo(@120);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.mas_equalTo(@(SCREENWIDTH - 60));
        }];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.mas_equalTo(@(SCREENWIDTH - 60));
        }];
        
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(15);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.mas_equalTo(@90);
            make.height.mas_equalTo(@30);
        }];
        
    }
    return self;
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













































































