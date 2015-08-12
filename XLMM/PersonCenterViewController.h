//
//  PersonCenterViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *virticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)button1Clicked:(id)sender;

- (IBAction)button2Clicked:(id)sender;

- (IBAction)button3Clicked:(id)sender;


- (IBAction)btn1Clicked:(id)sender;

- (IBAction)btn2Clicked:(id)sender;
- (IBAction)btn3Clicked:(id)sender;

- (IBAction)btn4Clicked:(id)sender;

- (IBAction)btn5Clicked:(id)sender;
- (IBAction)btn6Clicked:(id)sender;
- (IBAction)btn7Clicked:(id)sender;

- (IBAction)gobackClicked:(id)sender;


@end
