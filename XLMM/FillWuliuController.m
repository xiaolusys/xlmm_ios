//
//  FillWuliuController.m
//  XLMM
//
//  Created by younishijie on 15/11/30.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "FillWuliuController.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"


@interface FillWuliuController ()<UITextFieldDelegate, UIAlertViewDelegate>

@end

@implementation FillWuliuController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"填写物流信息" selecotr:@selector(backClicked:)];
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    [self disableTijiaoButton];
    
}

- (void)enableTijiaoButton{
    self.commitButton.enabled = YES;
    self.commitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

#pragma mark --UITextFieldDelegate--
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.companyTextField == textField) {
        [self.danhaoTextField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.companyTextField.text.length >0 && self.danhaoTextField.text.length > 0) {
        [self enableTijiaoButton];
    } else {
        [self disableTijiaoButton];
        
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.companyTextField resignFirstResponder];
    [self.danhaoTextField resignFirstResponder];
    
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

- (IBAction)commitButtonClicked:(id)sender {
    NSLog(@"提交。。。。");
    
}
@end
