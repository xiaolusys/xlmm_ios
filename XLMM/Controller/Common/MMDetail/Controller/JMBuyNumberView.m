//
//  JMBuyNumberView.m
//  XLMM
//
//  Created by zhang on 16/8/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBuyNumberView.h"

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
//    [self.reduceButton setTitle:@"-" forState:UIControlStateNormal];
//    self.reduceButton.titleLabel.font = [UIFont systemFontOfSize:18.];
//    [self.reduceButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    [self addSubview:self.reduceButton];
    self.reduceButton.tag = 100;
    [self.reduceButton addTarget:self action:@selector(numOfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *reduceLabel = [UILabel new];
    [self.reduceButton addSubview:reduceLabel];
    reduceLabel.font = [UIFont systemFontOfSize:18.];
    reduceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    reduceLabel.text = @"－";
    reduceLabel.layer.masksToBounds = YES;
    reduceLabel.layer.borderWidth = 1.0;
    reduceLabel.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    reduceLabel.layer.cornerRadius = 10.;
    reduceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
//    self.addButton.titleLabel.font = [UIFont systemFontOfSize:18.];
//    [self.addButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
//    self.addButton.layer.masksToBounds = YES;
//    self.addButton.layer.borderWidth = 1.0;
//    self.addButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    [self addSubview:self.addButton];
    self.addButton.tag = 101;
    [self.addButton addTarget:self action:@selector(numOfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addLabel = [UILabel new];
    [self.addButton addSubview:addLabel];
    addLabel.font = [UIFont systemFontOfSize:18.];
    addLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    addLabel.text = @"＋";
    addLabel.layer.masksToBounds = YES;
    addLabel.layer.borderWidth = 1.0;
    addLabel.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    addLabel.layer.cornerRadius = 10.;
    addLabel.textAlignment = NSTextAlignmentCenter;
    
//    UIView *currentView = [UIView new];
//    [self addSubview:currentView];
//    currentView.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.mas_equalTo(@40);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.reduceButton.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numLabel.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.mas_equalTo(@40);
    }];
    
    [reduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.reduceButton.mas_centerY);
        make.right.equalTo(weakSelf.reduceButton);
        make.width.height.mas_equalTo(@20);
    }];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.left.equalTo(weakSelf.addButton);
        make.width.height.mas_equalTo(@20);
    }];

//    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(weakSelf);
//        make.bottom.equalTo(weakSelf).offset(-1);
//        make.height.mas_equalTo(@1);
//    }];
    
}



- (void)numOfButtonClick:(UIButton *)button {

    if (self.numblock) {
        self.numblock(button.tag);
    }

}




@end













































































