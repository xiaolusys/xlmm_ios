//
//  TuihuoController.m
//  XLMM
//
//  Created by younishijie on 15/9/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TuihuoController.h"
#import "MMClass.h"

@interface TuihuoController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, copy) NSArray *dataArray;


@end

@implementation TuihuoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"申请退货";
    self.myTextView.delegate = self;
    self.myTextField1.delegate = self;
    self.myTextField2.delegate = self;
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
    
    
}

- (void)createPickerView{
    self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 240, 0, 0)];
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
    NSLog(@"wancheng");
    
    
    //判断字数是否满足要求；
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

- (IBAction)commit:(id)sender {
    NSLog(@"commit !");
    
    
    //申请退款 post上传。。。
}

- (IBAction)selectClicked:(id)sender {
    
    NSLog(@"queding");
    [self.myPickerView removeFromSuperview];
    self.myTextField1.userInteractionEnabled = YES;
    
    
}

- (IBAction)querenClicked:(id)sender {
    
    //判断金额是否满足要求。。。
    
    [self.myTextField2 resignFirstResponder];
}
@end
