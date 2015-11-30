//
//  FillWuliuController.h
//  XLMM
//
//  Created by younishijie on 15/11/30.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillWuliuController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;


@property (weak, nonatomic) IBOutlet UITextField *danhaoTextField;


@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitButtonClicked:(id)sender;

@end
