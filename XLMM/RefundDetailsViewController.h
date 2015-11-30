//
//  RefundDetailsViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/26.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TuihuoModel;

@interface RefundDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToRefundHeight;

@property (nonatomic, strong) TuihuoModel *model;
@property (weak, nonatomic) IBOutlet UIButton *addressInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidth;

- (IBAction)addressInfoClicked:(id)sender;
- (IBAction)wuliuInfoClicked:(id)sender;

@end
