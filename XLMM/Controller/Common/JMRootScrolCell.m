//
//  JMRootScrolCell.m
//  XLMM
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRootScrolCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "BrandGoodsModel.h"
#import "ImageUtils.h"
#import "Masonry.h"
#import "MMClass.h"

@interface JMRootScrolCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *curreLabel;

@property (nonatomic, strong) UILabel *oldPriceLabel;

@property (nonatomic, strong) UILabel *deletLine;

@end

@implementation JMRootScrolCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self layoutUI];
    }
    return self;
}
- (void)createUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;

    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont boldSystemFontOfSize:14.];
    self.PriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *curreLabel = [UILabel new];
    [self.contentView addSubview:curreLabel];
    self.curreLabel = curreLabel;
    self.curreLabel.text = @"/";
    self.curreLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *oldPriceLabel = [UILabel new];
    [self.contentView addSubview:oldPriceLabel];
    self.oldPriceLabel = oldPriceLabel;
    self.oldPriceLabel.font = [UIFont systemFontOfSize:11.];
    self.oldPriceLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *deletLine = [UILabel new];
    [self.oldPriceLabel addSubview:deletLine];
    self.deletLine = deletLine;
    self.deletLine.backgroundColor = [UIColor titleDarkGrayColor];
}

- (void)layoutUI {
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(110);
    }];

    [self.curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(@13);
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.curreLabel.mas_left).offset(-2);
        make.centerY.equalTo(weakSelf.curreLabel.mas_centerY);
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.curreLabel.mas_right).offset(2);
        make.centerY.equalTo(weakSelf.curreLabel.mas_centerY);
    }];
    
    [self.deletLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.oldPriceLabel.mas_centerY);
        make.left.right.equalTo(weakSelf.oldPriceLabel);
        make.height.mas_equalTo(@1);
    }];
}

- (void)fillDataWithModel:(BrandGoodsModel *)model{
    
    [ImageUtils loadImage:self.iconImage url:model.product_img];
    
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.product_lowest_price floatValue]];
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.product_std_sale_price floatValue]];
    
}



@end





























