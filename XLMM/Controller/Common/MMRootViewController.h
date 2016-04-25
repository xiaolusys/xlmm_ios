//
//  MMRootViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLeftViewController.h"


@interface MMRootViewController : UIViewController <RootVCPushOtherVCDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollview;
@property (weak, nonatomic) IBOutlet UIView *aboveView;
@property (weak, nonatomic) IBOutlet UIView *brandView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *collectionViewScrollview;


@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewHeight;


- (IBAction)yestdayBtnClick:(id)sender;

- (IBAction)tomottowBtnClick:(id)sender;
- (IBAction)todayBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *womenImgView;
@property (weak, nonatomic) IBOutlet UIImageView *childImgView;

@end
