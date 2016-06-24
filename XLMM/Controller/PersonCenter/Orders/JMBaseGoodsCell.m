//
//  JMBaseGoodsCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBaseGoodsCell.h"
#import "MMClass.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@interface JMBaseGoodsCell ()

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

@property (nonatomic, strong) UILabel *numLabel;


@end

@implementation JMBaseGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self layoutUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:13.];
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont boldSystemFontOfSize:12.];
    self.PriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *sizeLabel = [UILabel new];
    [self.contentView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    self.sizeLabel.font = [UIFont boldSystemFontOfSize:12.];
    self.sizeLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *numLabel = [UILabel new];
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
    self.numLabel.font = [UIFont systemFontOfSize:12.];
    self.numLabel.textColor = [UIColor dingfanxiangqingColor];
    
    
}
- (void)layoutUI {
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@70);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.titleLabel);
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sizeLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.titleLabel);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.PriceLabel);
        make.left.equalTo(weakSelf.PriceLabel.mas_right).offset(10);
    }];
    
}
- (void)configWithModel:(JMOrderGoodsModel *)goodsModel {
    NSString *string = goodsModel.pic_path;

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[string imageCompression] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    
    self.titleLabel.text = goodsModel.title;
    self.sizeLabel.text = [NSString stringWithFormat:@"尺码:%@",goodsModel.status_display];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.payment];
    self.numLabel.text = [NSString stringWithFormat:@"x%@",goodsModel.num];
    
}

@end




























































