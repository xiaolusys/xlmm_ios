//
//  JMMaMaCenterFooterView.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaCenterFooterView.h"
#import "MMClass.h"
#import "Masonry.h"
#import "MJExtension.h"

@implementation JMMaMaCenterFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createMaMaCenterView];
    }
    return self;
}

+ (instancetype)enterFooterView {
    JMMaMaCenterFooterView *headView = [[JMMaMaCenterFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 430)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (void)createMaMaCenterView {
    
    UIView *oneSectionView = [UIView new];
    [self addSubview:oneSectionView];
    oneSectionView.backgroundColor = [UIColor lineGrayColor];
    
    UIButton *xlUniversityView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:xlUniversityView];
    xlUniversityView.tag = 100;
    [xlUniversityView addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *promptImage = [UIImageView new];
    [xlUniversityView addSubview:promptImage];
    promptImage.image = [UIImage imageNamed:@"messageImage"];
    
    UILabel *xlUniversityLabel = [UILabel new];
    [xlUniversityView addSubview:xlUniversityLabel];
    xlUniversityLabel.text = @"小鹿大学分享营销的科技殿堂";
    xlUniversityLabel.textColor = [UIColor buttonTitleColor];
    xlUniversityLabel.font = [UIFont systemFontOfSize:12.];
    
    UILabel *seeLabel = [UILabel new];
    [xlUniversityView addSubview:seeLabel];
    seeLabel.text = @"马上看看";
    seeLabel.textColor = [UIColor colorWithBlueColor];
    seeLabel.font = [UIFont systemFontOfSize:12.];
    
    UIView *twoSectionView = [UIView new];
    [self addSubview:twoSectionView];
    twoSectionView.backgroundColor = [UIColor lineGrayColor];
    
    UIView *thrSectionView = [UIView new];
    [self addSubview:thrSectionView];
    thrSectionView.backgroundColor = [UIColor lineGrayColor];
    
    UIView *forSectionView = [UIView new];
    [self addSubview:forSectionView];
    forSectionView.backgroundColor = [UIColor lineGrayColor];
    
    
    kWeakSelf
    
    [oneSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@15);
    }];
    [xlUniversityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(oneSectionView.mas_bottom);
        make.height.mas_equalTo(@40);
    }];
    [promptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xlUniversityView).offset(15);
        make.width.height.mas_equalTo(@18);
        make.centerY.equalTo(xlUniversityView.mas_centerY);
    }];
    [xlUniversityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptImage.mas_right).offset(10);
        make.centerY.equalTo(xlUniversityView.mas_centerY);
    }];
    [seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xlUniversityView).offset(-15);
        make.centerY.equalTo(xlUniversityView.mas_centerY);
    }];

    [twoSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(oneSectionView.mas_bottom).offset(40);
        make.height.mas_equalTo(@15);
    }];
    
    
    [thrSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(twoSectionView.mas_bottom).offset(65);
        make.height.mas_equalTo(@15);
    }];
    
    [forSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(thrSectionView.mas_bottom).offset(130);
        make.height.mas_equalTo(@15);
    }];
    
    
    CGFloat buttonW = SCREENWIDTH / 2;
    NSArray *imageArr = @[@"OrderListNormal",@"EarningsRecordNormal",@"SelectionNormal",@"EverydayPushNormal",@"inviteShopNormal",@"selectionShopNormal",@"xiaoluUniversityNormal",@"FansNormal",@"TeamNormal",@"VisitorRecordNormal"];
    NSArray *titleArr = @[@"订单记录",@"收益记录",@"我的精选",@"每日推送",@"邀请1元开店",@"选品上架",@"小鹿大学",@"我的粉丝",@"我的团队",@"访客记录"];
    NSArray *detailArr = @[@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123",@"哈哈123"];
    for (int i = 0; i < 10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor countLabelColor].CGColor;
        button.layer.borderWidth = 0.5;
        
        
        [self addSubview:button];
        if (i >= 0 && i < 2) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(twoSectionView.mas_bottom);
                make.left.equalTo(weakSelf).offset(i * buttonW);
                make.width.mas_equalTo(@(buttonW));
                make.height.mas_equalTo(@65);
            }];
        }else if (i >= 2 && i <= 5) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(twoSectionView.mas_bottom).offset(65 * ((i - 2) / 2) + 80);
                make.left.equalTo(weakSelf).offset((i % 2) * buttonW);
                make.width.mas_equalTo(@(buttonW));
                make.height.mas_equalTo(@65);
            }];
        }else if (i >= 6 && i <= 9) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(twoSectionView.mas_bottom).offset(65 * ((i - 6) / 2) + 225);
                make.left.equalTo(weakSelf).offset((i % 2) * buttonW);
                make.width.mas_equalTo(@(buttonW));
                make.height.mas_equalTo(@65);
            }];
        }
        
        button.tag = 101 + i;
        [button addTarget:self action:@selector(mamaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr[i]];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(15);
            make.width.height.mas_equalTo(@25);
            make.centerY.equalTo(button.mas_centerY);
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(10);
            make.left.equalTo(iconImage.mas_right).offset(20);
        }];
        
        UILabel *detailLabel = [UILabel new];
        [button addSubview:detailLabel];
        detailLabel.text = detailArr[i];
        detailLabel.font = [UIFont systemFontOfSize:12.];
        detailLabel.textColor = [UIColor dingfanxiangqingColor];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-10);
            make.left.equalTo(iconImage.mas_right).offset(20);
        }];
        
        
    }

}
- (void)mamaButtonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeMaMaCenterFooterView:Index:)]) {
        [_delegate composeMaMaCenterFooterView:self Index:button.tag];
    }
    
}

@end
































































