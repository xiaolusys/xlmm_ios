//
//  TixianViewController.h
//  XLMM
//
//  Created by younishijie on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TixianViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hongbaoImage1;

@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hongbaoImage2;

@property (weak, nonatomic) IBOutlet UIButton *tixianButton;

@property (weak, nonatomic) IBOutlet UIView *unableTixianView;

- (IBAction)tixianClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fabuButton;

- (IBAction)fabuClicked:(id)sender;

@property (nonatomic, assign) float cantixianjine;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong)NSNumber *carryNum;

@end
