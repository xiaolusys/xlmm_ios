//
//  TousuViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TousuViewController.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "UIViewController+NavigationBar.h"
#define TEXT_LIMIT 80

@interface TousuViewController ()<UIAlertViewDelegate>{
    
}

@end

@implementation TousuViewController

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
    
   // [self setInfo];
    //获取投诉意见的内容;
    [self createNavigationBarWithTitle:@"投诉建议" selecotr:@selector(backBtnClicked:)];
    
    //  http://m.xiaolu.so/rest/v1/complain
    
    self.infoLabel.userInteractionEnabled = NO;
    
    self.tijiaoButton.layer.cornerRadius = 20;
    self.tijiaoButton.layer.borderWidth = 1;
    self.tijiaoButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.tijiaoButton.enabled = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO; //文本输入位置调整。
}


- (void)backBtnClicked:(UIButton *)button{
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

- (IBAction)tijiaoClicked:(id)sender {
    NSString *text = self.tousuTextView.text;
    NSUInteger length = text.length;
    if (length <= 0) {
        return;
    }
    
    NSLog(@"投诉内容：%@", self.tousuTextView.text);
    // com_content 
    //  http://m.xiaolu.so/rest/v1/complain
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/complain", Root_URL];
    NSLog(@"urlString = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = [NSString stringWithFormat:@"com_content=%@", self.tousuTextView.text];//设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    NSLog(@"result = %@", result);
    
    if ([[result objectForKey:@"res"] boolValue]) {
        [self successCommit];

    }
    
//    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str1);
//    if ([str1 isEqualToString:@"\"OK\""]){
//    }
}

- (void)successCommit{
    NSLog(@"提交投诉意见");
    UIAlertView *laterView = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功!\n谢谢您的反馈，我们将不断完善，给您最好的服务!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [laterView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark --UITextFieldDelegate--

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.infoLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0 && self.tijiaoButton.enabled == NO) {
        [self enableTijiaoButton];
    }
    if (textView.text.length <= 0 && self.tijiaoButton.enabled == YES) {
        [self disableTijiaoButton];
    }
    if (textView.text.length > TEXT_LIMIT)
    {
        textView.text = [textView.text substringToIndex:TEXT_LIMIT];
    }
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
    self.countLabel.text = count;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        self.infoLabel.hidden = NO;
    }
}

- (void)enableTijiaoButton{
    self.tijiaoButton.enabled = YES;
    self.tijiaoButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.tijiaoButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.tijiaoButton.enabled = NO;
    self.tijiaoButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.tijiaoButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tousuTextView resignFirstResponder];
}
@end
