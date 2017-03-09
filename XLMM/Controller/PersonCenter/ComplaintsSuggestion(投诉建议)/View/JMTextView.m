//
//  JMTextView.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMTextView.h"

@interface JMTextView ()

@property (nonatomic,strong) UILabel *placeHolderLabel;

@end

@implementation JMTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentOffset= CGPointMake(0, 0);
        self.font = [UIFont systemFontOfSize:13.];
    }
    return self;
}

- (UILabel *)placeHolderLabel {
    if (_placeHolderLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        self.placeHolderLabel = label;
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.textColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    }
    return _placeHolderLabel;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolderLabel.font = font;
    [self.placeHolderLabel sizeToFit];
    
}

- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder {
    
    _hidePlaceHolder = hidePlaceHolder;
    
    
    self.placeHolderLabel.hidden = hidePlaceHolder;
    
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    
    self.placeHolderLabel.text = placeHolder;
    
    //label的尺寸跟文字一样
    [self.placeHolderLabel sizeToFit];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeHolderLabel.cs_x = 5;
    self.placeHolderLabel.cs_y = 8;
    
}



@end


