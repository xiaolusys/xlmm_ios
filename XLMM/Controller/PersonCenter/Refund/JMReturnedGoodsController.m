//
//  JMReturnedGoodsController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMReturnedGoodsController.h"
#import "JMReGoodsAddView.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "JMChooseLogisticsController.h"
#import "UIViewController+NavigationBar.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "TuihuoModel.h"

@interface JMReturnedGoodsController ()<JMChooseLogisticsControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate> {
    BOOL _isPopup;
}

@property (nonatomic,strong) JMReGoodsAddView *reGoodsV;
/**
 *  滚动视图
 */
@property (nonatomic,strong) UIScrollView *baseScrollV;
/**
 *  快递公司
 */
@property (nonatomic,strong) UIButton *expressBtn;
@property (nonatomic,strong) UILabel *expressL;
@property (nonatomic,strong) UIImageView *expressImageV;
/**
 *  快递单号
 */
@property (nonatomic,strong) UITextField *expressListTF;
/**
 *  确定按钮
 */
@property (nonatomic,strong) UIButton *sureButton;

@end

@implementation JMReturnedGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"填写快递单" selecotr:@selector(backClicked:)];
    [self createUI];
    
    //注册键盘的通知
    [self monitorKeyboard];
}
- (void)createUI {
    kWeakSelf
    
    UIScrollView *baseScrollV = [[UIScrollView alloc] init];
    [self.view addSubview:baseScrollV];
    self.baseScrollV = baseScrollV;
    self.baseScrollV.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 580);
    self.baseScrollV.scrollEnabled = YES;

    
    JMReGoodsAddView *reGoodsV = [JMReGoodsAddView new];
    [self.baseScrollV addSubview:reGoodsV];
    self.reGoodsV =reGoodsV;
    NSString *nameStr = self.model.buyer_nick;
    NSString *phoneStr = self.model.mobile;
    NSString *addStr = self.model.return_address;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:nameStr forKey:@"buyer_nick"];
    [dict setValue:phoneStr forKey:@"mobile"];
    [dict setValue:addStr forKey:@"return_address"];
    self.reGoodsV.reGoodsDic = dict;
    
    [self.reGoodsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.baseScrollV);
        make.left.equalTo(weakSelf.baseScrollV);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@380);
    }];
    
    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baseScrollV addSubview:expressBtn];
    self.expressBtn = expressBtn;
    [self.expressBtn addTarget:self action:@selector(choiseClick:) forControlEvents:UIControlEventTouchUpInside];
    self.expressBtn.backgroundColor = [UIColor whiteColor];
    
    [self.expressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.reGoodsV.mas_bottom);
        make.left.equalTo(weakSelf.baseScrollV);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    UILabel *expressL = [UILabel new];
    [self.expressBtn addSubview:expressL];
    self.expressL = expressL;
    self.expressL.text = @"请选择快递公司";
    self.expressL.textColor = [UIColor titleDarkGrayColor];
    
    [self.expressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.expressBtn.mas_centerY);
        make.left.equalTo(weakSelf.expressBtn).offset(15);
    }];
    
    UIImageView *expressImageV = [UIImageView new];
    [self.expressBtn addSubview:expressImageV];
    self.expressImageV = expressImageV;
    self.expressImageV.image = [UIImage imageNamed:@"rightArrow"];
    
    [self.expressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.expressBtn.mas_centerY);
        make.right.equalTo(weakSelf.expressBtn).offset(-15);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@20);
    }];
    
    UIView *textTFV = [UIView new];
    [self.baseScrollV addSubview:textTFV];
    textTFV.backgroundColor = [UIColor whiteColor];
    
    [textTFV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expressBtn.mas_bottom);
        make.left.equalTo(weakSelf.baseScrollV);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    
    UITextField *expressListTF = [UITextField new];
    [textTFV addSubview:expressListTF];
    self.expressListTF = expressListTF;
    self.expressListTF.placeholder = @"点击输入快递单号";
    self.expressListTF.textColor = [UIColor titleDarkGrayColor];
    self.expressListTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.expressListTF.keyboardType = UIKeyboardTypeDefault;
    self.expressListTF.delegate = self;
    
    [self.expressListTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textTFV);
        make.left.equalTo(textTFV).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@60);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baseScrollV addSubview:sureButton];
    self.sureButton = sureButton;
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expressListTF.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.baseScrollV).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@40);
//        make.bottom.equalTo(weakSelf.baseScrollV.mas_bottom).offset(-20);
    }];
    
    
//    self.baseScrollV.contentOffset = CGPointMake(0, 118);

    
}
#pragma mark --- 选择物流公司
- (void)choiseClick:(UIButton *)btn {
    JMChooseLogisticsController *logisticsVC = [[JMChooseLogisticsController alloc] init];
    logisticsVC.delegate = self;
    [self.navigationController pushViewController:logisticsVC animated:YES];
}
- (void)ClickChoiseLogis:(JMChooseLogisticsController *)click Title:(NSString *)title {
    self.expressL.textColor = [UIColor blackColor];
    self.expressL.text = title;
}
#pragma mark --- 提交按钮点击
- (void)sureButtonClick:(UIButton *)btn {
    NSLog(@"提交。。。。");
    if([self.expressL.text isEqualToString:@"请选择快递公司"]){
        [SVProgressHUD showErrorWithStatus:@"请填写快递公司信息"];
        return;
    }
    
    if([[self.expressListTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请填写快递单号信息"];
        return;
    }
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alterView.tag = 1234;
    [alterView show];
    
    

//    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1234) {
        if (buttonIndex == 1) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
            NSLog(@"urlstring = %@", urlString);
            
            
            
            NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%ld", (long)self.model.order_id],
                                         @"modify":@2,
                                         @"company":self.expressL.text,
                                         @"sid":self.expressListTF.text
                                         };
            
            NSLog(@"parameters = %@", parameters);
            
            [manager POST:urlString parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSLog(@"JSON: %@", responseObject);
                      UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"退货成功，去看看其他商品吧！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                      alterView.tag = 4321;
                      alterView.delegate = self;
                      [alterView show];
                      //                      [self.navigationController popToRootViewControllerAnimated:YES];
                      //                      NSLog(@"perration = %@", operation);
                      //                      [self.navigationController popViewControllerAnimated:YES];
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      NSLog(@"erro = %@\n%@", error.userInfo, error.description);
                      NSLog(@"perration = %@", operation);
                      [SVProgressHUD showErrorWithStatus:@"退货失败，请检查网络后重试！"];
                  }];
        }
        
    }
    
    if (alertView.tag == 4321) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

#pragma mark - 监听键盘

- (void)monitorKeyboard
{
    //添加监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //添加监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification
{
    if (_isPopup) {
        return;
    }
    _isPopup = YES;
    self.expressBtn.enabled = NO;
    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 580);
    NSValue *frameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [frameValue CGRectValue];
    CGFloat height = frame.size.height;
    CGPoint center = self.baseScrollV.center;
    center.y -= height;
    self.baseScrollV.center = center;

}

- (void)keyboardHide:(NSNotification *)notification
{
    if (!_isPopup) {
        return;
    }
    _isPopup = NO;
    self.expressBtn.enabled = YES;

    NSValue *frameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [frameValue CGRectValue];
    CGFloat height = frame.size.height;
    
    CGPoint center = self.baseScrollV.center;
    center.y += height;
    self.baseScrollV.center = center;


}

#pragma mark ==== 输入框协议方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    self.expressListTF = textField;
//    if ([textField.text isEqualToString:@""]) {
//        CGRect frame = CGRectMake(0, self.baseScrollV.contentSize.height - 216, self.baseScrollV.frame.size.width, 216);
//        textField.frame = frame;
//    }
    [textField becomeFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.expressListTF.text.length >0) {
        self.sureButton.enabled = YES;
    }else {
        self.sureButton.enabled = NO;
    }
}
- (void)viewDidLayoutSubviews {
    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 580);
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 580);
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 580);
//}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 点击隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    [self.expressListTF resignFirstResponder];
    [self.baseScrollV endEditing:YES];
    NSLog(@"点击了");
}

@end









































