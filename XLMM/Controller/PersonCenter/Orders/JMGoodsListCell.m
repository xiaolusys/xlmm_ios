//
//  JMGoodsListCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsListCell.h"
#import "UIColor+RGBColor.h"
#import "UIImageView+WebCache.h"
#import "MMClass.h"
#import "Masonry.h"
#import "JMOrderGoodsModel.h"

@interface JMGoodsListCell ()

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *goodsTitleL;

@property (nonatomic,strong) UILabel *goodsSizeL;

@property (nonatomic,strong) UILabel *goodsColorL;

@property (nonatomic,strong) UILabel *goodsMoneyL;

@property (nonatomic,strong) UILabel *goodsNumL;

@end

@implementation JMGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    return self;

}
- (void)initUI {
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *goodsTitleL = [UILabel new];
    [self.contentView addSubview:goodsTitleL];
    self.goodsTitleL = goodsTitleL;
    
    UILabel *goodsSizeL = [UILabel new];
    [self.contentView addSubview:goodsSizeL];
    self.goodsSizeL = goodsSizeL;
    self.goodsSizeL.textColor = [UIColor titleDarkGrayColor];
    self.goodsSizeL.font = [UIFont systemFontOfSize:11.];
    
    UILabel *goodsColorL = [UILabel new];
    [self.contentView addSubview:goodsColorL];
    self.goodsColorL = goodsColorL;
    self.goodsColorL.textColor = [UIColor titleDarkGrayColor];
    self.goodsColorL.font = [UIFont systemFontOfSize:11.];
    
    UILabel *goodsMoneyL = [UILabel new];
    [self.contentView addSubview:goodsMoneyL];
    self.goodsMoneyL = goodsMoneyL;
    self.goodsMoneyL.textAlignment = NSTextAlignmentRight;
    
    UILabel *goodsNumL = [UILabel new];
    [self.contentView addSubview:goodsNumL];
    self.goodsNumL = goodsNumL;
    
    kWeakSelf
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.goodsTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 120);
    }];
    
    [self.goodsMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.centerY.equalTo(weakSelf.goodsTitleL.mas_centerY);
    }];
    
    [self.goodsSizeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
    }];
    
    [self.goodsColorL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsSizeL.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.goodsSizeL.mas_centerY);
    }];
    
    [self.goodsNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.goodsMoneyL);
        make.centerY.equalTo(weakSelf.goodsSizeL.mas_centerY);
    }];
    
}
- (void)configData:(JMOrderGoodsModel *)model {
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_path] placeholderImage:[UIImage imageNamed:@"profiles"]];
    
    self.goodsMoneyL.text = [NSString stringWithFormat:@"¥ %@",model.payment];
    self.goodsTitleL.text = model.title;
    self.goodsSizeL.text = [NSString stringWithFormat:@"尺寸: %@",model.sku_name];
    self.goodsColorL.text = [NSString stringWithFormat:@"颜色: %@",model.num]; // 颜色没有啊
    self.goodsNumL.text = [NSString stringWithFormat:@"x %@",model.num];
    
    
    
}


@end













