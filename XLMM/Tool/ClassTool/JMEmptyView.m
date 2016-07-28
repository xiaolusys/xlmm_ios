//
//  JMEmptyView.m
//  XLMM
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEmptyView.h"

@interface JMEmptyView ()

@property (nonatomic, strong) UIImageView *emptyImage;

@end

@implementation JMEmptyView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        
        
    }
    return self;
}

- (void)initUI {
    self.emptyImage = [UIImageView new];
    
    
}




- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
}









@end
