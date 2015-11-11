//
//  QuanbuCollectionCell.h
//  XLMM
//
//  Created by younishijie on 15/8/21.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuanbuCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsView;

@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jineLabel;

@end
