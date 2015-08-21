//
//  XiangQingViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/21.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingdanModel;

@interface XiangQingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *xiangqingScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myViewHeight;

@property (weak, nonatomic) IBOutlet UIView *myXiangQingView;


@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jineLabel;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;

@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yingfuLabel;




@property (nonatomic, strong)DingdanModel *dingdanModel;





@end
