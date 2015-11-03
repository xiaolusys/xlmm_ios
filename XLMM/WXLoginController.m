//
//  WXLoginController.m
//  XLMM
//
//  Created by younishijie on 15/9/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "WXLoginController.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "UIViewController+NavigationBar.h"
#import "SetPasswordController.h"
#import "AFNetworking.h"


@interface WXLoginController ()<UITextFieldDelegate, UIAlertViewDelegate>


@end

@implementation WXLoginController{
    NSTimer *myTimer;
    NSInteger countdownSecond;
    UILabel *timeLabel;
    NSInteger countSecond;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyboard) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    
}

- (void)showKeyboard{
    NSLog(@"show");
    
      self.view.frame = CGRectMake(0, -112, SCREENWIDTH, SCREENHEIGHT);
    
}

- (void)hiddenKeyboard{
    NSLog(@"Hidden");
    
      self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    countSecond = 60;
    countdownSecond = countSecond;
    
    
    self.title = @"手机绑定";
    [self createNavigationBarWithTitle:@"手机绑定" selecotr:@selector(backClicked:)];
    NSLog(@"用户信息 = %@", self.userInfo);
    self.myImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.userInfo objectForKey:@"headimgurl"]]]];
    
//[NSString stringWithFormat:<#(nonnull NSString *), ...#>]
    NSString *nameString = [NSString stringWithFormat:@"微信号:%@", [self.userInfo objectForKey:@"nickname"]];
    self.nameLabel.text =  nameString;
    
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
  
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    
  
    
    self.myImageView.layer.cornerRadius = 45;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 1;
    self.myImageView.layer.borderColor = [UIColor colorWithR:253 G:203 B:14 alpha:1].CGColor;
    self.buttonLabel.text = @"获取验证码";
    
    self.codeButton.layer.cornerRadius = 16;
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = [UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor;
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.borderColor = [UIColor colorWithR:217 G:140 B:13 alpha:1].CGColor;
    
    
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.confirmTextField) {
   
        [self.confirmTextField resignFirstResponder];
        return YES;
    }
    return NO;
   
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
  
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
   
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
 
    
}

// rest/v1/users/check_code

// username  valid_code

//

- (IBAction)getCodeClicked:(id)sender {
    NSLog(@"验证码");
    NSString *phoneStr = self.phoneTextField.text;
    
  
    
    if (phoneStr.length != 11) {
        NSLog(@"不是11位");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
        return;
        
    }
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/bang_mobile_code", Root_URL];
    NSLog(@"url = %@", urlString);
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   
    NSDictionary *parameters = @{@"vmobile": phoneStr};
    NSLog(@"parameters = %@", parameters);
    
    
    
 
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSString *string = [responseObject objectForKey:@"result"];
              NSLog(@"result = %@", string);
              UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
              
              if ([string isEqualToString:@"ok"]) {
                  
              } else if ([string isEqualToString:@"1"]){
                  alterView.message = @"该手机已绑定,请使用其他手机号";
                  [alterView show];
              } else if ([string isEqualToString:@"false"]){
                  alterView.message = @"手机号错误,请重新输入";
                  [alterView show];
              } else if ([string isEqualToString:@"2"]){
                  alterView.message = @"超过当日获取验证码次数";
                  [alterView show];
                  
              } else if ([string isEqualToString:@"3"]){
                  alterView.message = @"验证码依然有效,无须重新获取";
                  [alterView show];
              }
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
         
              
              NSLog(@"Error: %@", error);
              
          }];

    
    
    //  094783
    
    
    NSLog(@"phoneNumber = %@", phoneStr);
    self.codeButton.enabled = NO;
   
    
    
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
    
    if (countdownSecond == 0) {
        countdownSecond = countSecond;
        [myTimer invalidate];
        self.codeButton.enabled = YES;
        self.codeButton.layer.borderColor = [UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor;
        self.buttonLabel.textColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
        self.buttonLabel.text = @"获取验证码";
        
      
        
    }
}



- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}


- (IBAction)commitClicked:(id)sender {
    NSLog(@"下一步");
    
    
    // rest/v1/users/check_code
    
    // username  valid_code
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/check_code", Root_URL];
    NSLog(@"url = %@", urlString);
    
   // AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"username": self.phoneTextField.text,
                                 @"valid_code":self.codeTextField.text
                                 };
    NSLog(@"parameters = %@", parameters);
    
    
    
    //第一步，创建URL
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = [NSString stringWithFormat:@"username=%@&valid_code=%@", self.phoneTextField.text, self.codeTextField.text];//设置参数
    NSLog(@"params = %@", str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions
                                                           error:nil];
    NSString *result = [json objectForKey:@"result"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    NSLog(@"%@",str1);
    if ([result isEqualToString:@"ok"]) {
        NSLog(@"the result is ok");
        alertView.message = result;
        [alertView show];
        
    } else if ([result isEqualToString:@"4"]){
        NSLog(@"the result is 4");
        
        alertView.message = @"验证码已过期";
        [alertView show];
        return;
        
    
    } else if ([result isEqualToString:@"3"]){
        alertView.message = @"验证码输入错误";
        [alertView show];
        return;
    } else if ([result isEqualToString:@"0"]){
        alertView.message = @"该手机已绑定,请使用其他手机号";
        [alertView show];
        return;
    } else if ([result isEqualToString:@"2"]){
        alertView.message = @"参数错误";
        [alertView show];
        return;
        
    }
  

    
    
    NSLog(@"%@ %@", self.phoneTextField.text, self.codeTextField.text);
    SetPasswordController *nextVC = [[SetPasswordController alloc] initWithNibName:@"SetPasswordController" bundle:nil phone:self.phoneTextField.text code:self.codeTextField.text];
    
    NSLog(@"%@  %@", nextVC.phone, nextVC.code);
    
    [self.navigationController pushViewController:nextVC animated:YES];
    
    
   /*
    
   
    

    
    */
    
    
}



//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//    }
//}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
