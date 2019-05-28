//
//  JMRootgoodsCell.m
//  XLMM
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRootgoodsCell.h"
#import "CollectionModel.h"
#import "CollectionModel.h"
#import "JMRootGoodsModel.h"

@interface JMRootgoodsCell ()



@end


@implementation JMRootgoodsCell {
    NSString *_storeID;
}

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
//    self.iconImage.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:12.];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
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
    
    UIView *backView = [UIView new];
    [self.iconImage addSubview:backView];
    self.backView = backView;
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.7;
    self.backView.layer.cornerRadius = 30.;

    UILabel *backLabel = [UILabel new];
    [self.backView addSubview:backLabel];
    self.backLabel = backLabel;
    self.backLabel.textColor = [UIColor whiteColor];
    self.backLabel.font = [UIFont systemFontOfSize:13.];
    
    self.storeUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.storeUpButton];
    [self.storeUpButton addTarget:self action:@selector(cacleStoreUpClick:) forControlEvents:UIControlEventTouchUpInside];
    self.storeUpButton.hidden = YES;
    
    self.storeUpImage = [UIImageView new];
    [self.storeUpButton addSubview:self.storeUpImage];
    self.storeUpImage.image = [UIImage imageNamed:@"MyCollection_Selected"];
//    self.storeUpImage.userInteractionEnabled = YES;
    
}
- (void)layoutUI {
    kWeakSelf
    CGFloat imageW = (SCREENWIDTH - 15) / 2;
    CGFloat imageH = (SCREENWIDTH-15) * 2 / 3;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(imageH);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.mas_equalTo(imageW);
    }];
    
    [self.curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
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
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconImage.mas_centerX);
        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backView.mas_centerX);
        make.centerY.equalTo(weakSelf.backView.mas_centerY);
    }];
    
    [self.storeUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(@60);
    }];
    [self.storeUpImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@20);
        make.centerY.equalTo(weakSelf.storeUpButton.mas_centerY).offset(5);
        make.centerX.equalTo(weakSelf.storeUpButton.mas_centerX).offset(10);
    }];
    
}
- (void)fillDataWithCollectionModel:(CollectionModel *)model{
    NSString *picString = model.picPath;
//    NSMutableString *newString = [NSMutableString stringWithString:string];
    if ([NSString isStringEmpty:model.watermark_op]) {
        picString = [picString imageGoodsListCompression];
    } else{
        picString = [NSString stringWithFormat:@"%@|%@",[picString imageGoodsListCompression],model.watermark_op];
    }
    self.iconImage.alpha = 0.0;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[picString JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [UIView animateWithDuration:0.3f animations:^{
            self.iconImage.alpha = 1.0;
        }];
    }] ;

    self.titleLabel.text = model.name;
    
    
    if ([model.agentPrice integerValue] != [model.agentPrice floatValue]) {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    } else {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%@", model.agentPrice];
    }
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.stdSalePrice];
    self.backView.layer.cornerRadius = 30;
    
    if ([model.isSaleopen boolValue]) {
        
        if ([model.isSaleout boolValue]) {
            self.backView.hidden = NO;
        } else{
            self.backView.hidden = YES;
        }
    } else{
        self.backView.hidden = NO;
        //NSLog(@"isnew %d", [model.isNewgood boolValue]);
        if([model.isSaleout boolValue]){
            UILabel *label = [self.backView viewWithTag:100];
            label.text = @"即将开售";
        }
    }
}
- (void)fillDataWithGoodsList:(JMRootGoodsModel *)model{
    NSString *picString = model.head_img;
    
    if ([NSString isStringEmpty:model.watermark_op]) {
        picString = [picString imageGoodsListCompression];
    } else{
        picString = [NSString stringWithFormat:@"%@|%@",[picString imageGoodsListCompression],model.watermark_op];
    }
    NSMutableString *newImageUrl = [NSMutableString stringWithString:picString];
    if ([picString hasPrefix:@"http:"] || [picString hasPrefix:@"https:"]) {
    }else {
        [newImageUrl insertString:@"http:" atIndex:0];
    }
//    NSLog(@"name = %@ %@ %@ %@", model.name, model.isSaleopen, model.isSaleout , model.productModel);
    self.iconImage.alpha = 0.3;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[newImageUrl JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.iconImage.alpha = 1.0;
        }];
    }];

    self.titleLabel.text = model.name;
    
    if ([model.lowest_agent_price integerValue]!=[model.lowest_agent_price floatValue]) {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.lowest_agent_price floatValue]];
    } else {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.lowest_agent_price floatValue]];
    }

    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.lowest_std_sale_price floatValue]];
//    self.backView.layer.cornerRadius = 30;

    if ([model.sale_state isEqual:@"on"]) {
        if ([model.is_saleout boolValue]) {
            self.backView.hidden = NO;
            self.backLabel.text = @"已抢光";
        }else {
            self.backView.hidden = YES;
        }
    }else if ([model.sale_state isEqual:@"off"]) {
        self.backView.hidden = NO;
        self.backLabel.text = @"已下架";
    }else if ([model.sale_state isEqual:@"will"]) {
        self.backView.hidden = NO;
        self.backLabel.text = @"即将开售";
    }else {
    }

//    if ([model.sale_state boolValue]) {
//        if ([model.is_saleout boolValue]) {
//            self.backView.hidden = NO;
//            self.backLabel.text = @"已抢光";
//        }
//        else {
//            self.backView.hidden = YES;
//        }
//        
//    }else {
//        self.backView.hidden = NO;
//        //NSLog(@"isnew %d", [model.isNewgood boolValue]);
//        if([model.sale_state boolValue]){
//            self.backLabel.text = @"即将开售";
//        }
//    }
}

- (void)setItemDict:(NSDictionary *)itemDict {
    self.backView.hidden = YES;
    
    NSString *string = itemDict[@"head_img"];
    NSMutableString *newImageUrl = [NSMutableString stringWithString:string];
//    [newImageUrl appendString:@"?"];
    
    if ([string hasPrefix:@"http:"] || [string hasPrefix:@"https:"]) {
        
    }else {
        [newImageUrl insertString:@"http:" atIndex:0];
    }
    self.iconImage.alpha = 0.3;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.iconImage.alpha = 1.0;
        }];
    }];
    
    self.titleLabel.text = itemDict[@"name"];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [itemDict[@"lowest_agent_price"] floatValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[itemDict[@"lowest_std_sale_price"] floatValue]];
    _storeID = itemDict[@"id"];
    
    
}
- (void)cacleStoreUpClick:(UIButton *)button {
    if (self.block) {
        self.block(_storeID);
    }
}

@end





































