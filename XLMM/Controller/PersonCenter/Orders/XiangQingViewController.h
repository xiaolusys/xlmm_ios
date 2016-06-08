//
//  XiangQingViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/21.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingdanModel;


//   http://192.168.1.31:9000/rest/v1/trades/301/details
//  http://192.168.1.31:9000/rest/v1/trades/217/details




@interface XiangQingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *xiangqingScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenWidth;
/**
 *  增加点击修改地址事件
 */
@property (weak, nonatomic) IBOutlet UIImageView *addressInfoImage;

@property (weak, nonatomic) IBOutlet UIView *myXiangQingView;

@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yingfuLabel;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

- (IBAction)quxiaodingdan:(id)sender;
- (IBAction)goumai:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong)DingdanModel *dingdanModel;
@property (nonatomic, copy) NSString *createString;
@property (weak, nonatomic) IBOutlet UILabel *headdingdanzhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

/**
 *  显示创建订单时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimerLabel;
/**
 *  计算商品详情展示视图的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;
/**
 *  选择物流公司
 */
@property (weak, nonatomic) IBOutlet UILabel *logisticsLabel;
/**
 *  点击修改物流公司
 */
@property (weak, nonatomic) IBOutlet UIView *choiseLogisticsView;


@end



























