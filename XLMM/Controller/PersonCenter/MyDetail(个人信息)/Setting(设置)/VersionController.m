//
//  VersionController.m
//  XLMM
//
//  Created by younishijie on 15/12/4.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "VersionController.h"
#import "DebugSettingViewController.h"

@interface VersionController (){
        NSInteger clickHeadImgCount;
}

@end

@implementation VersionController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"VersionController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"VersionController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"关于小鹿美美" selecotr:@selector(backClicked:)];
    
    [self createInfo];
    
    clickHeadImgCount = 0;
    [self.imgDeer setUserInteractionEnabled:YES];
    [self.imgDeer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImage:)]];
}

- (void)createInfo{
    //创建关于小鹿美美的界面。。。。。。
    self.versionLabel.text = self.versionString;
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)clickHeadImage:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"clickHeadImage");
    //NSLog(@"%hhd",[gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]);
    
    UIView *viewClicked=[gestureRecognizer view];
    if (viewClicked==self.imgDeer) {
        NSLog(@"headerImageView");
        clickHeadImgCount++;
        //跳到debug vc
        if(clickHeadImgCount == 8){
            clickHeadImgCount = 0;
            
            DebugSettingViewController *debugVC = [[DebugSettingViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
            
            [self.navigationController pushViewController:debugVC animated:YES];
        }
    }
    
}

@end




















