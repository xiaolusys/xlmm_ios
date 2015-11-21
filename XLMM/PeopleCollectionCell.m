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
   
        self.headImageViewHeight.constant = (SCREENWIDTH - 15)/2*4/3;
        
    }
    

    
    
    return self;
}

- (void)fillDataWithCollectionModel:(CollectionModel *)model{

    NSString *string = [model.picPath URLEncodedString];
    NSLog(@"%@ image url string = %@",model.name, string);
    [self.imageView sd_setImageWithURL:kLoansRRL(string) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            float ratio = image.size.height/image.size.width;
            NSLog(@"%f", ratio);
            self.headImageViewHeight.constant = (SCREENWIDTH-15)/2*ratio;
            NSNumber *ratioNumber = [NSNumber numberWithFloat:ratio];
            NSLog(@"%@", ratioNumber);
            NSDictionary *info = @{@"ratio":ratioNumber};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"custemImageSize" object:self userInfo:info];
            
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
            NSLog(@"已抢光");
        } else{
            self.backView.hidden = YES;
            NSLog(@"未抢光");
        }
    } else{
        self.backView.hidden = NO;
        NSLog(@"已下架");
    }
}

- (void)fillData:( PromoteModel*)model{
    NSString *string = [model.picPath URLEncodedString];

    
    NSLog(@"%@ image url string = %@",model.name, string);
    [self.imageView sd_setImageWithURL:kLoansRRL(string) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            self.headImageViewHeight.constant = (SCREENWIDTH-15)/2*image.size.height/image.size.width;
           
        }


    }] ;

    
    
    
    
    self.nameLabel.text = model.name;
    
    if ([model.agentPrice integerValue]!=[model.agentPrice floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.agentPrice];
    }
    
    
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.stdSalePrice];
    self.backView.layer.cornerRadius = 30;
    
    if ([model.isSaleopen boolValue]) {
        NSLog(@"已上架");
        if (model.productModel == nil) {
            if ([model.isSaleout boolValue]) {
                NSLog(@"已抢光\n\n");
                
                self.backView.hidden = NO;
                
            } else {
                NSLog(@"未抢光\n\n");
                self.backView.hidden = YES;
            }

        } else {
            if ([model.isSaleout boolValue] && [[model.productModel objectForKey:@"is_single_spec"] boolValue]) {
                NSLog(@"已抢光\n\n");
                
                self.backView.hidden = NO;
                
            } else {
                NSLog(@"未抢光\n\n");
                self.backView.hidden = YES;
            }

        }
        
    } else {
        self.backView.hidden = NO;
        NSLog(@"已下架\n\n");
        
    }
  
 
    
}

@end
