//
//  PurchaseViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myCartsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartsViewHeight;

@property (strong, nonatomic) NSArray *cartsArray;

@property (weak, nonatomic) IBOutlet UIView *addressView;


@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountfeeLabel;

@property (weak, nonatomic) IBOutlet UIView *zhifuView;
- (IBAction)zhifuSelected:(id)sender;

@end
