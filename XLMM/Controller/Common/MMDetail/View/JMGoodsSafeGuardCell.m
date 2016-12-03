//
//  JMGoodsSafeGuardCell.m
//  XLMM
//
//  Created by zhang on 16/8/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsSafeGuardCell.h"


NSString *const JMGoodsSafeGuardCellIdentifier = @"JMGoodsSafeGuardCellIdentifier";


@implementation JMGoodsSafeGuardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lineGrayColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {

    UIView *guaranteeView = [UIView new];
    [self.contentView addSubview:guaranteeView];
    guaranteeView.backgroundColor = [UIColor whiteColor];
    kWeakSelf
    
    [guaranteeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@90);
//        make.bottom.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    
    NSInteger count = 4;
    CGFloat accountH = 90;
    NSArray *accountArr = @[@"天天上新",@"100%正品",@"全国包邮",@"七天退货"];
    NSArray *imageArr = @[@"tiantian.png",@"zhengpin.png",@"quabguobaoyou.png",@"qitiantuihuo.png"];
    for (int i = 0; i < count; i++) {
        UIView *accountV = [UIView new];
        [guaranteeView addSubview:accountV];
        [accountV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(SCREENWIDTH));
//            make.left.right.equalTo(guaranteeView);
            make.height.mas_equalTo(@(accountH));
            make.centerY.equalTo(guaranteeView.mas_centerY);
            make.centerX.equalTo(guaranteeView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)count + 0));
        }];
        UIImageView *accountLabel = [UIImageView new];
        [accountV addSubview:accountLabel];
        accountLabel.image = [UIImage imageNamed:imageArr[i]];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(accountV.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(@32);
            make.centerX.equalTo(accountV.mas_centerX);
        }];
        UILabel *accountValueLabel = [UILabel new];
        [accountV addSubview:accountValueLabel];
        accountValueLabel.font = [UIFont boldSystemFontOfSize:14.];
        accountValueLabel.textColor = [UIColor buttonTitleColor];
        accountValueLabel.text = [NSString stringWithFormat:@"%@",accountArr[i]];
        [accountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountLabel.mas_bottom).offset(10);
            make.centerX.equalTo(accountV.mas_centerX);
        }];
        
    }
    
    
    
}

@end
