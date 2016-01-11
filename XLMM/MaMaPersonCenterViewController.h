//
//  MaMaPersonCenterViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaMaPersonCenterViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIScrollView *mamaScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidth;


- (IBAction)backClicked:(id)sender;
- (IBAction)sendProduct:(id)sender;

@end
