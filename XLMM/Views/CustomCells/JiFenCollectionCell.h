//
//  JiFenCollectionCell.h
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JiFenModel;
@interface JiFenCollectionCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;

- (void)fillCellWithData:(JiFenModel *)model;


@end
