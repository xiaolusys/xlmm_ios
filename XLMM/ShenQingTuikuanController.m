//
//  ShenQingTuikuanController.m
//  XLMM
//
//  Created by younishijie on 15/11/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ShenQingTuikuanController.h"
#import "UIViewController+NavigationBar.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIColor+RGBColor.h"
#import "AFNetworking.h"
#import "MMClass.h"




@interface ShenQingTuikuanController ()<UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

{
    
}

@property (nonatomic, strong) NSArray *dataArray;

@end



@implementation ShenQingTuikuanController{
    int number;
    int maxNumber;
    
    int reasonCode;
    float refundPrice;
    
    UIView *backView;
    UIView *reasonView;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHiden:) name:UIKeyboardDidHideNotification object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    
}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSLog(@"show");
    [UIView animateWithDuration:0.3 animations:^{
    self.view.frame = CGRectMake(0, -120, SCREENWIDTH, 120 + SCREENHEIGHT);
    
    }];
}
- (void)keyboardDidHiden:(NSNotification *)notification{

    NSLog(@"hiden");
    [UIView animateWithDuration:0.3 animations:^{

        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);

    }];
    

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
    
    [self createNavigationBarWithTitle:@"申请退款" selecotr:@selector(backClicked:)];
    
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[self.dingdanModel.urlString URLEncodedString]]];
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 0.5;
    self.myImageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
    number = [self.dingdanModel.numberString intValue];
    maxNumber = [self.dingdanModel.numberString intValue];
    
    
    self.nameLabel.text = self.dingdanModel.nameString;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",[self.dingdanModel.priceString floatValue]];
    self.sizeNameLabel.text = self.dingdanModel.sizeString;
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", self.dingdanModel.numberString];
    
    self.refundPriceLabel.text = [NSString stringWithFormat:@"¥%.02f", [self.dingdanModel.priceString floatValue]];
    refundPrice = [self.dingdanModel.priceString floatValue];
    self.refundNumLabel.text = [NSString stringWithFormat:@"%i", maxNumber];
    
    self.selectedReason.layer.cornerRadius = 4;
    self.selectedReason.layer.borderWidth = 0.5;
    self.selectedReason.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
    self.inputTextView.layer.cornerRadius = 4;
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
    
    self.inputTextView.clearsContextBeforeDrawing = YES;
 
    
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    //[self.view addSubview:self.buttonView];
    
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    backView.hidden = YES;
    
    //[self.view bringSubviewToFront:backView];
    
    NSLog(@"self.view = %@", self.view.subviews);
    
    [self loadReasonView];
    [self hiddenReasonView];
    
}

- (void)hiddenReasonView{
    backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    }];
    
}
- (void)showReasonView{
    backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH);
        
    }];
}
- (void)loadReasonView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SelectedReasonsView" owner:nil options:nil];
    
    reasonView = [views objectAtIndex:0];
    
    UIButton *cancelButton = (UIButton *)[reasonView viewWithTag:200];
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    [cancelButton addTarget:self action:@selector(cancelSeleted:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *listView = (UIView *)[reasonView viewWithTag:100];
    
    listView.layer.masksToBounds = YES;
    listView.layer.cornerRadius = 20;
    
    
    reasonView.frame = self.view.frame;
    [self.view addSubview:reasonView];
    
}

- (void)cancelSeleted:(UIButton *)button{
    NSLog(@"取消选择");
    [self hiddenReasonView];
    
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

- (IBAction)reduceButtonClicked:(id)sender {
    NSLog(@"减一件");
    if (number-- <= 1) {
        number++;
        return;
    }
    
    //   http://192.168.1.31:9000/rest/v1/refunds
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSString *string = [responseObject objectForKey:@"apply_fee"];
              refundPrice = [string floatValue];
              self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", refundPrice];
              self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];
    
    
}

#pragma mark --TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
   // textView.text = @" ";
    self.infoLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        self.infoLabel.hidden = NO;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    //return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.inputTextView resignFirstResponder];
    
}
- (IBAction)addBtnClicked:(id)sender {
  
    if (number++ > maxNumber - 1) {
        number--;
        return;
    }
    
    //   http://192.168.1.31:9000/rest/v1/refunds
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSString *string = [responseObject objectForKey:@"apply_fee"];
              self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", [string floatValue]];
              self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

}
- (IBAction)yuanyinClicked:(id)sender {
    
    NSLog(@"选择退款原因");
    
    [self showReasonView];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_dataArray[1],_dataArray[2],_dataArray[3],_dataArray[4],_dataArray[5],_dataArray[6],_dataArray[7],_dataArray[8],_dataArray[9],_dataArray[10],_dataArray[0], nil];
//    actionSheet.tag = 200;
//    
//  
//    
//    
//    [actionSheet showInView:self.view];
    
    
    
    
}

#pragma mark actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"选择");
    switch (buttonIndex) {
        case 1:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 2;
            break;
        case 2:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 3;
            break;
        case 3:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 4;
            break;
        case 4:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            
            reasonCode = 5;
            break;
        case 5:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 6;
            break;
        case 6:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 7;
            break;
        case 7:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 8;
            break;
        case 8:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 9;
            break;
        case 9:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 10;
            break;
        case 10:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 0;
            break;
        case 0:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);
            reasonCode = 1;
            break;
      
            
    
            
        default:
            NSLog(@"buttonIndex = %ld", (long)buttonIndex);

            break;
    }
    self.reasonLabel.text = self.dataArray[reasonCode];
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    NSLog(@"取消");
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet addSubview:[[UIView alloc] initWithFrame:actionSheet.frame]];
   
    NSLog(@"%ld", actionSheet.subviews.count);
    NSLog(@"%@", actionSheet);
    for (UIView *subViwe in actionSheet.subviews) {
        NSLog(@"%@", subViwe);
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)commitClicked:(id)sender {
    
    NSLog(@"提交");
    
   UIAlertView * myAlterView = [[UIAlertView alloc] initWithTitle:nil
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
        if (buttonIndex == 0) {
            NSLog(@"0000");
        } else if (buttonIndex == 1)
        {
            //  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
            NSLog(@"urlstring = %@", urlString);
            
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //第二步，创建请求
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            
            [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
            
            //     NSDictionary *parameters = @{@"id":self.oid,
            //                                         @"reason":[NSNumber numberWithInt:(int)self.reasonnumber],
            //                                         @"num":self.number.text,
            //                                         @"sum_price":self.myTextField2.text,
            //                                         @"description":self.myTextView.text
            //                                         };
            //[NSString stringWithFormat:@"",]
            NSString *descStr;
            if ([self.inputTextView.text isEqualToString:@""]) {
                descStr = @"七天无理由退货";
                
            }
            NSString *str =[NSString stringWithFormat:@"id=%@&reason=%@&num=%@&sum_price=%@&description=%@",self.oid, [NSNumber numberWithInt:reasonCode], self.refundNumLabel.text, [NSNumber numberWithFloat:refundPrice], descStr];//设置参数
            NSLog(@"params = %@", str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:data];
            
            //第三步，连接服务器
            
            
            
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", error);
            } else{
                NSLog(@"dic = %@", dic);
            }
            
            
            if ([[dic objectForKey:@"res"] isEqualToString:@"ok"]) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
            
            
            
            NSLog(@"000000%@",str1);
        }
        
    }
}
@end
