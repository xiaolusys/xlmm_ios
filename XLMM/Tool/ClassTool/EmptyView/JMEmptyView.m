//
//  JMEmptyView.m
//  XLMM
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEmptyView.h"
#import "JMSelecterButton.h"

#define FONT_SIZE 14.

@interface JMEmptyView ()

@property (nonatomic, strong) UIImageView *emptyImage;

@property (nonatomic, strong) JMSelecterButton *selectedButton;

@end

@implementation JMEmptyView



- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle BackImage:(NSString *)imageStr InfoStr:(NSString *)infoStr {
    if (self == [super initWithFrame:frame]) {
        
        CGFloat infoStringW = [self widthForString:infoStr fontSize:FONT_SIZE andHeight:0];
        CGFloat infoStringH = [self heightForString:infoStr fontSize:FONT_SIZE andWidth:0];
        
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
        [self.selectedButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:infoStr TitleFont:FONT_SIZE CornerRadius:infoStringH];
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
            make.width.mas_equalTo(@(infoStringW + 30));
            make.height.mas_equalTo(@(infoStringH * 2));
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



//获取字符串的宽度
- (CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height {
    
    
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]} context:nil].size;
//    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}
//获得字符串的高度
- (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]} context:nil].size;
    
//    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}









@end








































































