//
//  PeopleCollectionCell.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PeopleCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "MMClass.h"
#import "CollectionModel.h"
#import "UIImage+ChangeGray.h"
#import "NSString+URL.h"
#import "SVProgressHUD.h"



@implementation PeopleCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PeopleCollectionCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
     
        self = [arrayOfViews objectAtIndex:0];
//        [SVProgressHUD show];
   
        self.headImageViewHeight.constant = (SCREENWIDTH - 15)/2*4/3;
    }
    return self;
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

    self.imageView.alpha = 0.0;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newString imageCompression] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.alpha = 1.0;
        }];
        if (image != nil) {
            //自适应图片高度 ,图片宽度固定高度自适应。。。。。
            self.headImageViewHeight.constant = (SCREENWIDTH-15)/2*image.size.height/image.size.width;
        }
        
    }] ;
    
    

    
    self.nameLabel.text = model.name;

    
    if ([model.agentPrice integerValue] != [model.agentPrice floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.agentPrice];
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
    }
}

- (void)fillData:( PromoteModel*)model{
    NSString *string = model.picPath;
    
    NSMutableString *newImageUrl = [NSMutableString stringWithString:string];
    if (![model.watermark_op isEqualToString:@""]) {
        [newImageUrl appendString:[NSString stringWithFormat:@"?%@|", model.watermark_op]];
        
    } else{
        [newImageUrl appendString:@"?"];
    }
    
    
   //NSLog(@"newImageLink = %@", [newImageUrl imageCompression]);
    
    
    self.imageView.alpha = 0.0;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageCompression] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.alpha = 1.0;
        }];
        
        if (image != nil) {
            //自适应图片高度 ,图片宽度固定高度自适应。。。。。
            self.headImageViewHeight.constant = (SCREENWIDTH-15)/2*image.size.height/image.size.width;
//            [SVProgressHUD dismiss];
        }
    }];
    

    self.nameLabel.text = model.name;
    
    if ([model.agentPrice integerValue]!=[model.agentPrice floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    }
    
    
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.stdSalePrice floatValue]];
    self.backView.layer.cornerRadius = 30;
    
    if ([model.isSaleopen boolValue]) {
        if (model.productModel == nil) {
            if ([model.isSaleout boolValue]) {
                
                self.backView.hidden = NO;
                
            } else {
                self.backView.hidden = YES;
            }

        } else {
            if ([model.isSaleout boolValue] && [[model.productModel objectForKey:@"is_single_spec"] boolValue]) {
                
                self.backView.hidden = NO;
                
            } else {
                self.backView.hidden = YES;
            }

        }
        
    } else {
        self.backView.hidden = NO;
    }
}

@end
