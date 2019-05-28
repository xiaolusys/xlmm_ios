//
//  JMInstallPasswordController.m
//  XLMM
//
//  Created by zhang on 17/3/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMInstallPasswordController.h"


@interface JMInstallPasswordController () <UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *maskScrollView;
//@property (nonatomic, strong) UIButton *rememberPwdBtn;
//@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UITextField *pwdTextField1;
@property (nonatomic, strong) UITextField *pwdTextField2;


@end

@implementation JMInstallPasswordController
#pragma mark ==== 懒加载 ====
- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        //        _maskScrollView.scrollEnabled = NO;
    }
    return _maskScrollView;
}
#pragma mark ==== 生命周期函数 ====
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMInstallPasswordController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pwdTextField1 resignFirstResponder];
    [self.pwdTextField2 resignFirstResponder];
    [MobClick endLogPageView:@"JMInstallPasswordController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    if (self.pwdType == PWDWithInstall) {
        self.title = @"设置密码";
    }else {
        self.title = @"修改密码";
    }
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    self.fd_interactivePopDisabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.maskScrollView];
    [self createUI];
}




- (void)createUI {
    CGFloat firstSectionViewH = 120.;
    CGFloat spaceing = 15.f;
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, firstSectionViewH)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    
    UITextField *pwdTextField1 = [self createTextFieldWithFrame:CGRectMake(spaceing, 15, SCREENWIDTH - spaceing * 2, 30) PlaceHolder:@"请输入6-16位登录密码" KeyboardType:UIKeyboardTypeASCIICapable];
    self.pwdTextField1 = pwdTextField1;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, pwdTextField1.cs_max_Y + 15, SCREENWIDTH, 1.0f)];
    lineView.backgroundColor = [UIColor lineGrayColor];
    UITextField *pwdTextField2 = [self createTextFieldWithFrame:CGRectMake(spaceing, lineView.cs_max_Y + 15, SCREENWIDTH - spaceing * 2, 30 - lineView.cs_h) PlaceHolder:@"请再次输入密码" KeyboardType:UIKeyboardTypeASCIICapable];
    self.pwdTextField2 = pwdTextField2;

    
    [self.maskScrollView addSubview:textFieldView];
    [textFieldView addSubview:lineView];
    [textFieldView addSubview:pwdTextField1];
    [textFieldView addSubview:pwdTextField2];
    
    
    
    
//    UIButton *rememberPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, textFieldView.cs_max_Y + 10, 160, 25)];
//    [self.maskScrollView addSubview:rememberPwdBtn];
//    self.rememberPwdBtn = rememberPwdBtn;
//    [rememberPwdBtn setAdjustsImageWhenHighlighted:NO];
//    [rememberPwdBtn setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
//    [rememberPwdBtn setImage:[UIImage imageNamed:@"remember_password"] forState:UIControlStateSelected];
//    [rememberPwdBtn setTitle:@"同意小鹿美美服务条款" forState:UIControlStateNormal];
//    [rememberPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rememberPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13.];
//    rememberPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//调整图片文字间距
//    rememberPwdBtn.tag = 100;
//    [rememberPwdBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    UIButton *forgetPwdBtn  = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 120, textFieldView.cs_max_Y + 10, 120, 25)];
//    [self.maskScrollView addSubview:forgetPwdBtn];
//    self.forgetPwdBtn = forgetPwdBtn;
//    //设置按钮文字的下划线
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"小鹿美美服务条款"];
//    NSRange titleRange = {0,[title length]};
//    [forgetPwdBtn setTitle:@"小鹿美美服务条款" forState:UIControlStateNormal];
//    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
//    [forgetPwdBtn setAttributedTitle:title forState:UIControlStateNormal];
//    [forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
//    forgetPwdBtn.titleLabel.textColor = [UIColor colorWithRed:86/255. green:195/255. blue:241/255. alpha:1.];
//    forgetPwdBtn.tag = 101;
//    [forgetPwdBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, textFieldView.cs_max_Y + 20, SCREENWIDTH - 30, 40)];
    [self.maskScrollView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 20;
    [self enableTijiaoButton];
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    loginBtn.tag = 102;
    [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (UITextField *)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder KeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.font = [UIFont systemFontOfSize:13.];
    textField.delegate = self;
    return textField;
}
- (void)enableTijiaoButton{
    self.loginBtn.enabled = YES;
    self.loginBtn.backgroundColor = [UIColor buttonEmptyBorderColor];
    self.loginBtn.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.loginBtn.enabled = NO;
    self.loginBtn.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.loginBtn.layer.borderColor = [UIColor lineGrayColor].CGColor;
}
- (void)buttonClick:(UIButton *)button {
    switch (button.tag) {
//        case 100: {
//            if (self.rememberPwdBtn.selected) {
//                self.rememberPwdBtn.selected = NO;
//            }else {
//                self.rememberPwdBtn.selected = YES;
//            }
//        }
//            break;
//        case 101: {
//            TiaoKuanViewController *tiaokuanVC = [[TiaoKuanViewController alloc] initWithNibName:@"TiaoKuanViewController" bundle:nil];
//            [self.navigationController pushViewController:tiaokuanVC animated:YES];
//        }
//            break;
        case 102: {
            [self.pwdTextField1 resignFirstResponder];
            [self.pwdTextField2 resignFirstResponder];
//            if (self.rememberPwdBtn.selected == NO) {
//                [MBProgressHUD showMessage:@"请同意小鹿美美服务条款"];
//                return ;
//            }
            if ([NSString isStringEmpty:self.pwdTextField1.text] || [NSString isStringEmpty:self.pwdTextField2.text]) {
                [MBProgressHUD showMessage:@"请输入密码"];
                return;
            }
//            textF.text.length >= 5 && textF.text.length <= 15
            if (!(self.pwdTextField1.text.length >= 5 && self.pwdTextField1.text.length <= 15)) {
                [MBProgressHUD showMessage:@"请输入 5 - 15 位密码"];
                return;
            }
            
            if ([self.pwdTextField1.text isEqualToString:self.pwdTextField2.text]) {
//                [self enableTijiaoButton];
                [MBProgressHUD showLoading:@""];
            }else {
                [MBProgressHUD showMessage:@"请检查两次输入密码是否一致"];
                return ;
            }
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = self.phomeNumber;
            parameters[@"verify_code"] =  self.verfiyCode;
            parameters[@"password1"] = self.pwdTextField1.text;
            parameters[@"password2"] = self.pwdTextField2.text;
            [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TResetPwd_URL WithParaments:parameters WithSuccess:^(id responseObject) {
                NSString *result = [responseObject objectForKey:@"rcode"];
                if ([result intValue] == 0) {
                    [MBProgressHUD hideHUD];
                    NSString *successString = @"";
                    if (self.pwdType == PWDWithInstall) { // 设置密码
                        successString = @"密码设置成功,快去登陆吧！";
                    }else {
                        successString = @"密码设置成功!";
                    }
                    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:successString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alterView.delegate = self;
                    [alterView show];
                }else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showWarning:responseObject[@"msg"]];
                }
            } WithFail:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"密码设置失败~!"];
            } Progress:^(float progress) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ==== UITextField 代理实现 ====
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
//输入框获得焦点，执行这个方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    [self disableTijiaoButton];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
//    [muString appendString:string];
//    [muString deleteCharactersInRange:range];
//    if ([self textFieldLength:self.pwdTextField1] && [self textFieldLength:self.pwdTextField2]) {
//        [self enableTijiaoButton];
//    }else {
//        [self disableTijiaoButton];
//    }
    return YES;
}
- (BOOL)textFieldLength:(UITextField *)textF {
    BOOL isEnable = textF.text.length >= 5 && textF.text.length <= 15;
    return isEnable;
}


- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backApointInterface {
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
        //        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end





















































