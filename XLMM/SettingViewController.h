//
//  SettingViewController.h
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;



@property (weak, nonatomic) IBOutlet UIButton *deleteButton;



- (IBAction)nickButtonClicked:(id)sender;
- (IBAction)phoneButtonClicked:(id)sender;
- (IBAction)modifyButtonClicked:(id)sender;
- (IBAction)addressButtonClicked:(id)sender;
- (IBAction)versionButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;

- (IBAction)thirdAccountBind:(id)sender;


@end
