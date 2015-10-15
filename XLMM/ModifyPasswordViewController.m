//
//  ModifyPasswordViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "UIViewController+NavigationBar.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"修改密码";
//    [self setInfo];
    
    [self createNavigationBarWithTitle:@"修改密码" selecotr:@selector(btnClicked:)];
    
    self.infoLabel.hidden = YES;
    self.passwordLabel.hidden = YES;
    self.phoneNumberTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:kUserName];
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumberTextField.delegate = self;
    self.passCodeTextField.delegate = self;
    self.setPasswordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
    self.phoneNumberTextField.borderStyle = UITextBorderStyleNone;
     self.passCodeTextField.borderStyle = UITextBorderStyleNone;
     self.setPasswordTextField.borderStyle = UITextBorderStyleNone;
     self.confirmPasswordTextField.borderStyle = UITextBorderStyleNone;
    self.phoneNumberTextField.backgroundColor = [UIColor whiteColor];
     self.passCodeTextField.backgroundColor = [UIColor whiteColor];
     self.setPasswordTextField.backgroundColor = [UIColor whiteColor];
     self.confirmPasswordTextField.backgroundColor = [UIColor whiteColor];
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.setPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
   // http://youni.huyi.so/rest/v1/register/change_pwd_code
    
    
}
//
//- (void)setInfo{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    label.text = @"密码修改";
//    label.textColor = [UIColor blackColor];
//    label.font = [UIFont systemFontOfSize:26];
//    label.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = label;
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
//    imageView.frame = CGRectMake(8, 8, 18, 31);
//    [button addSubview:imageView];
//    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    
//}
- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)backBtnClicked:(UIButton *)button{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITextFieldDelegate--

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberTextField resignFirstResponder];
    [self.passCodeTextField resignFirstResponder];
    [self.setPasswordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmClicked:(id)sender {
    NSLog(@"确认");
    if (![self.setPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        self.passwordLabel.hidden = NO;
        return;
    } else{
        self.passwordLabel.hidden = YES;
        
        NSLog(@"注册");
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *phoneNumber = _phoneNumberTextField.text;
        NSString *validCode = _passCodeTextField.text;
        NSString *password1 = _setPasswordTextField.text;
        NSString *password2 = _confirmPasswordTextField.text;
        
        NSLog(@"username:%@, validcode:%@, password1:%@, password2:%@", phoneNumber, validCode, password1, password2);
        
        
        NSDictionary *parameters = @{@"username": phoneNumber,
                                     @"valid_code":validCode,
                                     @"password1":password1,
                                     @"password2":password2,
                                     };
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/register/change_user_pwd", Root_URL];
        NSLog(@"修改密码");
        MMLOG(string);
        [manager POST:string parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //  NSError *error;
                  NSLog(@"JSON: %@", responseObject);
                  // [self.navigationController popViewControllerAnimated:YES];
                  
                 
             
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
                  
              }];

        
    }
}

- (IBAction)getCode:(id)sender {
    NSLog(@"获取验证码");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"phoneNumber = %@\n", self.phoneNumberTextField.text);
    NSDictionary *parameters = @{@"vmobile": self.phoneNumberTextField.text};
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/register/change_pwd_code", Root_URL];
    NSLog(@"stringUrl = %@", string);
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

    
}
@end
