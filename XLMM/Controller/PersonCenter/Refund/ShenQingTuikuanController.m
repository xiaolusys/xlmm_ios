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


#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MJExtension.h"
#import "JMAppForRefundModel.h"
#import "JMAppRefundView.h"
#import "UIView+RGSize.h"


@interface ShenQingTuikuanController ()<UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate,JMAppRefundViewDelegate>

{
    
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic,strong) JMAppForRefundModel *apprefundModel;

@property (nonatomic,strong) JMAppRefundView *appRefundView;

@property (nonatomic,strong) UIView *maskView;

@end



@implementation ShenQingTuikuanController{
    int number;
    int maxNumber;
    
    int reasonCode;
    float refundPrice;
    
    UIView *reasonView;
    
    
    UIVisualEffectView *effectView;
    
}
- (JMAppForRefundModel *)apprefundModel {
    if (_apprefundModel) {
        _apprefundModel = [[JMAppForRefundModel alloc] init];
    }
    return _apprefundModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHiden:) name:UIKeyboardWillHideNotification object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    
}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSLog(@"show");
    [UIView animateWithDuration:0.3 animations:^{
    self.view.frame = CGRectMake(0, -120, SCREENWIDTH, 120 + SCREENHEIGHT);
    
    }];
}
- (void)keyboardDidHiden:(NSNotification *)notification{

    NSLog(@"hiden");
    [UIView animateWithDuration:0 animations:^{

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
    
    self.dataArray = @[
                       @"错拍",//1
                       @"缺货",
                       @"商品质量问题",//3
                       @"发错货/漏发",//4
                       @"没有发货",//5
                       @"未收到货",//6
                       @"与描述不符",//7
                       @"退运费",//8
                       @"发票问题",
                       @"七天无理由退换货",//10
                       @"其他"//0
                       ];
    
    [self createNavigationBarWithTitle:@"申请退款" selecotr:@selector(backClicked:)];
        
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[self.dingdanModel.pic_path URLEncodedString]]];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 0.5;
    self.myImageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    number = [self.dingdanModel.num intValue];
    maxNumber = [self.dingdanModel.num intValue];
    
    
    self.nameLabel.text = self.dingdanModel.title;
    if(number != 0){
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",[self.dingdanModel.total_fee floatValue]/number];
    }
    self.sizeNameLabel.text = self.dingdanModel.sku_name;
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", self.dingdanModel.num];
    
    self.refundPriceLabel.text = [NSString stringWithFormat:@"¥%.02f", [self.dingdanModel.payment floatValue]];
    refundPrice = [self.dingdanModel.payment floatValue];
    self.refundNumLabel.text = [NSString stringWithFormat:@"%i", maxNumber];
    
    self.selectedReason.layer.cornerRadius = 4;
    self.selectedReason.layer.borderWidth = 0.5;
    self.selectedReason.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.inputTextView.layer.cornerRadius = 4;
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    
    self.inputTextView.clearsContextBeforeDrawing = YES;
 
    
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    //[self.view addSubview:self.buttonView];
    
    

    
    //[self.view bringSubviewToFront:backView];
    
    NSLog(@"self.view = %@", self.view.subviews);
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:2];
    //  毛玻璃view 视图
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:effectView];
    //设置模糊透明度
    effectView.alpha = 1.0f;
    
    [self loadReasonView];
    [self disableTijiaoButton];
    [self loadData];
    [self createRefundUI];
 
    
    
}
/**
 *  创建退款弹出视图
 */
- (void)createRefundUI {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)]];
    
    JMAppRefundView *appRefundView = [[JMAppRefundView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 180, SCREENWIDTH, 180)];
    self.appRefundView = appRefundView;
    self.appRefundView.delegate = self;
    
}
/**
 *  显示
 */
- (void)createPayPopView {
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.appRefundView];
    self.maskView.alpha = 0;
    self.appRefundView.top = self.view.height - 150;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.appRefundView.bottom = self.view.height;
    }];
}
/**
 *  隐藏
 */
- (void)hidePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.appRefundView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.appRefundView removeFromSuperview];
    }];
}
- (void)composeRefundButton:(JMAppRefundView *)refundButton didClick:(NSInteger)index {
//    else if (index == 101) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
        NSString *descStr;
        descStr = self.inputTextView    .text;
        
        if ([self.inputTextView.text isEqualToString:@""]) {
            descStr = @"七天无理由退货";
        }
    NSInteger count = index - 101;
        JMAppForRefundModel *mmodel = self.dataSource[count];
        NSDictionary *parameters = @{@"id":self.oid,
                                     @"reason":[NSNumber numberWithInt:reasonCode],
                                     @"num":self.refundNumLabel.text,
                                     @"sum_price":[NSNumber numberWithFloat:refundPrice],
                                     @"description":descStr,
                                     @"refund_channel":mmodel.refund_channel,
                                     };
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            if (dic.count == 0) return;
            if ([[dic objectForKey:@"res"] isEqualToString:@"ok"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [self hidePickerView];
//    }
    
    if (index == 100) {
        // 返回按钮 -- 放弃退款
        [self payBackAlter];
    }
    
}
/**
 *  选择退款--请求退款方式
 */
- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v2/trades/?trade_id=%@",Root_URL,self.oid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            return ;
        }
        NSArray *dataArr = responseObject[@"extras"];
        for (NSDictionary *dict in dataArr) {
            self.apprefundModel = [JMAppForRefundModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:self.apprefundModel];
        }
        self.appRefundView.payMentArr = self.dataSource;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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

- (void)hiddenReasonView{
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = NO;
    }completion:^(BOOL finished) {
        

    }];
    
}
- (void)showReasonView{
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        effectView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = YES;
        
    }completion:^(BOOL finished) {

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
    listView.layer.cornerRadius = 10;
    
 
    UIScrollView *scrollView = (UIScrollView *)[reasonView viewWithTag:886];
    scrollView.contentOffset = CGPointMake(0, -150);
   // scrollView.bounces = NO;
   // scrollView.showsVerticalScrollIndicator = NO;
    reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    reasonView.alpha = 0.9;
    [self.view addSubview:reasonView];
    
    
    
  //  UIButton *button0 = (UIButton *)[reasonView viewWithTag:800];
    for (int i = 0; i < 11; i++) {
        UIButton *button = (UIButton *)[reasonView viewWithTag:800 + i];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateHighlighted];

        button.showsTouchWhenHighlighted = NO;
      //  button.highlighted = NO;
        [button addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"uibuton = %@", button);
        
    }
    
    
    
    
}



- (void)selectReason:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
  
    self.reasonLabel.text = self.dataArray[button.tag - 800];
    int num = (int)button.tag - 800+1;
    reasonCode = num %11;
    
    NSLog(@"reason Code = %d", reasonCode);
    [self hiddenReasonView];
    [self enableTijiaoButton];
    
    
    
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
    
    [self.inputTextView resignFirstResponder];
    
    [self performSelector:@selector(showReasonView) withObject:nil afterDelay:0.3];
    
//    [self showReasonView];
    

    
    
    
    
}



- (IBAction)commitClicked:(id)sender {
    
    
    [self createPayPopView];
    
    
    
    
    
    
    
    
    
    NSLog(@"提交");
    
//   UIAlertView * myAlterView = [[UIAlertView alloc] initWithTitle:nil
//                                             message:@"确定要退货吗？"
//                                            delegate:nil
//                                   cancelButtonTitle:@"取消"
//                                   otherButtonTitles:@"确定"
//                   ,nil];
//    myAlterView.tag = 88;
//    myAlterView.delegate = self;
//    
//    
//    [myAlterView show];
}

/**
 *      if (alertView.tag != 88) return;
 if (buttonIndex == 1){
 NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
 NSString *descStr;
 descStr = self.inputTextView.text;
 
 if ([self.inputTextView.text isEqualToString:@""]) {
 descStr = @"七天无理由退货";
 }
 NSDictionary *parameters = @{@"id":self.oid,
 @"reason":[NSNumber numberWithInt:reasonCode],
 @"num":self.refundNumLabel.text,
 @"sum_price":[NSNumber numberWithFloat:refundPrice],
 @"description":descStr,
 };
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSDictionary *dic = responseObject;
 if (dic.count == 0) return;
 if ([[dic objectForKey:@"res"] isEqualToString:@"ok"]) {
 [self.navigationController popViewControllerAnimated:YES];
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 }];
 }else
 *
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 666) {
        if (buttonIndex == 0) {
            [alertView setHidden:YES];
            [self hidePickerView];
            [self.navigationController popViewControllerAnimated:YES];
        }}else {
            [alertView setHidden:YES];
        }
}

#pragma mark ---- 点击返回按钮 弹出警告框 --> 选择放弃或者继续
- (void)payBackAlter {
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"是否放弃退款" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alterView.tag = 666;
    [alterView show];
}

@end
