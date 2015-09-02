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
    if (!model.isSaleout) {
        NSLog(@"isSaleOut : %@", model.isSaleout);
        self.backView.hidden = YES;
    } else{
        NSLog(@"isSaleOut : %@", model.isSaleout);
        self.backView.hidden = NO;
        
    }
}

- (void)fillData:(PeopleModel *)model{
    [self.imageView sd_setImageWithURL:kLoansRRL(model.imageURL)];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.oldPrice];
    self.backView.layer.cornerRadius = 40;
    if (!model.isSaleOut) {
        NSLog(@"%d", model.isSaleOut);
        self.backView.hidden = YES;
    } else{
        NSLog(@"%d", model.isSaleOut);
        self.backView.hidden = NO;
 
    }
}

@end
