//
//  ModifyPasswordViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *passCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

- (IBAction)confirmClicked:(id)sender;

- (IBAction)getCode:(id)sender;

@end
