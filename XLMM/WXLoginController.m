//
//  WXLoginController.m
//  XLMM
//
//  Created by younishijie on 15/9/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "WXLoginController.h"

@interface WXLoginController ()

@end

@implementation WXLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"微信登录";
    NSLog(@"用户信息 = %@", self.userInfo);
    self.myImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.userInfo objectForKey:@"headimgurl"]]]];
    self.nameLabel.text = [self.userInfo objectForKey:@"nickname"];
    
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


- (IBAction)getCodeClicked:(id)sender {
    NSLog(@"验证码");
    
}

- (IBAction)commitClicked:(id)sender {
    NSLog(@"提交");
    
}
@end
