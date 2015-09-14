//
//  MMCartsView.m
//  XLMM
//
//  Created by younishijie on 15/9/14.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMCartsView.h"

@implementation MMCartsView

static MMCartsView* _cartsView = nil;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)sharedCartsView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cartsView = [[self alloc] init];
    });
    return _cartsView;
    
}

- (id)init{
    if (self = [super init]) {
        [[NSBundle mainBundle] loadNibNamed:@"MMCartsView" owner:self options:nil];
        
        self.cartsView.layer.cornerRadius = 25;
        self.myLabelView.layer.cornerRadius = 10;
        self.myNumberView.text = @"0";
        
        
    }
    return self;
    
}

@end
