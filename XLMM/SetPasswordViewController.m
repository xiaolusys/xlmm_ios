//
//  SetPasswordViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/18.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "UIViewController+NavigationBar.h"
#import "AFNetworking.h"
#import "MMClass.h"


@interface SetPasswordViewController()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isAgreementChecked;
@end

@implementation SetPasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:self.config[@"title"] selecotr:@selector(backClicked:)];
    if (![self.config[@"isRegister"] boolValue]) {
        self.checkButton.hidden = YES;
        self.agreementButton.hidden = YES;
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
    self.commitButton.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor colorWithR:227 G:227 B:227 alpha:1];
    self.commitButton.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
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
    NSLog(@"注册");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *phoneNumber = self.phoneString;
    NSString *validCode = self.codeString;
    NSString *password1 = self.passwordTextField.text;
    NSString *password2 = self.confirmTextField.text;

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


              //修改密码成功，要怎么做。。。。
              


          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {

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


@end
