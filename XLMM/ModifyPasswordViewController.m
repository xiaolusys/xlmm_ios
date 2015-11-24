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

#import "ModifyPasswordViewController2.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>

@end

@implementation ModifyPasswordViewController{
    
    
    NSTimer *myTimer;
    NSInteger countdownSecond;
    UILabel *timeLabel;
    NSInteger countSecond;
    NSString *phonenumberString;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
//  获取验证码


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//
    countSecond = 60;
    countdownSecond = countSecond;
    
    
    [self createNavigationBarWithTitle:@"修改密码" selecotr:@selector(btnClicked:)];

    self.passCodeTextField.delegate = self;
    self.passCodeTextField.returnKeyType = UIReturnKeyDone;
    
     self.passCodeTextField.borderStyle = UITextBorderStyleNone;

     self.passCodeTextField.backgroundColor = [UIColor whiteColor];

    self.passCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.passCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
   // http://youni.huyi.so/rest/v1/register/change_pwd_code
    
    self.codeButton.layer.cornerRadius = 15;
    self.codeButton.layer.borderWidth = 0.5;
    self.codeButton.layer.borderColor = [UIColor orangeThemeColor].CGColor;
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
//    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
//    phonenumberString = str1;
    //  http://m.xiaolu.so/rest/v1/users
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users", Root_URL];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    
    
    NSDictionary *result = [[dic objectForKey:@"results"] objectAtIndex:0];
    NSString *str1 = [result objectForKey:@"mobile"];
    
    if (str1.length == 11) {
        NSMutableString *str = [NSMutableString stringWithString:str1];
        
        NSRange range = {3,4};
        [str replaceCharactersInRange:range withString:@"****"];
        self.phoneLabel.text = str;
    }
    
    
    
    [self disableTijiaoButton];
    
}

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


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 6) {
        [self enableTijiaoButton];
        [textField resignFirstResponder];
        
    } else {
        [self disableTijiaoButton];
       // [textField becomeFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length == 5) {
        [self enableTijiaoButton];
        return YES;
    }
    else
    {
        [self disableTijiaoButton];
        
    }
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passCodeTextField resignFirstResponder];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)enableTijiaoButton{
    self.nextButton.enabled = YES;
    self.nextButton.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    self.nextButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.nextButton.enabled = NO;
    self.nextButton.backgroundColor = [UIColor colorWithR:227 G:227 B:227 alpha:1];
    self.nextButton.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
}

- (IBAction)confirmClicked:(id)sender {

    //下一步进入设置密码界面
    
    if (self.passCodeTextField.text.length != 6) {
        return;
    }
    ModifyPasswordViewController2 *modifypsdVC = [[ModifyPasswordViewController2 alloc] initWithNibName:@"ModifyPasswordViewController2" bundle:nil];
    modifypsdVC.codeString = self.passCodeTextField.text;
    modifypsdVC.phoneString = phonenumberString;
    [self.navigationController pushViewController:modifypsdVC animated:YES];
    
    
}

- (IBAction)getCode:(id)sender {
    NSLog(@"获取验证码");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSLog(@"phoneNumber = %@\n", phoneNum);
    NSDictionary *parameters = @{@"vmobile": phoneNum};
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/register/change_pwd_code", Root_URL];
    NSLog(@"stringUrl = %@", string);
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
}

- (void)updateTime{
    countdownSecond--;
    //  NSLog(@"countdownSecond = %ld", (long)countdownSecond);
    
    NSString *text = [NSString stringWithFormat:@"%ld秒", (long)countdownSecond];
    //   timeLabel.text = text;
    self.buttonLabel.text = text;
    self.buttonLabel.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
    self.codeButton.layer.borderColor = [UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor;
    
    //#warning change timeLabel
    
    if (countdownSecond == 55) {
        countdownSecond = countSecond;
        [myTimer invalidate];
        self.codeButton.enabled = YES;
        self.codeButton.layer.borderColor = [UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor;
        self.buttonLabel.textColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
        self.buttonLabel.text = @"获取验证码";
        
        
        
    }
}
@end
