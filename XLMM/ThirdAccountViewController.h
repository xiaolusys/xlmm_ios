//
//  ThirdAccountViewController.h
//  XLMM
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdAccountViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bindWX;
@property (weak, nonatomic) IBOutlet UILabel *weixinName;
@property (weak, nonatomic) IBOutlet UIButton *qqbutton;
@property (weak, nonatomic) IBOutlet UIButton *weibobutton;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaobutton;


- (IBAction)bindWXAction:(id)sender;
@end
