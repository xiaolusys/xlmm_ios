//
//  WXLoginController.h
//  XLMM
//
//  Created by younishijie on 15/9/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXLoginController : UIViewController

@property (nonatomic, strong)NSDictionary *userInfo;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)getCodeClicked:(id)sender;
- (IBAction)commitClicked:(id)sender;
- (IBAction)backClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

@end
