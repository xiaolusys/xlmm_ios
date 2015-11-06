//
//  SettingPsdViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/6.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPsdViewController : UIViewController

@property (nonatomic, copy) NSString *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UIButton *querenButton;
- (IBAction)querenClicked:(id)sender;

@property (nonatomic, strong) NSDictionary *info;


@end
