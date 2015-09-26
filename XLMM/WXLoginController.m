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

@interface WXLoginController ()<UITextFieldDelegate, UIAlertViewDelegate>


@end

@implementation WXLoginController{
    NSTimer *myTimer;
    NSInteger countdownSecond;
    UILabel *timeLabel;
    
    NSInteger countSecond;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    countSecond = 60;
    countdownSecond = countSecond;
    
    
    self.title = @"微信登录";
    NSLog(@"用户信息 = %@", self.userInfo);
    self.myImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.userInfo objectForKey:@"headimgurl"]]]];
    self.nameLabel.text = [self.userInfo objectForKey:@"nickname"];
    
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.psdTextField.delegate = self;
    self.confirmTextField.delegate = self;
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 60, 30)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.text = @"";
    [self.codeButton addSubview:timeLabel];
    
    
    
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
    if (textField == self.psdTextField || textField == self.confirmTextField) {
        [UIView animateWithDuration:0.3 animations:^{
           CGRect rect = self.view.frame;
            rect.origin.y -= 80;
            self.view.frame = rect;
            
            
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
    
}


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
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
         
              
              NSLog(@"Error: %@", error);
              
          }];

    
    
    //  094783
    
    timeLabel.text = @"剩余60秒";
    
    NSLog(@"phoneNumber = %@", phoneStr);
    self.codeButton.enabled = NO;
    [self.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
}

- (void)updateTime{
    countdownSecond--;
    NSLog(@"countdownSecond = %ld", (long)countdownSecond);
    
    NSString *text = [NSString stringWithFormat:@"剩余%ld秒", (long)countdownSecond];
    timeLabel.text = text;
    if (countdownSecond == 0) {
        countdownSecond = countSecond;
        [myTimer invalidate];
        self.codeButton.enabled = YES;
        [self.codeButton setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
        timeLabel.text = @"";
        
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
    NSLog(@"提交");
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/bang_mobile", Root_URL];
    NSLog(@"url = %@", urlString);
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"username": self.phoneTextField.text,
                                 @"password1": self.psdTextField.text,
                                 @"password2": self.confirmTextField.text,
                                 @"valid_code":self.codeTextField.text
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
                  
                  UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"手机已绑定" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
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


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//    }
//}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
