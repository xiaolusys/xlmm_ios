//
//  NewLeftViewController.m
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "NewLeftViewController.h"

@interface NewLeftViewController ()

@end

@implementation NewLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect mainSize = [UIScreen mainScreen].bounds;
    NSLog(@"mainScreen %@", NSStringFromCGRect(mainSize));
    self.headerViewHeight.constant = mainSize.size.height * 0.297f;
    self.footerViewHeight.constant = mainSize.size.height * 0.3126f;
    
    NSLog(@"headviewheight = %f, footerViewHeight = %f", _headerViewHeight.constant, _footerViewHeight.constant);
    self.quitButton.layer.borderWidth = 1.0;
    self.quitButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.quitButton.layer.cornerRadius = 18.5;
    self.touxiangImage.layer.cornerRadius = 30;
    self.touxiangImage.layer.borderColor = [UIColor colorWithRed:253/255.0 green:203/255.0 blue:14/255.0 alpha:1].CGColor;
    self.touxiangImage.layer.masksToBounds = YES;
    self.touxiangImage.layer.borderWidth = 2;
    if (mainSize.size.height == 480) {
        NSLog(@"ihone 4s");
        self.topDistance.constant = 24;
        self.bottomDistance.constant = 24;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)settingClicked:(id)sender {
    NSLog(@"设置");
}

- (IBAction)suggestionClicked:(id)sender {
    NSLog(@"投诉建议");
}

- (IBAction)waitPayClicked:(id)sender {
    NSLog(@"待支付");
}

- (IBAction)waitSendClicked:(id)sender {
     NSLog(@"待收货");
}

- (IBAction)tuihuoClicked:(id)sender {
     NSLog(@"退换货");
}

- (IBAction)allDingdanClicked:(id)sender {
     NSLog(@"全部订单");
}

- (IBAction)tuichuClicked:(id)sender {
    NSLog(@"退出账户");
}
@end
