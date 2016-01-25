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
    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_add.png"]forState:UIControlStateNormal];
    [self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addPdtOrDeleteAction:(id)sender {
    if (self.delegate) {
        [self.delegate productSelectionListBtnClick:sender btn:sender];
    }
}

- (void)fillCell:(MaMaSelectProduct *)product {
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:product.head_img]];
    NSLog(@"%@", product.name);
    self.productName.text = product.name;
}

@end
