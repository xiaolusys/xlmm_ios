//
//  PublishNewPdtViewController.h
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPageViewBaseController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// 主页分类 比例布局
#define HomeCategoryRatio               SCREENWIDTH / 320.0
#define HomeCategorySpaceW              25 * HomeCategoryRatio
#define HomeCategorySpaceH              20 * HomeCategoryRatio

@interface PublishNewPdtViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *categoryCidString;
@property (nonatomic, strong)UICollectionView *picCollectionView;


@end

