//
//  ModifyPhoneController.m
//  XLMM
//
//  Created by younishijie on 15/11/6.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ModifyPhoneController.h"
#import "BoundingNewPhoneController.h"

@interface ModifyPhoneController ()<UITextFieldDelegate>

@end



@implementation ModifyPhoneController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ModifyPhoneController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"ModifyPhoneController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.codeButton.layer.cornerRadius = 16;
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    self.codeTextField.delegate = self;
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self createNavigationBarWithTitle:@"身份验证" selecotr:@selector(backClicked:)];
    self.phoneLabel.text = self.numberString;
    
    
    NSMutableString *mutableString = [self.numberString mutableCopy];
    NSRange range = {3,4};
    [mutableString replaceCharactersInRange:range withString:@"****"];
    self.phoneLabel.text = mutableString;
    NSLog(@"原始绑定手机号码：%@", self.numberString);
    
    
}

- (void)backClicked:(UIButton *)button{
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

- (IBAction)getCodeClicked:(id)sender {
}

- (IBAction)nextClicked:(id)sender {
    BoundingNewPhoneController *boundVC = [[BoundingNewPhoneController alloc] initWithNibName:@"BoundingNewPhoneController" bundle:nil];
    [self.navigationController pushViewController:boundVC animated:YES];
    
}
@end
