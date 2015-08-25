//
//  AddressView.m
//  XLMM
//
//  Created by younishijie on 15/8/22.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddressView.h"

@implementation AddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (IBAction)selectClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"selectbutton.tag = %ld", (long)button.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAddress:)]) {
      //  NSLog(@"选择了改地址");
        [self.delegate selectAddress:self];
        
    }
    
}

- (IBAction)modifyClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyAddress:)]) {
       // NSLog(@"修改地址");
        [self.delegate modifyAddress:self];

    }
    NSLog(@"modifybutton.tag = %ld", (long)button.tag);
    
    
    
}
@end
