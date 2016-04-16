//
//  MMRootViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLeftViewController.h"


@interface MMRootViewController : UIViewController <RootVCPushOtherVCDelegate,UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *btnView;

- (IBAction)btnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


@property (weak, nonatomic) IBOutlet UIScrollView *backScrollview;
@property (weak, nonatomic) IBOutlet UIView *aboveView;
@property (weak, nonatomic) IBOutlet UIView *brandView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *collectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewHeight;


@end
