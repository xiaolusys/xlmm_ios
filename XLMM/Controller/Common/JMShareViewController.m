//
//  JMShareViewController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareViewController.h"
#import "Masonry.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "MMClass.h"
#import "JMShareButtonView.h"


@interface JMShareViewController ()<JMShareButtonViewDelegate>

@property (nonatomic,strong) JMSelecterButton *canelButton;

@property (nonatomic,strong) JMShareButtonView *shareButton;

@property (nonatomic,strong) UIView *shareBackView;



@end

@implementation JMShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, 230);
    [self createShareButtom];
    
}



- (void)createShareButtom {
//    UIView *shareBackView = [UIView new];
//    [self.view addSubview:shareBackView];
//    self.shareBackView = shareBackView;
//    self.shareBackView.layer.cornerRadius = 20;
//    self.shareBackView.backgroundColor = [[UIColor shareViewBackgroundColor]colorWithAlphaComponent:1.0];
//    self.shareBackView.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 180);
    
    JMShareButtonView *shareButton = [[JMShareButtonView alloc] init];
    self.shareButton = shareButton;
//    self.shareButton.frame = self.shareBackView.frame;
    self.shareButton.delegate = self;
    self.shareButton.layer.cornerRadius = 20;
    [self.view addSubview:self.shareButton];
    self.shareButton.backgroundColor = [[UIColor shareViewBackgroundColor]colorWithAlphaComponent:1.0];
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    self.canelButton = cancelButton;
    [self.canelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:13. CornerRadius:15];
    [self.view addSubview:self.canelButton];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(180);
    }];
    
    [self.canelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.shareButton.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(30);
    }];
    

    
    
}

- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index {
    if (index == 0) {
        NSLog(@"分享按钮被点击了 ===== index == 0");
    }else if (index == 1) {
        NSLog(@"分享按钮被点击了 ===== index == 1");

    }else if (index == 2) {
        NSLog(@"分享按钮被点击了 ===== index == 2");

    }else if (index == 3) {
        NSLog(@"分享按钮被点击了 ===== index == 3");

    }else if (index == 4) {
        NSLog(@"分享按钮被点击了 ===== index == 4");

    }else if (index == 5) {
        NSLog(@"分享按钮被点击了 ===== index == 5");

    }else { // 6
        NSLog(@"分享按钮被点击了 ===== index == 6");

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end




































