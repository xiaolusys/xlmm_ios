//
//  JMAuthcodeViewController.m
//  XLMM
//
//  Created by zhang on 16/5/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAuthcodeViewController.h"
#import "JMAuthcodeViewController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "WXApi.h"
#import "UIViewController+NavigationBar.h"


@interface JMAuthcodeViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIView *bottomView;


@property (nonatomic,strong) UITextField *phoneNumTextF;

@property (nonatomic,strong) UITextField *passwordTextF;

@property (nonatomic,strong) UIView *centerLineView;

//是否可以查看密码的按钮
@property (nonatomic,strong) UIButton *getAuthcodeBtn;


@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation JMAuthcodeViewController
- (void)viewDidLoad {
    
}


- (void)prepareUI {
    
    /**
     底部视图控件
     */
    UIView *headView  = [[UIView alloc] init];
    [self.view addSubview:headView];
    self.headView = headView;
    
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    /**
     分割线 控件
     
     - returns:
     */
    UIView *centerLineView  = [[UIView alloc] init];
    [self.headView addSubview:centerLineView];
    self.centerLineView = centerLineView;
    
    
    //    UIView *forgetPwdBottomView = [UIView new];
    //    [self.bottomView addSubview:forgetPwdBottomView];
    //    self.forgetPwdBottomView = forgetPwdBottomView;
    
    /**
     文本框控件
     */
    UITextField *phoneNumTextF  = [[UITextField alloc] init];
    [self.headView addSubview:phoneNumTextF];
    self.phoneNumTextF = phoneNumTextF;
    self.phoneNumTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTextF.font = [UIFont systemFontOfSize:14.];
    self.phoneNumTextF.placeholder = @"手机号";
    self.phoneNumTextF.delegate = self;
    
    
    UITextField *passwordTextF = [UITextField new];
    [self.headView addSubview:passwordTextF];
    self.passwordTextF = passwordTextF;
    self.passwordTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextF.font = [UIFont systemFontOfSize:14.];
    self.passwordTextF.placeholder = @"手机号";
    self.passwordTextF.delegate = self;
    
    
    /**
     按钮控件
     */
    UIButton *getAuthcodeBtn  = [[UIButton alloc] init];
    [self.headView addSubview:getAuthcodeBtn];
    self.getAuthcodeBtn = getAuthcodeBtn;
    
    
    UIButton *loginBtn = [UIButton new];
    [self.bottomView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    
}

- (void)prepareInitUI {
    
    kWeakSelf
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(121);
    }];
    
    [self.phoneNumTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.right.equalTo(weakSelf.headView).offset(-10);
        make.height.mas_equalTo(60);
    }];
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneNumTextF.mas_bottom);
        make.left.right.equalTo(weakSelf.headView);
        make.height.mas_equalTo(1);
    }];
    
    [self.passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLineView);
        make.left.equalTo(weakSelf.headView).offset(10);
        make.right.equalTo(weakSelf.getAuthcodeBtn).offset(-10);
        make.height.mas_equalTo(60);
    }];
    //密码是否可见的按钮  大小先固定为40 * 40
    [self.getAuthcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerLineView.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.headView).offset(-10);
        make.width.height.mas_equalTo(@40);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.left.equalTo(weakSelf.view).offset(15);
        make.right.equalTo(weakSelf.view).offset(-15);
        make.height.mas_equalTo(@40);
    }];
    
    
    
}

@end


