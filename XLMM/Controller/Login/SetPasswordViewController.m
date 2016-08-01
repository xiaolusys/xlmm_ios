//
//  SetPasswordViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/18.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "MMClass.h"
#import "TiaoKuanViewController.h"



@interface SetPasswordViewController()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isAgreementChecked;
@end

@implementation SetPasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:self.config[@"title"] selecotr:@selector(backClicked:)];
    if (![self.config[@"isRegister"] boolValue]) {
        self.checkButton.hidden = YES;
        self.agreementButton.hidden = YES;
        self.fuwutiaokuanButton.hidden = YES;
        
    }
    
    self.isAgreementChecked = YES;
    self.passwordTextField.placeholder = self.config[@"text1"];
    
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    self.commitButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    
    self.passwordTextField.delegate = self;
    self.confirmTextField.delegate = self;
    [self disableTijiaoButton];
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)enableTijiaoButton{
    self.commitButton.enabled = YES;
    self.commitButton.backgroundColor = [UIColor buttonEmptyBorderColor];
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
}
#pragma mark --TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == self.passwordTextField) {
//        [self.confirmTextField becomeFirstResponder];
//    }
    if ([self.passwordTextField.text isEqualToString:self.confirmTextField.text]) {
        if (self.passwordTextField.text.length <= 5) {
            [self disableTijiaoButton];
            
        } else{
            [self enableTijiaoButton];
            
        }
    } else{
        [self disableTijiaoButton];
    }
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([self.passwordTextField.text isEqualToString:self.confirmTextField.text]) {
//        [self enableTijiaoButton];
//    } else{
//        [self disableTijiaoButton];
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passwordTextField) {

        [self.confirmTextField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
    
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

- (IBAction)commitClicked:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *password1 = self.passwordTextField.text;
    NSString *password2 = self.confirmTextField.text;

    NSDictionary *parameters = @{@"mobile": self.config[@"phone"],
                                 @"verify_code":self.config[@"vcode"],
                                 @"password1":password1,
                                 @"password2":password2,
                                 };
    NSLog(@"%@", parameters);
    NSString *string = TResetPwd_URL;
//    if ([self.config[@"isRegister"] boolValue]) {
//        NSLog(@"注册密码");
//        string = [NSString stringWithFormat:@"%@/rest/v1/register/change_user_pwd", Root_URL];
//    } else {
//        NSLog(@"修改密码");
//        string = [NSString stringWithFormat:@"%@/rest/v1/register/change_user_pwd", Root_URL];
//    }
    
   
    MMLOG(string);
    
    [manager POST:string parameters:parameters
         progress:^(NSProgress * _Nonnull downloadProgress) {
             //数据请求的进度
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"JSON: %@", responseObject);
              //isVerifyPsd
              if ([self.config[@"isVerifyPsd"] boolValue]) {
                  NSString *result = [responseObject objectForKey:@"rcode"];
                  if ([result intValue] == 0) {
                      UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"密码设置成功,快去登陆吧！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                      [alterView show];
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  }
              }else {
                  NSString *result = [responseObject objectForKey:@"rcode"];
                  if ([result intValue] == 0) {
                      UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"密码设置成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                      [alterView show];
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  }
              }
              //修改密码成功，要怎么做。。。。
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error: %@", error);
          }];

    
}


- (void)changeCheckButtonBackground {
    self.isAgreementChecked = !self.isAgreementChecked;
    NSLog(@"--%d",self.isAgreementChecked);
    UIImage *image = nil;
    if (self.isAgreementChecked) {
        image = [UIImage imageNamed:@"right_button.png"];
    } else {
        image = [UIImage imageNamed:@"empty.png"];
    }
    [self.checkButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)checkButtonClicked:(id)sender
{
    [self changeCheckButtonBackground];

}

- (IBAction)agreementButtonClicked:(id)sender
{
    [self changeCheckButtonBackground];
}

- (IBAction)fuwutiaokuanClicked:(id)sender {
    NSLog(@"查看小鹿妹妹服务条款");
    TiaoKuanViewController *tiaokuanVC = [[TiaoKuanViewController alloc] initWithNibName:@"TiaoKuanViewController" bundle:nil];
    [self.navigationController pushViewController:tiaokuanVC animated:YES];
}


@end
