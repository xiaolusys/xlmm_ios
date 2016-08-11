//
//  JMBuyNumberView.m
//  XLMM
//
//  Created by zhang on 16/8/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBuyNumberView.h"
#import "MMClass.h"

@implementation JMBuyNumberView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self initUI];
        
    }
    return self;
}



- (void)initUI {
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16.];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.text = @"个数";
    [self addSubview:titleLabel];
    
    self.numLabel = [UILabel new];
    self.numLabel.font = [UIFont systemFontOfSize:16.];
    self.numLabel.textColor = [UIColor buttonTitleColor];
    self.numLabel.text = @"1";
    [self addSubview:self.numLabel];
    
    self.reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reduceButton setTitle:@"-" forState:UIControlStateNormal];
    self.reduceButton.titleLabel.font = [UIFont systemFontOfSize:18.];
    [self.reduceButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    self.reduceButton.layer.masksToBounds = YES;
    self.reduceButton.layer.borderWidth = 1.0;
    self.reduceButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    [self addSubview:self.reduceButton];
    self.reduceButton.tag = 100;
    [self.reduceButton addTarget:self action:@selector(numOfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:18.];
    [self.addButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.borderWidth = 1.0;
    self.addButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    [self addSubview:self.addButton];
    self.addButton.tag = 101;
    [self.addButton addTarget:self action:@selector(numOfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    kWeakSelf
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(80);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.reduceButton.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    
    
}



- (void)numOfButtonClick:(UIButton *)button {

    if (self.numblock) {
        self.numblock(button.tag);
    }

}




@end













































































