//
//  YHQCollectionCell.h
//  XLMM
//
//  Created by younishijie on 15/9/15.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHQModel;

@interface YHQCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myimageView;
@property (weak, nonatomic) IBOutlet UILabel *xianzhiLabel;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (void)fillCellWithYHQModel:(YHQModel *)yhqModel;

@end
