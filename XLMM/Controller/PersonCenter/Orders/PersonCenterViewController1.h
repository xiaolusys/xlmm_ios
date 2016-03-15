//
//  PersonCenterViewController1.h
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMClass.h"

@interface PersonCenterViewController1 : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) id<MenuVCPushSideDelegate>menuDelegate;

@end
