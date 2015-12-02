//
//  NewLeftViewController.h
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RootVCPushOtherVCDelegate <NSObject>

- (void) rootVCPushOtherVC:(UIViewController *)vc;

@end

@interface NewLeftViewController : UIViewController

@property (nonatomic, assign)id<RootVCPushOtherVCDelegate>pushVCDelegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UIView *touxiangImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;


@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiquanLabel;

- (IBAction)jifenClicked:(id)sender;
- (IBAction)youhuquanClicked:(id)sender;



- (IBAction)settingClicked:(id)sender;
- (IBAction)suggestionClicked:(id)sender;

- (IBAction)waitPayClicked:(id)sender;

- (IBAction)waitSendClicked:(id)sender;
- (IBAction)tuihuoClicked:(id)sender;
- (IBAction)allDingdanClicked:(id)sender;
- (IBAction)tuichuClicked:(id)sender;

- (IBAction)loginButtonClicked:(id)sender;

@end
