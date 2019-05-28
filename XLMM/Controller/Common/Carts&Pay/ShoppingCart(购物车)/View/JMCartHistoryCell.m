//
//  JMCartHistoryCell.m
//  XLMM
//
//  Created by zhang on 16/11/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCartHistoryCell.h"
#import "JMSelecterButton.h"
#import "CartListModel.h"


NSString *const JMCartHistoryCellIdentifier = @"JMCartHistoryCellIdentifier";


@interface JMCartHistoryCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;


@property (nonatomic, strong) JMSelecterButton *addCartButton;


@end

@implementation JMCartHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartHistoryTapAction:)];
    [self.iconImage addGestureRecognizer:tap];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.textColor = [UIColor settingBackgroundColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.];
    self.titleLabel.numberOfLines = 2;
    
    UILabel *sizeLabel = [UILabel new];
    [self.contentView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    self.sizeLabel.font = [UIFont systemFontOfSize:13.];
    self.sizeLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont systemFontOfSize:16.];
    self.PriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *curreLabel = [UILabel new];
    [self.contentView addSubview:curreLabel];
    curreLabel.text = @"/";
    curreLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *oldPriceLabel = [UILabel new];
    [self.contentView addSubview:oldPriceLabel];
    self.oldPriceLabel = oldPriceLabel;
    self.oldPriceLabel.font = [UIFont systemFontOfSize:10.];
    self.oldPriceLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *deletLine = [UILabel new];
    [self.oldPriceLabel addSubview:deletLine];
    deletLine.backgroundColor = [UIColor titleDarkGrayColor];
    
    self.addCartButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.addCartButton];
    [self.addCartButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"加入购物车" TitleFont:12. CornerRadius:15];
    [self.addCartButton addTarget:self action:@selector(addCartClick:) forControlEvents:UIControlEventTouchUpInside];
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(7);
        make.width.height.mas_equalTo(@(94));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(12);
//        make.width.mas_equalTo(@(SCREENWIDTH - 120));
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
    }];
    [curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.left.equalTo(weakSelf.PriceLabel.mas_right);
        make.height.mas_equalTo(@13);
    }];
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(curreLabel.mas_right);
        make.centerY.equalTo(curreLabel.mas_centerY);
    }];
    [deletLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.oldPriceLabel.mas_centerY);
        make.left.right.equalTo(weakSelf.oldPriceLabel);
        make.height.mas_equalTo(@1);
    }];
    
    [self.addCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(@(90));
        make.height.mas_equalTo(@(30));
    }];
    
    
}

- (void)setCartModel:(CartListModel *)cartModel {
    _cartModel = cartModel;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[cartModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.titleLabel.text = cartModel.title;
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [cartModel.price floatValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [cartModel.std_sale_price floatValue]];
    self.sizeLabel.text = [NSString stringWithFormat:@"规格 :   %@",cartModel.sku_name];
}

- (void)cartHistoryTapAction:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(tapActionHistory:)]) {
        [_delegate tapActionHistory:self.cartModel];
    }
}

- (void)addCartClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addCart:)]) {
        [self.delegate addCart:self.cartModel];
    }
}









@end





































































