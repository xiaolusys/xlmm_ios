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
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.agentPrice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.stdSalePrice];
    self.backView.layer.cornerRadius = 40;
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
    
    
    //[self.imageView sd_setImageWithURL:kLoansRRL(model.picPath)];
    self.imageView.image = [UIImage imagewithURLString:model.picPath];
    
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.agentPrice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.stdSalePrice];
    self.backView.layer.cornerRadius = 40;
    if (![model.isSaleopen boolValue] || [model.isSaleout boolValue]) {
        
    } else{
        self.backView.hidden = YES;
        
    }
 
    
}

@end
