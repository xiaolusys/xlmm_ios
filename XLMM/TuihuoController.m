//
//  TuihuoController.m
//  XLMM
//
//  Created by younishijie on 15/9/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TuihuoController.h"
#import "MMClass.h"
#import "PerDingdanModel.h"
#import "AFNetworking.h"
#import "UIViewController+NavigationBar.h"

@interface TuihuoController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIAlertViewDelegate>{
    UIAlertView *myAlterView;
    NSInteger tuihuoNumber;

}

@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign)NSInteger maxNumber;
@property (nonatomic, assign)NSInteger maxPrice;




@end

@implementation TuihuoController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"申请退货";
    [self createNavigationBarWithTitle:@"申请退货" selecotr:@selector(btnClicked:)];
    self.myTextView.delegate = self;
    self.myTextField1.delegate = self;
    self.myTextField2.delegate = self;
    
    self.myTextField1.borderStyle = UITextBorderStyleNone;
    self.myTextField2.borderStyle = UITextBorderStyleNone;
    self.myTextField2.keyboardType = UIKeyboardTypeNumberPad;
    self.dataArray = @[@"其他",
                       @"错拍",
                       @"缺货",
                       @"开线/脱色/脱毛/有色差/有虫洞",
                       @"发错货/漏发",
                       @"没有发货",
                       @"未收到货",
                       @"与描述不符",
                       @"退运费",
                       @"发票问题",
                       @"七天无理由退换货"
                       ];
    [self.jiabutton setBackgroundImage:[UIImage imageNamed:@"btn-plus.png"] forState:UIControlStateNormal];
    [self.jianbutton setBackgroundImage:[UIImage imageNamed:@"btn-reduce.png"] forState:UIControlStateNormal];

    
    self.maxNumber = [self.dingdanModel.numberString integerValue];
    tuihuoNumber = self.maxNumber;

    
    self.maxPrice = [self.dingdanModel.priceString integerValue] *[self.dingdanModel.numberString integerValue];
    if (self.maxNumber == 1) {
        NSLog(@"只有一件商品");
        self.jianbutton.userInteractionEnabled = NO;
        self.jiabutton.userInteractionEnabled = NO;
    }
    

    self.myImageView.image = [UIImage imagewithURLString:self.dingdanModel.urlString];
    
    self.dingdanjine.text = [NSString stringWithFormat:@"￥%ld",  (long)self.maxPrice];
    self.danjia.text = [NSString stringWithFormat:@"￥%@", self.dingdanModel.priceString];
    self.name.text = self.dingdanModel.nameString;
    self.number.text = [NSString stringWithFormat:@"%@", self.dingdanModel.numberString];
    
    self.sizename.text = [NSString stringWithFormat:@"%@", self.dingdanModel.sizeString];
   
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createPickerView{
    self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 260, 0, 0)];
    self.myPickerView.dataSource = self;
    self.myPickerView.delegate = self;
    
    //self.myPickerView.center = self.view.center;
    //self.myPickerView.
    self.myPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.myPickerView];
    
}

#pragma mark --UITextFieldDelegate--

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.myTextField1) {
        NSLog(@"pickerView");
        
        [self.myTextField2 resignFirstResponder];
        [self createPickerView];

        textField.userInteractionEnabled = NO;
        
        return NO;
    }
    NSLog(@"请输入金额");
    self.myTextField1.userInteractionEnabled = YES;
    [self.myPickerView removeFromSuperview];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myTextField2 resignFirstResponder];
    [self.myTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.myTextField2 resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    NSLog(@"wancheng");
    
    if (textField == self.myTextField2) {
        
        
        NSString *string = textField.text;
        if ([self isAllNum:string]) {
            NSLog(@"输入的都是数字");
        }else{
            NSLog(@"请输入退款金额");
            //self.myTextField2.text = @"";
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"亲，\n~只能输入数字哦~"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定"
                                      ,nil];
            [alterView show];
            
            return;
        }
        NSInteger price = [string integerValue];
        
        if (price > self.maxPrice) {
            NSLog(@"亲，您输入的金额超过最大退款金额");
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"亲，\n~您输入的金额超过最大退款金额~"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定"
                                      ,nil];
            [alterView show];
            //self.myTextField2.text = @"";
            return;
        }
        
        
        NSLog(@"输入金额满足条件");
    }
    //判断字数是否满足要求；
}



#pragma mark --UITextViewDelegate--



- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"");
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark --pickerViewDelegate--

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.myTextField1.text = [self.dataArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    label.text = [self.dataArray objectAtIndex:row];
    self.reasonnumber = row;
    
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
    
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


//       xd15091555f787581f093
- (IBAction)commit:(id)sender {
    NSLog(@"commit !");
    
    if ([self.myTextField1.text isEqual:@""]) {
        NSLog(@"请选择原因");
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请选择原因"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定"
                                  ,nil];
        [alterView show];

        return;
    }
    if ([self.myTextField2.text isEqual:@""]) {
        NSLog(@"亲，您还没有填写退款金额");
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"亲，您还没有填写退款金额"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定"
                                  ,nil];
        [alterView show];
        return;
    }
    if ([self.myTextView.text  isEqual: @"请写下您的审核意见，以便我们更好的为您服务～"] || [self.myTextView.text isEqual:@""]) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请写下您的审核意见，以便我们更好的为您服务～"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定"
                                  ,nil];
        [alterView show];
        return;
    }
    
    //申请退款 post上传。。。
    
    
  myAlterView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"确定要退货吗？"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定"
                              ,nil];
    myAlterView.tag = 88;
    myAlterView.delegate = self;
    
    
    [myAlterView show];

  
    
    
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 88) {
        NSLog(@"88888");
        if (buttonIndex == 0) {
            NSLog(@"0000");
        } else if (buttonIndex == 1)
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
            NSLog(@"urlstring = %@", urlString);
            
            
            if ([self.status isEqual:@"已付款"]) {
                self.refund_or_pro = 0;
                
            } else if ([self.status isEqual:@"已发货"]){
                self.refund_or_pro = 1;
            }
            NSLog(@"1111");
            
            NSDictionary *parameters = @{@"id":self.oid,
                                         @"tid":self.tid,
                                         @"refund_or_pro":[NSNumber numberWithInt:(int)self.refund_or_pro],
                                         @"num":self.number.text,
                                         @"sum_price":self.myTextField2.text,
                                         @"feedback":self.myTextView.text,
                                         @"reason":[NSNumber numberWithInt:(int)self.reasonnumber],
                                         @"modify":@0};
            
            NSLog(@"parameters = %@", parameters);
            
            [manager POST:urlString parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSLog(@"JSON: %@", responseObject);
                      
                      NSDictionary *dic = responseObject;
                      NSString * result = [dic objectForKey:@"res"];
                      if ([result isEqualToString:@"ok"]) {
                          NSLog(@"申请成功了， 恭喜你哦");
                          
                          NSArray *viewControllers = self.navigationController.viewControllers;
                          
                          UIViewController *controller = [viewControllers objectAtIndex:viewControllers.count-3];
                          
                          [self.navigationController popToViewController:controller animated:YES];
                          
                          
                      }
                      NSLog(@"perration = %@", operation);
                      
                  }
             
             // xd15091555f787581f093
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      NSLog(@"Error: %@", error);
                      NSLog(@"erro = %@\n%@", error.userInfo, error.description);
                      NSLog(@"perration = %@", operation);
                      
                      
                  }];
            
        }
    }
}




- (IBAction)jianclicked:(id)sender {
   
    tuihuoNumber--;
    if (tuihuoNumber == 0) {
        tuihuoNumber ++;
    }
    self.number.text = [NSString stringWithFormat:@"%ld", (long)tuihuoNumber];
    
   
    NSLog(@"--");
}

- (IBAction)jiaClicked:(id)sender {
    NSLog(@"++");
    tuihuoNumber ++;
    if (tuihuoNumber == self.maxNumber + 1) {
        tuihuoNumber --;
    }
    self.number.text = [NSString stringWithFormat:@"%ld", (long)tuihuoNumber];


}
@end
