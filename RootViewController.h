//
//  RootViewController.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *posterView;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UIView *ladyView;

- (IBAction)btnClicked:(UIButton *)sender;


@end
