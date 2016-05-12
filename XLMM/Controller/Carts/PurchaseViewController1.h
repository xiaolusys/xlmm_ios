//
//  PurchaseViewController1.h
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressViewController.h"





@interface PurchaseViewController1 : UIViewController<PurchaseAddressDelegate>

@property (strong, nonatomic) NSArray *cartsArray;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UIView *weixinView;
@property (weak, nonatomic) IBOutlet UILabel *postFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuijineLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containterHeight;
@property (weak, nonatomic) IBOutlet UILabel *addressZeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhifulijianLabel;

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIImageView *xiaoluimageView;

- (IBAction)addAddress:(id)sender;
- (IBAction)yhqClicked:(id)sender;
- (IBAction)zhifubaoClicked:(id)sender;
- (IBAction)weixinZhifuClicked:(id)sender;
- (IBAction)buyClicked:(id)sender;
- (IBAction)xiaoluqianbaoSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UILabel *availableLabel;

@property (weak, nonatomic) IBOutlet UIButton *xlwButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UITextField *tfMsg;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UIView *containterView;

@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;

@end
