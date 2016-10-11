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

@interface PublishNewPdtViewController : JMPageViewBaseController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *qrCodeUrlString;

@end
