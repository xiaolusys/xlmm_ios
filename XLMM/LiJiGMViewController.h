//
//  LiJiGMViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/22.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiJiGMViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewHeight;

@property (weak, nonatomic) IBOutlet UIView *addressViewContaint;

- (IBAction)addAddress:(id)sender;

@end
