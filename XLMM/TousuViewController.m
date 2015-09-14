//
//  TousuViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TousuViewController.h"

@interface TousuViewController (){
    NSMutableArray *dataArray;
}

@end

@implementation TousuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setInfo];
    //获取投诉意见的内容;
    
    dataArray = [[NSMutableArray alloc] init];
    
    //  http://m.xiaolu.so/rest/v1/complain
    
  

    
    
  //  [self createComplaintLists];
    
    
    
    
    
    
    
    
    
    
    
}

- (void)createComplaintLists{
    NSString *string = @"http://m.xiaolu.so/rest/v1/complain";
    NSURL *url = [NSURL URLWithString:string];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    NSArray *array = [dic objectForKey:@"results"];
    for (NSDictionary *dic in array) {
        NSString *time = [dic objectForKey:@"created_time"];
        NSString *content = [dic objectForKey:@"com_content"];
        NSString *string = [NSString stringWithFormat:@"%@ : %@", time, content];
        [dataArray addObject:string];
    }
    
    while (true) {
        
        NSString *urlString = [dic objectForKey:@"next"];
        
        if ([urlString class] == [NSNull class]) {
            NSLog(@"结束了");
            break;
        }
        NSLog(@"urlStr = %@", urlString);
        NSData *nextData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        dic = [NSJSONSerialization JSONObjectWithData:nextData options:kNilOptions error:nil];
        // NSLog(@"dic = %@", dic);
        NSArray *array = [dic objectForKey:@"results"];
        for (NSDictionary *dic in array) {
            NSString *time = [dic objectForKey:@"created_time"];
            NSString *content = [dic objectForKey:@"com_content"];
            NSString *string = [NSString stringWithFormat:@"%@ : %@", time, content];
            [dataArray addObject:string];
        }
        
        
    }
    
    
    NSMutableString *stringMuabe = [[NSMutableString alloc] init];
    for (NSString *string in dataArray) {
        // NSLog(@"%d. %@", ++i, string);
        NSString *stringnum = [NSString stringWithFormat:@"%@\n", string];
        [stringMuabe appendString:stringnum];
    }
    
    NSLog(@"string = %@", stringMuabe);
    
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    NSLog(@"%@", plistPath1);
    
    //得到完整的文件名
    
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"complain.txt"];
    
    //输入写入
    
    BOOL fl = [stringMuabe writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // BOOL fl = [stringMuabe writeToFile:filename atomically:YES]; //写入
    
    NSLog(@"ls = %d", fl);
}

- (void)setInfo{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"投诉建议";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:26];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 8, 18, 31);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gerenzhongxin.png"]];
    imageView2.frame = CGRectMake(8, 8, 29, 33);
    [button2 addSubview:imageView2];
    [button2 addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    if (length<5 || length>500) {
        self.tipsLabel.text = @"您的意见<5个字符，或>500个字符，请核实后再提交~";
    } else{
        
        NSLog(@"提交投诉意见");
        
        
        
        
        
        
        
        
        self.tipsLabel.text = @"提交成功!谢谢您的反馈，我们将不断完善，给您最好的服务!";
    }
    
}


#pragma mark --UITextFieldDelegate--

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *text = self.tousuTextView.text;
    NSString *string = [NSString stringWithFormat:@"最少输入5个字符，最多输入500个字符，您已输入%lu个字符。", (unsigned long)[text length]];
    self.lengthLabel.text = string;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
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
