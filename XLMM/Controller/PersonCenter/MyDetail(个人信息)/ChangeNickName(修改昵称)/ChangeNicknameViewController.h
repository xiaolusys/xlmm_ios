//
//  ChangeNicknameViewController.h
//  XLMM
//
//  Created by zifei.zhong on 15/11/18.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeNameBlock)(NSString *nameStr);

@interface ChangeNicknameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *changeNicknameButton;
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;
- (IBAction)changeNicknameButtonClick:(id)sender;

@property (nonatomic, copy) NSString *nickNameText;
@property (nonatomic, copy) changeNameBlock blcok;


@end
