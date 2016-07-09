//
//  JMSelecterButton.m
//  XLMM
//
//  Created by zhang on 16/5/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"

@class JMSelecterButton;


@implementation JMSelecterButton


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        
        
        
    }
    return self;
}





- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self.layer setBorderColor:[UIColor buttonEmptyBorderColor].CGColor];
        [self setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateSelected];
    }else {
        [self.layer setBorderColor:[UIColor buttonDisabledBorderColor].CGColor];
        [self setTitleColor:[UIColor buttonDisabledBackgroundColor] forState:UIControlStateNormal];
    }
    
    
}

//- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
//
//    [super setTitleColor:color forState:state];
//    [self setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateSelected];
//    [self setTitleColor:[UIColor buttonDisabledBackgroundColor] forState:UIControlStateNormal];
//
//}

//- (void)setTitle:(NSString *)title forState:(UIControlState)state {
//    [super setTitle:title forState:state];
//
//    [self sizeToFit];
//}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}

- (void)setSelecterBorderColor:(UIColor *)color TitleColor:(UIColor *)tcolor Title:(NSString *)title TitleFont:(NSInteger)font CornerRadius:(NSInteger)corner {
    
    
    [self.layer setBorderColor:color.CGColor];
    [self setTitleColor:tcolor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:corner];
    [self.layer setBorderWidth:1.0];
    [self setTitle:title forState:UIControlStateNormal];
    
    
    
}

- (void)setNomalBorderColor:(UIColor *)color TitleColor:(UIColor *)tcolor Title:(NSString *)title TitleFont:(NSInteger)font CornerRadius:(NSInteger)corner {
    
    [self.layer setBorderColor:color.CGColor];
    [self setTitleColor:tcolor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:corner];
    [self.layer setBorderWidth:1.0];
    [self setTitle:title forState:UIControlStateNormal];
    
    
}

- (void)setSureBackgroundColor:(UIColor *)color CornerRadius:(NSInteger)corner {
    [self.layer setBackgroundColor:color.CGColor];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:corner];
    
}

//- (void)setBackgrdColor:(UIColor *)backgrdColor layerRead:(CGFloat)layerRead;

@end














