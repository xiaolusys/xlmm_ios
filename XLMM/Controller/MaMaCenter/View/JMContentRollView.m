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
    
    kWeakSelf
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baseView.mas_centerY);
        make.left.right.equalTo(baseView);
        make.height.mas_equalTo(@40);
    }];
    
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
