//
//  ChangeNicknameViewController.m
//  XLMM
//
//  Created by zifei.zhong on 15/11/18.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ChangeNicknameViewController.h"
#import "JMSettingController.h"
#define NICK_LOWER_LIMIT 4
#define NICK_UPPER_LIMIT 20

@interface ChangeNicknameViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    
}

@end

@implementation ChangeNicknameViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ChangeNicknameViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"ChangeNicknameViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"修改昵称" selecotr:@selector(goback)];
    
    self.changeNicknameButton.layer.cornerRadius = 20;
    self.changeNicknameButton.layer.borderWidth = 1;
    self.nicknameField.text = self.nickNameText;
    
    [self disableChangeNicknameButton];
    
}
-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableChangeNicknameButton{
    self.changeNicknameButton.enabled = YES;
    self.changeNicknameButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.changeNicknameButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
}

- (void)disableChangeNicknameButton{
    self.changeNicknameButton.enabled = NO;
    self.changeNicknameButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.changeNicknameButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //NSLog(@"text:%@  leng:%ld  range:%@  string:%@", textField.text,textField.text.length, NSStringFromRange(range), string);

    if ([string isEqualToString:@"\n"] || [string isEqualToString:@" "])
    {
        return NO; // cant input
    }
   // NSLog(@"text:%@  leng:%ld  range:%@  string:%@", textField.text,textField.text.length, NSStringFromRange(range), string);
    // input or delete
    BOOL increase = NO;
    if (textField.text.length == range.location){
        increase = YES;
    }
    
    if (increase && range.location >= NICK_LOWER_LIMIT - 1 && self.changeNicknameButton.enabled == NO) {
        [self enableChangeNicknameButton];
    }
    if (!increase && range.location <= NICK_LOWER_LIMIT - 1 && self.changeNicknameButton.enabled == YES) {
        [self disableChangeNicknameButton];
    }

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.nicknameField == textField)
    {
        if ([toBeString length] > NICK_UPPER_LIMIT) {
            textField.text = [toBeString substringToIndex:NICK_UPPER_LIMIT];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请别超过20个字哦！" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self disableChangeNicknameButton];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeNicknameButtonClick:(id)sender {
    NSString *text = self.nicknameField.text;
    NSUInteger length = text.length;
    if (length <= 0) {
        return;
    }
    [self.nicknameField resignFirstResponder];//seems not working well!
    
    // first: get userId -- future work: this should be stored in local instead.
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users", Root_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (dict.count == 0)return;
    NSDictionary *result = [dict objectForKey:@"results"][0];
    NSString *userId = [result objectForKey:@"id"];
    
    // generate the actual url for changing nickname
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/users/%@", Root_URL, userId];
    NSURL *actualUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:actualUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"PATCH"];
    NSString *str = [NSString stringWithFormat:@"nick=%@", self.nicknameField.text];//设置参数
    
    // create NSMutableURLRequest to add header information
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *value = @"application/x-www-form-urlencoded";
    [mutableRequest addValue:value forHTTPHeaderField:@"Content-Type"];
    request = [mutableRequest copy];
    
    NSData *patchData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:patchData];
    
    // requesting for changing nickname
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received == nil) {
        return;
        
    }
    
   __unused NSDictionary *response = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    NSLog(@"result = %@", response);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nicknameField resignFirstResponder];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self updateNameLabelAndGoBack];
}

-(void) updateNameLabelAndGoBack{
//    JMSettingController *svc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//    svc.nameLabel.text = self.nicknameField.text;
//    svc.nameLabel.textColor = [UIColor orangeThemeColor];
    if (self.blcok) {
        self.blcok(self.nicknameField.text);
    }
    
    //[self performSelector:@selector(goback) withObject:nil afterDelay:2];
    [self.navigationController popViewControllerAnimated:YES];
}
@end






















































