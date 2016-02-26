//
//  SetPasswordController.m
//  XLMM
//
//  Created by younishijie on 15/11/2.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SetPasswordController.h"
#import "UIViewController+NavigationBar.h"
#import "UIColor+RGBColor.h"
#import "AFNetworking.h"
#import "MMClass.h"

@interface SetPasswordController ()<UITextFieldDelegate>


@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *code;

@end

@implementation SetPasswordController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil phone:(NSString *)phone code:(NSString *)code {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.phone = phone;
        self.code = code;
      
    }
    return self;
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTF.borderStyle = UITextBorderStyleNone;
    self.confirmTextField.borderStyle = UITextBorderStyleNone;
    [self createNavigationBarWithTitle:@"密码设置" selecotr:@selector(backButtonClicked:)];
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    self.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.confirmTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.passwordTF.delegate = self;
    self.confirmTextField.delegate = self;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.returnKeyType = UIReturnKeyNext;
    self.confirmTextField.returnKeyType = UIReturnKeyDone;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passwordTF) {
        [self.confirmTextField becomeFirstResponder];
        
        return NO;
    }
    if (textField == self.confirmTextField) {
        [textField resignFirstResponder];
        
        return YES;
    }
    return YES;
}
- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passwordTF resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
    
}





- (IBAction)commitBtnClicked:(id)sender {
    NSLog(@"提交");
    if (![self.passwordTF.text isEqualToString:self.confirmTextField.text]) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"两次密码输入不一致,请重新输入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alterView show];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/bang_mobile", Root_URL];
    NSLog(@"url = %@", urlString);
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"username": self.phone,
                                 @"password1": self.passwordTF.text,
                                 @"password2": self.confirmTextField.text,
                                 @"valid_code":self.code
                                 };
    NSLog(@"parameters = %@", parameters);
    
    
    
    
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSString *string = [responseObject objectForKey:@"result"];
              NSLog(@"result = %@", string);
              //  string = @"0";
              if ([string isEqualToString:@"0"]) {
                  
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已成功绑定手机号" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  [alertView show];
                  
                  [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:1.0];
                  //                  [self.navigationController popViewControllerAnimated:YES];
              }
              if ([string isEqualToString:@"1"]) {
                  
                  UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"手机号已绑定" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                  [alterView show];
              }
              if ([string isEqualToString:@"2"]) {
                  
                  UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"参数错误" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                  [alterView show];
              }
              if ([string isEqualToString:@"3"]) {
                  UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                  [alterView show];
              }
              if ([string isEqualToString:@"4"]) {
                  UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"验证码过期" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                  [alterView show];
              }
              if ([string isEqualToString:@"5"]) {
                  [self.navigationController popViewControllerAnimated:YES];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              
              NSLog(@"Error: %@", error);
              
          }];
    
}

- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
