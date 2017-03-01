//
//  JMReloadEmptyDataView.m
//  XLMM
//
//  Created by zhang on 17/2/27.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMReloadEmptyDataView.h"

@interface JMReloadEmptyDataView () {
    NSString *_buttonTitle;
}

@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UIButton *emptyButton;
@property (nonatomic, strong) UILabel *emptyTitleLabel;
@property (nonatomic, strong) UILabel *emptyDescTitleLabel;

@property (nonatomic, copy) ReloadClickBlock reloadClickBlock;

@end

@implementation JMReloadEmptyDataView

- (void)showInView:(UIView *)viewShow {
    [viewShow addSubview:self];
}
- (void)hideView {
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle ButtonTitle:(NSString *)buttonTitle Image:(NSString *)imageStr ReloadBlcok:(ReloadClickBlock)reloadBlock {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.reloadClickBlock = reloadBlock;
        _buttonTitle = buttonTitle;
        UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
        emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (![emptyImageView superview]) {
            [self addSubview:emptyImageView];
        }
        self.emptyImageView = emptyImageView;
        
        UILabel *emptyTitleLabel = [UILabel new];
        emptyTitleLabel.text = title;
        emptyTitleLabel.font = [UIFont systemFontOfSize:16.] ;
        emptyTitleLabel.textAlignment = NSTextAlignmentCenter ;
        emptyTitleLabel.numberOfLines = 0;
        emptyTitleLabel.textColor = [UIColor buttonTitleColor] ;
        if (![emptyTitleLabel superview]) {
            [self addSubview:emptyTitleLabel];
        }
        self.emptyTitleLabel = emptyTitleLabel;
        
        UILabel *emptyDescTitleLabel = [UILabel new];
        emptyDescTitleLabel.text = descTitle;
        emptyDescTitleLabel.font = [UIFont systemFontOfSize:14.];
        emptyDescTitleLabel.textAlignment = NSTextAlignmentCenter;
        emptyDescTitleLabel.numberOfLines = 0;
        emptyDescTitleLabel.textColor = [UIColor dingfanxiangqingColor];
        if (![emptyDescTitleLabel superview]) {
            [self addSubview:emptyDescTitleLabel];
        }
        self.emptyDescTitleLabel = emptyDescTitleLabel;
        
        if (![NSString isStringEmpty:buttonTitle]) {
            UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [emptyButton setTitle:buttonTitle forState:0] ;
            [emptyButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:0] ;
            emptyButton.titleLabel.font = [UIFont systemFontOfSize:14.] ;
            emptyButton.layer.cornerRadius = 5.0f ;
            emptyButton.layer.borderWidth = 1.0f ;
            emptyButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor ;
            [emptyButton addTarget:self action:@selector(reloadButtonClicked) forControlEvents:UIControlEventTouchUpInside] ;
            if (![emptyButton superview]) {
                [self addSubview:emptyButton] ;
            }
            self.emptyButton = emptyButton;
        }
        
        
        
        
        
    }
    return self;
}
- (void)reloadButtonClicked {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rectWifi = CGRectZero;
    rectWifi.size = CGSizeMake(120, 120);
    rectWifi.origin.x = (self.frame.size.width - 120) / 2.0;
    rectWifi.origin.y = (self.frame.size.height - 240) / 2.0;
    self.emptyImageView.frame = rectWifi;
    
    CGRect rectLabel = CGRectZero ;
    rectLabel.origin.x = 0.f;
    rectLabel.origin.y = self.emptyImageView.mj_max_Y + 10;
    rectLabel.size = CGSizeMake(SCREENWIDTH, 20);
    self.emptyTitleLabel.frame = rectLabel;
    self.emptyTitleLabel.mj_centerX = self.emptyImageView.mj_centerX;
    
    
    CGRect rectDescLabel = CGRectZero ;
    rectDescLabel.origin.x = 0.f;
    rectDescLabel.origin.y = self.emptyTitleLabel.mj_max_Y + 10;
    rectDescLabel.size = CGSizeMake(SCREENWIDTH, 20);
    self.emptyDescTitleLabel.frame = rectDescLabel;
    self.emptyDescTitleLabel.mj_centerX = self.emptyImageView.mj_centerX;
    
    CGFloat infoStringW = [self widthForString:_buttonTitle fontSize:14. andHeight:0];
    CGFloat infoStringH = [self heightForString:_buttonTitle fontSize:14. andWidth:0];
    
    if (self.emptyButton) {
        CGRect rectButton = CGRectZero ;
        rectButton.origin.x = (self.frame.size.width - infoStringW - 30) / 2.0;
        rectButton.origin.y = self.emptyDescTitleLabel.mj_max_Y + 10;
        rectButton.size = CGSizeMake(infoStringW + 30, infoStringH * 2) ;
        self.emptyButton.frame = rectButton ;
        self.emptyButton.mj_centerX = self.emptyImageView.mj_centerX;
    }
    

    
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




























































































