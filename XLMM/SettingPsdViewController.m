//
//  SettingPsdViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/6.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SettingPsdViewController.h"
#import "UIColor+RGBColor.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"

@interface SettingPsdViewController ()<UITextFieldDelegate>




@end

@implementation SettingPsdViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];

}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSLog(@"show");
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -120, SCREENWIDTH, SCREENHEIGHT + 120);
        
    }];
}
- (void)keyboardDidHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
    }];
    

    NSLog(@"hide");
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneLabel.text = self.phoneNumber;
    self.querenButton.layer.cornerRadius = 20;
    self.querenButton.layer.borderWidth = 1;
    self.querenButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    self.passwordTF.delegate = self;
    self.confirmTF.delegate = self;
    self.passwordTF.borderStyle = UITextBorderStyleNone;
    self.confirmTF.borderStyle = UITextBorderStyleNone;
    self.headImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.info objectForKey:@"headimgurl"]]]];
    
    NSString *nameString = [NSString stringWithFormat:@"微信号:%@", [self.info objectForKey:@"nickname"]];
    self.nameLabel.text =  nameString;
    
    [self createNavigationBarWithTitle:@"设置密码" selecotr:@selector(backClicked:)];
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passwordTF resignFirstResponder];
    [self.confirmTF resignFirstResponder];
    
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

- (IBAction)querenClicked:(id)sender {
    //  http://m.xiaolu.so/rest/v1/users   passwd_set
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/users/passwd_set",Root_URL];
    NSLog(@"string = %@", string);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
  //  NSLog(@"phoneNumber = %@\n", _numberTextField.text);
    NSDictionary *parameters = @{@"password1": self.confirmTF.text,
                                 @"password2":self.passwordTF.text};
    NSLog(@"parameters = %@", parameters);
    if (![self.confirmTF.text isEqualToString:self.passwordTF.text]) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alterView show];
        return;
        
    }
    
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              [self.navigationController popToRootViewControllerAnimated:YES];
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];
    
}
@end
