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
    }
    
    return self;
}

- (void)fillDataWithCollectionModel:(CollectionModel *)model{
    [self.imageView sd_setImageWithURL:kLoansRRL(model.picPath)];
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    
    self.nameLabel.text = model.name;
    if ([model.agentPrice integerValue]<[model.agentPrice floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", [model.agentPrice floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.agentPrice];
    }
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.stdSalePrice];
    self.backView.layer.cornerRadius = 30;
    if ([model.isSaleout boolValue]) {
       
    } else{
        self.backView.hidden = YES;
        
    }
    if ([model.isSaleopen boolValue]) {
        self.backView.hidden = YES;
    } else{
        self.backView.hidden = NO;
    }
}

- (void)fillData:( PromoteModel*)model{
    [self.imageView sd_setImageWithURL:kLoansRRL(model.picPath) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //image = [UIImage grayscale:image];

    }] ;
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    
    
    
    
    self.nameLabel.text = model.name;
    
    if ([model.agentPrice integerValue]!=[model.agentPrice floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", [model.agentPrice floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.agentPrice];
    }
    
    
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.stdSalePrice];
    self.backView.layer.cornerRadius = 30;
    
    if ([model.isSaleopen boolValue]) {
        NSLog(@"已上架");
        if ([model.isSaleout boolValue]) {
            NSLog(@"已抢光\n\n");
        } else {
            NSLog(@"未抢光\n\n");
            self.backView.hidden = YES;
        }
    } else {
        self.backView.hidden = NO;
        NSLog(@"已下架\n\n");
        
    }
  
 
    
}

@end
