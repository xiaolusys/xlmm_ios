//
//  HomeViewController.h
//  XLMM
//
//  Created by zhang on 16/4/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLeftViewController.h"

@interface HomeViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, RootVCPushOtherVCDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *btnView;

- (IBAction)btnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type;
@end
