//
//  JMMaMaMessageCell.m
//  XLMM
//
//  Created by zhang on 16/9/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaMessageCell.h"

@interface JMMaMaMessageCell ()

@property (nonatomic, strong) UILabel *seeLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation JMMaMaMessageCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:13.];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.numberOfLines = 0;
    self.titleLabel= titleLabel;
    
    UILabel *seeLabel = [UILabel new];
    seeLabel.font = [UIFont systemFontOfSize:13];
    seeLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    seeLabel.text = @"马上查看";
    [self addSubview:seeLabel];
    self.seeLabel = seeLabel;
    kWeakSelf
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf);
        //        make.right.equalTo(baseView).offset(-60);
        make.width.mas_equalTo(@(SCREENWIDTH - 110));
        //        make.height.mas_equalTo(@40);
    }];
    
    
    [seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-5);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}


- (void)setMessageString:(NSString *)messageString {
    _messageString = messageString;
//    NSLog(@"%@",messageString);
    self.titleLabel.text = messageString;
}



@end
