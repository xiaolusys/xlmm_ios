//
//  PersonCenterViewController3.h
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuanbuCollectionCell.h"
@interface PersonCenterViewController3 : UIViewController <UICollectionViewDataSource,
    UIBarPositioningDelegate,
    UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *quanbuCollectionView;

@end
