//
//  UserInfoViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/26.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人信息";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id diction = [userDefaults objectForKey:@"userInfo"];
    NSLog(@"diction = %@", diction);
    
    if ([diction isKindOfClass:[NSDictionary class]]) {
        NSLog(@"微信账号登录");
        self.nameLabel.text = [diction objectForKey:@"nickname"];
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[diction objectForKey:@"headimgurl"]]];
        [self createView];

    } else if ([diction isKindOfClass:[NSString class]]){
        NSLog(@"小鹿美美账号登录");

    }else{
        NSLog(@"出错了");
        
    }
    
    
    
}

- (void)createView{
  
    
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

@end
