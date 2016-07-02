//
//  BoundingNewPhoneController.h
//  XLMM
//
//  Created by younishijie on 15/11/6.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoundingNewPhoneController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)getCodeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *commitClicked;

@end
