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


@interface PublishNewPdtViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>


//@property (nonatomic, assign) BOOL isPushingDays;
@property (nonatomic, copy) NSString *pushungDaysURL;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong)UICollectionView *picCollectionView;


@end

