//
//  SingleOrderViewCell.m
//  XLMM
//
//  Created by younishijie on 15/11/11.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SingleOrderViewCell.h"
#import "UIColor+RGBColor.h"

@implementation SingleOrderViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SingleOrderViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.orderImageView.layer.masksToBounds = YES;
        self.orderImageView.layer.cornerRadius = 5;
        self.orderImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
        self.orderImageView.layer.borderWidth = 0.5;
        self.topHeight.constant = 0.5;
        self.midHeight.constant = 0.5;
        self.bottomHeight.constant = 0.5;
        
    }
    return self;
}

@end


































