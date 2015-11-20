//
//  ModifyPhoneController.h
//  XLMM
//
//  Created by younishijie on 15/11/6.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPhoneController : UIViewController

@property (nonatomic, copy) NSString *numberString;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


- (IBAction)getCodeClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;


@end
