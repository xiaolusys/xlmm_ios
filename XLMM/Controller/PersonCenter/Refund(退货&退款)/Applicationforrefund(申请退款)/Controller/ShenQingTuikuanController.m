//
//  ShenQingTuikuanController.m
//  XLMM
//
//  Created by younishijie on 15/11/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ShenQingTuikuanController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JMAppForRefundModel.h"
#import "JMOrderGoodsModel.h"
#import "JMRefundView.h"
#import "JMPopViewAnimationSpring.h"


@interface ShenQingTuikuanController ()<JMRefundViewDelegate,UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>


@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic,strong) JMAppForRefundModel *apprefundModel;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic, strong) JMRefundView *popView;

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
- (void)setDingdanModel:(JMOrderGoodsModel *)dingdanModel {
    _dingdanModel = dingdanModel;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidHiden:) name:UIKeyboardWillHideNotification object:nil];
    [MobClick beginLogPageView:@"ShenQingTuikuanController"];

}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [MobClick endLogPageView:@"ShenQingTuikuanController"];

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
        
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[[self.dingdanModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]]];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 0.5;
    self.myImageView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    number = [self.dingdanModel.num intValue];
    maxNumber = [self.dingdanModel.num intValue];
    
    self.nameLabel.text = self.dingdanModel.title;
    if(number != 0){
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.dingdanModel.total_fee floatValue]/number];
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
    [self createChoiseRefundView];
    
}

- (void)createChoiseRefundView {
    UILabel *nameLabel = [UILabel new];
    [self.choiseRefundWay addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14.];
    nameLabel.textColor = [UIColor buttonTitleColor];
    nameLabel.text = self.refundDic[@"name"];
    
    UILabel *descLabel = [UILabel new];
    [self.choiseRefundWay addSubview:descLabel];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:12.];
    descLabel.textColor = [UIColor dingfanxiangqingColor];
    descLabel.text = self.refundDic[@"desc"];
    
    kWeakSelf
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.choiseRefundWay).offset(10);
        make.left.equalTo(weakSelf.choiseRefundWay).offset(20);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.left.equalTo(nameLabel);
        make.width.mas_equalTo(@(SCREENWIDTH - 40));
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
    reasonView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = NO;
    }completion:^(BOOL finished) {
        

    }];
    
}
- (void)showReasonView{
    reasonView.hidden = NO;
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
    reasonView.hidden = YES;
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
- (IBAction)reduceButtonClicked:(id)sender {
    NSLog(@"减一件");
    if (number-- <= 1) {
        number++;
        return;
    }
    //   http://192.168.1.31:9000/rest/v1/refunds
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
        NSString *string = [responseObject objectForKey:@"apply_fee"];
        refundPrice = [string floatValue];
        self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", refundPrice];
        self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
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
    
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
        NSString *string = [responseObject objectForKey:@"apply_fee"];
        self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", [string floatValue]];
        self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (IBAction)yuanyinClicked:(id)sender {
    
    NSLog(@"选择退款原因");
    
    [self.inputTextView resignFirstResponder];
    
    [self performSelector:@selector(showReasonView) withObject:nil afterDelay:0.3];
    
//    [self showReasonView];
    

    
    
    
    
}

- (void)setRefundDic:(NSDictionary *)refundDic {
    _refundDic = refundDic;

}

- (IBAction)commitClicked:(id)sender {
    [MBProgressHUD showLoading:@"退款处理中....."];
    //budget
    NSString *refundChannel = self.refundDic[@"refund_channel"];
    if ([refundChannel isEqualToString:@"budget"]) {
        [MobClick event:@"refundChannel_budget"];
    }else {
        [MobClick event:@"refundChannel_audit"];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    NSString *descStr;
    descStr = self.inputTextView.text;
    if ([NSString isStringEmpty:self.inputTextView.text]) {
        descStr = @"七天无理由退货";
    }
    NSDictionary *parameters = @{@"id":self.oid,
                                 @"reason":[NSNumber numberWithInt:reasonCode],
                                 @"num":self.refundNumLabel.text,
                                 @"sum_price":[NSNumber numberWithFloat:refundPrice],
                                 @"description":descStr,
                                 @"refund_channel":refundChannel
                                 };
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:parameters WithSuccess:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if (dic.count == 0) return;
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD hideHUD];
            [MobClick event:@"refundChannel_audit_budget_success"];
            [self returnPopView];
        }else {
            [MBProgressHUD showError:dic[@"info"]];
            NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",code]};
            [MobClick event:@"refundChannel_audit_budget_fail" attributes:temp_dict];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"退款失败,请稍后重试."];
    } Progress:^(float progress) {
        
    }];
}

#pragma mark -- 弹出视图
- (void)returnPopView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRefundpopView)]];
    JMRefundView *popView = [JMRefundView defaultPopView];
    self.popView = popView;
    self.popView.titleStr = @"1:极速退款,退款即时到账哦!请注意查收。\n 2:退款请求提交成功，客服会在24小时完成审核，您可以在退款界面查询进展，审核通过后请注意查看钱包余额，谢谢。";
    self.popView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popView];
    [JMPopViewAnimationSpring showView:self.popView overlayView:self.maskView];
}
- (void)composeRefundButton:(JMRefundView *)refundButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hideRefundpopView];
    }else {
        [self hideRefundpopView];
    }
}
/**
 *  隐藏
 */
- (void)hideRefundpopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
    [self.navigationController popViewControllerAnimated:YES];
}

@end




























































