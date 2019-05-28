//
//  RefundDetailsViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/26.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class TuihuoModel;
@class JMRefundModel;
@interface RefundDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRefundHeight;

@property (nonatomic, strong) JMRefundModel *refundModelr;
@property (weak, nonatomic) IBOutlet UIButton *addressInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidth;

- (IBAction)addressInfoClicked:(id)sender;
- (IBAction)wuliuInfoClicked:(id)sender;

@property (nonatomic, copy) NSString *tuihuodizhi;
@property (weak, nonatomic) IBOutlet UIScrollView *timeLineView;
@property (weak, nonatomic) IBOutlet UIView *showRefundView;
@property (weak, nonatomic) IBOutlet UIView *showGoodsView;

@end
