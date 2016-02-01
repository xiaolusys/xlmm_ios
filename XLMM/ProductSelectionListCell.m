//
//  ProductSelectionListCell.m
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ProductSelectionListCell.h"
#import "MaMaSelectProduct.h"
#import "UIImageView+WebCache.h"
#import "UIColor+RGBColor.h"
#import "NSString+URL.h"
#import "NSString+Encrypto.h"

@implementation ProductSelectionListCell

- (void)awakeFromNib {
    // Initialization code
//    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
//    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
}
 
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _addBtnClick.layer.cornerRadius = 15;
        _addBtnClick.layer.borderWidth = 0.5;
        _addBtnClick.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _addBtnClick.layer.cornerRadius = 15;
        _addBtnClick.layer.borderWidth = 0.5;
        _addBtnClick.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addPdtOrDeleteAction:(id)sender {
    if (self.delegate) {
        [self.delegate productSelectionListBtnClick:self btn:sender];
    }
}

//选品列表
- (void)fillCell:(MaMaSelectProduct *)product {
    self.pdtModel = product;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[product.pic_path URLEncodedString]]];
    self.productName.text = product.name;
    self.addBtnClick.layer.cornerRadius = 12;
    self.addBtnClick.layer.borderWidth = 0.5;
    self.addBtnClick.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    self.picImageView.layer.cornerRadius = 8;
    self.picImageView.layer.masksToBounds = YES;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.agent_price floatValue]];
    self.stdPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", [product.std_sale_price floatValue]];
    self.backPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.rebet_amount floatValue]];
    self.saleNumberLabel.text = [NSString stringWithFormat:@"%ld件", (long)[product.lock_num integerValue]];
    self.pdtID = [NSString stringWithFormat:@"%@", product.productId];
    if ([product.in_customer_shop intValue]) {
       self.addBtnClick.selected = YES;
        [self.addBtnClick setTitle:@"下架" forState:UIControlStateNormal];
//        [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
    }else {
        self.addBtnClick.selected = NO;
        [self.addBtnClick setTitle:@"上架" forState:UIControlStateNormal];
        
//        [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
    }
}

//我的精选
- (void)fillMyChoice:(MaMaSelectProduct *)product {
    self.pdtModel = product;
    self.productName.text = product.name;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[product.pic_path URLEncodedString]]];
    self.pdtID = [NSString stringWithFormat:@"%@", product.productId];
    self.addBtnClick.selected = YES;
    self.addBtnClick.layer.cornerRadius = 12;
    self.addBtnClick.layer.borderWidth = 0.5;
    self.addBtnClick.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [self.addBtnClick setTitle:@"下架" forState:UIControlStateNormal];
    self.picImageView.layer.cornerRadius = 8;
    self.picImageView.layer.masksToBounds = YES;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.agent_price floatValue]];
    self.stdPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", [product.std_sale_price floatValue]];
    self.backPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.rebet_amount floatValue]];
    self.saleNumberLabel.text = [NSString stringWithFormat:@"%ld件", (long)[product.lock_num integerValue]];
    
    //[self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
}

@end
