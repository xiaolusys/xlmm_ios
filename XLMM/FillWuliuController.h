//
//  FillWuliuController.h
//  XLMM
//
//  Created by younishijie on 15/11/30.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TuihuoModel;
@interface FillWuliuController : UIViewController


@property (strong, nonatomic) TuihuoModel *model;

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

- (IBAction)selectedWuliuClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *danhaoTextField;


@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitButtonClicked:(id)sender;

@end
