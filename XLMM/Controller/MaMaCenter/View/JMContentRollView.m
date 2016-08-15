//
//  JMRollView.m
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMContentRollView.h"
#import "MMClass.h"

@interface JMContentRollView ()

@property (strong, nonatomic) UILabel *titleLabel;



@end

@implementation JMContentRollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    UIView *baseView = [UIView new];
    [self addSubview:baseView];
    baseView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [baseView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:13.];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.numberOfLines = 0;
    self.titleLabel= titleLabel;
    
    UILabel *seeLabel = [UILabel new];
    seeLabel.font = [UIFont systemFontOfSize:13];
    seeLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    seeLabel.text = @"马上查看";
    [baseView addSubview:seeLabel];
    self.seeLabel = seeLabel;
    
    kWeakSelf
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf);
    }];
    
    [seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(baseView);
        make.centerY.equalTo(baseView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baseView.mas_centerY);
        make.left.equalTo(baseView);
        make.right.equalTo(baseView).offset(-60);
        make.height.mas_equalTo(@40);
    }];
    
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
