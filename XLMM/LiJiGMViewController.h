//
//  LiJiGMViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/22.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsModel.h"

@class DetailsModel;

@interface LiJiGMViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewHeight;

@property (weak, nonatomic) IBOutlet UIView *addressViewContaint;

@property (nonatomic, strong)NSString *skuID;
@property (nonatomic, strong)NSString *itemID;


@property (weak, nonatomic) IBOutlet UIImageView *myimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;

@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;

@property (weak, nonatomic) IBOutlet UILabel *allPaymentLabel;


@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;


- (IBAction)addAddress:(id)sender;
- (IBAction)reduceClicked:(id)sender;
- (IBAction)addClicked:(id)sender;


- (IBAction)youhuiClicked:(id)sender;


- (IBAction)buyClicked:(id)sender;

@end
