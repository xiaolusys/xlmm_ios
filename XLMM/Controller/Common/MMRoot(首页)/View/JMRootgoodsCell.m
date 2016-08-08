//
//  JMRootgoodsCell.m
//  XLMM
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRootgoodsCell.h"
#import "MMClass.h"
#import "CollectionModel.h"
#import "UIImage+ChangeGray.h"
#import "PromoteModel.h"
#import "CollectionModel.h"
#import "JMStoreUpModel.h"

@interface JMRootgoodsCell ()



@end


@implementation JMRootgoodsCell

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


    UILabel *backLabel = [UILabel new];
    [self.backView addSubview:backLabel];
    self.backLabel = backLabel;
    self.backLabel.textColor = [UIColor whiteColor];
    self.backLabel.font = [UIFont systemFontOfSize:13.];
    
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
    
}
- (void)fillDataWithCollectionModel:(CollectionModel *)model{
    
    NSString *string = model.picPath;
    
    NSMutableString *newString = [NSMutableString stringWithString:string];
    if (![model.watermark_op isEqualToString:@""]) {
        [newString appendString:[NSString stringWithFormat:@"?%@|", model.watermark_op]];
        
    } else{
        [newString appendString:@"?"];
    }
    
    
    NSLog(@"newString = %@", [newString imageCompression]);
    
    self.iconImage.alpha = 0.0;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newString imageCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
        if([model.isNewgood boolValue]){
            UILabel *label = [self.backView viewWithTag:100];
            label.text = @"即将开售";
        }
    }
}
- (void)fillData:(PromoteModel*)model{
    NSString *string = model.picPath;
    
    NSMutableString *newImageUrl = [NSMutableString stringWithString:string];
    if (![model.watermark_op isEqualToString:@""]) {
        [newImageUrl appendString:[NSString stringWithFormat:@"?%@|", model.watermark_op]];
        
    } else{
        [newImageUrl appendString:@"?"];
    }
    
    
//    NSLog(@"name = %@ %@ %@ %@", model.name, model.isSaleopen, model.isSaleout , model.productModel);
    
    
    self.iconImage.alpha = 0.3;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.iconImage.alpha = 1.0;
        }];
    }];
    
    
    self.titleLabel.text = model.name;
    
    if ([model.agentPrice integerValue]!=[model.agentPrice floatValue]) {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    } else {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    }

    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.stdSalePrice floatValue]];
    self.backView.layer.cornerRadius = 30;
    
    if ([model.isSaleopen boolValue]) {
        if ([model.isSaleout boolValue]) {
            self.backView.hidden = NO;
            self.backLabel.text = @"已抢光";
        }
        else {
            self.backView.hidden = YES;
        }
        
    }else {
        self.backView.hidden = NO;
        //NSLog(@"isnew %d", [model.isNewgood boolValue]);
        if([model.isNewgood boolValue]){
            self.backLabel.text = @"即将开售";
        }
    }
}

- (void)fillStoreUpData:(JMStoreUpModel *)model {
    self.backView.hidden = YES;
    
    NSDictionary *dic = model.modelproduct;
    
    NSString *string = dic[@"head_img"];
    
    NSMutableString *newImageUrl = [NSMutableString stringWithString:string];
    [newImageUrl appendString:@"?"];
    
    
    self.iconImage.alpha = 0.3;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.iconImage.alpha = 1.0;
        }];
    }];
    
    self.titleLabel.text = dic[@"name"];
    
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [dic[@"lowest_agent_price"] floatValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[dic[@"lowest_std_sale_price"] floatValue]];
    
    
    
}

@end





































