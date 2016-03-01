//
//  ProductSelectionListCell2.m
//  XLMM
//
//  Created by younishijie on 16/3/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "ProductSelectionListCell2.h"
#import "MaMaSelectProduct.h"
#import "NSString+URL.h"
#import "UIColor+RGBColor.h"
#import "UIImageView+WebCache.h"

@implementation ProductSelectionListCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)xiajiaClicked:(id)sender {
    
    if (self.delegate) {
        [self.delegate productSelectionListBtnClick:self btn:sender];
    }
    
}

- (IBAction)shareClicked:(id)sender {
    if (self.delegate) {
        [self.delegate productSelectionShareClick:self btn:sender];
    }
    
}

//我的精选
- (void)fillMyChoice:(MaMaSelectProduct *)product {
    self.pdtModel = product;
    self.productName.text = product.name;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[[product.pic_path imageShareCompression] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.pdtID = [NSString stringWithFormat:@"%@", product.productId];
    self.addBtnClick.selected = YES;
    self.addBtnClick.layer.cornerRadius = 15;
    self.addBtnClick.layer.borderWidth = 0.5;
    self.addBtnClick.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
//    [self.addBtnClick setTitle:@"下架" forState:UIControlStateNormal];
    
    self.shareBtn.layer.cornerRadius = 15;
    self.shareBtn.layer.borderWidth = 0.5;
    self.shareBtn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    self.picImageView.layer.cornerRadius = 8;
    self.picImageView.layer.masksToBounds = YES;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.agent_price floatValue]];
    self.stdPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", [product.std_sale_price floatValue]];
    self.backPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.rebet_amount floatValue]];
    self.saleNumberLabel.text = [NSString stringWithFormat:@"%ld件", (long)[product.sale_num integerValue]];
    
    //[self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
}
@end
