//
//  JMCouponSuccessController.m
//  XLMM
//
//  Created by zhang on 16/7/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCouponSuccessController.h"

@interface JMCouponSuccessController ()
/*
 头视图
 */
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *successImageView;
@property (nonatomic,strong) UILabel *cuccessLabel;
@property (nonatomic,strong) UILabel *promptLabel;

/*
 下侧视图
 */
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *completeBtn;


@end

@implementation JMCouponSuccessController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    
    [self createLayout];
}
#pragma mark -- 布局
- (void)createLayout {
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    self.headView = headView;
    
    UIImageView *successImageView = [[UIImageView alloc] init];
    [self.headView addSubview:successImageView];
    self.successImageView = successImageView;
    successImageView.image = [UIImage imageNamed:@"apply_for_success"];
    
    
    
    UILabel *cuccessLabel = [[UILabel alloc] init];
    [self.headView addSubview:cuccessLabel];
    self.cuccessLabel = cuccessLabel;
    self.cuccessLabel.font = [UIFont boldSystemFontOfSize:18.];
    self.cuccessLabel.text = @"兑换成功！";
    self.cuccessLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *promptLabel = [[UILabel alloc] init];
    [self.headView addSubview:promptLabel];
    self.promptLabel = promptLabel;
    self.promptLabel.font = [UIFont systemFontOfSize:12.];
    self.promptLabel.text = [NSString stringWithFormat:@"恭喜您获得一张价值%ld元的优惠券，请及时使用哦",self.moneyNum];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor lineGrayColor];


    self.promptLabel.font = [UIFont systemFontOfSize:12.];
    
    
    UIButton *completeBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:completeBtn];
    self.completeBtn = completeBtn;
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_offset(SCREENWIDTH);
        make.bottom.equalTo(self.promptLabel.mas_bottom).offset(30);
        //        make.height.mas_offset(@(571/2));
    }];
    
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_top).offset(116/2);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_offset(@60);
        make.height.mas_offset(@(79/2));
    }];
    
    [self.cuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successImageView.mas_bottom).offset(28);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_offset(@160);
        make.height.mas_offset(@32);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cuccessLabel.mas_bottom).offset(26);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.width.mas_offset(SCREENWIDTH);
        make.height.mas_offset(@14);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_offset(SCREENWIDTH);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];

    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(40);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.width.mas_offset(SCREENWIDTH - 30);
        make.height.mas_offset(40);
        //        make.bottom.equalTo(self.bottomView.mas_bottom).offset(70);
    }];

}
- (void)finishButton:(UIButton *)btn {
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (_withDrawMoney - 20 < 0.00001) {
        if (count >= 2) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
@end






































































