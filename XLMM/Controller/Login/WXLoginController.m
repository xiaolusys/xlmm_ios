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

- (IBAction)skipClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil phoneNumber:(NSString *)phone{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.phoneTextField.text = phone;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    countSecond = 60;
    countdownSecond = countSecond;
    
    

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
    
  
    self.phoneTextField.text = self.phoneNumber;
    self.myImageView.layer.cornerRadius = 45;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 1;
    self.myImageView.layer.borderColor = [UIColor touxiangBorderColor].CGColor;
    self.buttonLabel.text = @"获取验证码";
    
    self.codeButton.layer.cornerRadius = 16;
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    
    self.skipButton.layer.cornerRadius = 20;
    self.skipButton.layer.borderWidth = 1;
    self.skipButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
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
    NSString *phoneStr = self.phoneTextField.text;
    if (phoneStr.length != 11) {
        NSLog(@"不是11位");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/bang_mobile_code", Root_URL];
    NSLog(@"TSendCode_URL = %@", TSendCode_URL);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"mobile":phoneStr, @"action":@"bind"};
    NSLog(@"parameters = %@", parameters);
    
    [manager POST:TSendCode_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (!responseObject) return;
              
              UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:[responseObject objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
              [alterView show];
              if ([[responseObject objectForKey:@"rcode"] integerValue] != 0) return;
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
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
    self.buttonLabel.textColor = [UIColor cartViewBackGround];
    self.codeButton.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    
//#warning change timeLabel
    
    if (countdownSecond == 0) {
        countdownSecond = countSecond;
        [myTimer invalidate];
        self.codeButton.enabled = YES;
        self.codeButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
        self.buttonLabel.textColor = [UIColor buttonEnabledBackgroundColor];
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

    NSDictionary *parameters = @{@"mobile": self.phoneTextField.text, @"action":@"bind", @"verify_code":self.codeTextField.text};
    NSLog(@"parameters = %@", parameters);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:TVerifyCode_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return;
        if ([[responseObject objectForKey:@"rcode"] integerValue] != 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[responseObject objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)backClicked:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
