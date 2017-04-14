//
//  JMCartCurrentCell.m
//  XLMM
//
//  Created by zhang on 16/11/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCartCurrentCell.h"
#import "CartListModel.h"

NSString *const JMCartCurrentCellIdentifier = @"JMCartCurrentCellIdentifier";

@interface JMCartCurrentCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *jianButton;
@property (nonatomic, strong) UILabel *numberLabel;


@end


@implementation JMCartCurrentCell


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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartCurrentTapAction:)];
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
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *addImage = [UIImageView new];
    [self.addButton addSubview:addImage];
    addImage.image = CS_UIImageName(@"shopping_cart_add");
    
    self.jianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.jianButton];
    [self.jianButton addTarget:self action:@selector(jianGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *jianImage = [UIImageView new];
    [self.jianButton addSubview:jianImage];
    jianImage.image = CS_UIImageName(@"shopping_cart_jian");
    
    self.numberLabel = [UILabel new];
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.textColor = [UIColor settingBackgroundColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = CS_UIFontSize(18.);
    
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
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(3);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(@(40));
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.width.mas_equalTo(@(30));
        make.right.equalTo(weakSelf.addButton.mas_left);
    }];
    [self.jianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(40));
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.right.equalTo(weakSelf.numberLabel.mas_left);
    }];
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.left.equalTo(weakSelf.addButton);
        make.width.height.mas_equalTo(@(22));
    }];
    [jianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.addButton.mas_centerY);
        make.right.equalTo(weakSelf.jianButton);
        make.width.height.mas_equalTo(@(22));
    }];
    
}
- (void)setCartModel:(CartListModel *)cartModel {
    _cartModel = cartModel;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[cartModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.titleLabel.text = cartModel.title;
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [cartModel.price floatValue]];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", [cartModel.num integerValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [cartModel.std_sale_price floatValue]];
    self.sizeLabel.text = [NSString stringWithFormat:@"规格 :   %@",cartModel.sku_name];
}

- (void)cartCurrentTapAction:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(tapActionNumber:)]) {
        [_delegate tapActionNumber:self.cartModel];
    }
}

- (void)addGoodsClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNumber:)]) {
        [self.delegate addNumber:self.cartModel];
    }
}
- (void)jianGoodsClick:(UIButton *)button {
    NSInteger number = [self.cartModel.num integerValue];
    number --;
    if (number == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCart:)]) {
            [self.delegate deleteCart:self.cartModel];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jianNumber:)]) {
            [self.delegate jianNumber:self.cartModel];
        }
    }
}
























@end


























































































