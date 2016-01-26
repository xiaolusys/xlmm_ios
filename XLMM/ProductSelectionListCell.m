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

@implementation ProductSelectionListCell

- (void)awakeFromNib {
    // Initialization code
//    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
//    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
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
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:product.head_img]];
    self.productName.text = product.name;
    
    self.pdtID = [NSString stringWithFormat:@"%@", product.productId];
    if ([product.in_customer_shop intValue]) {
        self.addBtnClick.selected = YES;
        [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
    }else {
        self.addBtnClick.selected = NO;
        [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
    }
}

//我的精选
- (void)fillMyChoice:(MaMaSelectProduct *)product {
    self.pdtModel = product;
    self.productName.text = product.name;
    self.pdtID = [NSString stringWithFormat:@"%@", product.productId];
    self.addBtnClick.selected = YES;
    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
}

@end
