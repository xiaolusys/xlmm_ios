//
//  TSettingViewController.h
//  XLMM
//
//  Created by zhang on 16/4/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSettingViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


- (IBAction)versionButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *pushOnView;


@end
