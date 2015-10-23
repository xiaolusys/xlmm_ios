//
//  NewLeftViewController.h
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

@interface NewLeftViewController : UIViewController

@property (nonatomic, assign)id<RootVCPushOtherVCDelegate>pushVCDelegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UIView *touxiangImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

- (IBAction)settingClicked:(id)sender;
- (IBAction)suggestionClicked:(id)sender;

- (IBAction)waitPayClicked:(id)sender;

- (IBAction)waitSendClicked:(id)sender;
- (IBAction)tuihuoClicked:(id)sender;
- (IBAction)allDingdanClicked:(id)sender;
- (IBAction)tuichuClicked:(id)sender;


@end
