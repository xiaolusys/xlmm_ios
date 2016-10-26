//
//  JMReturnedGoodsController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMReturnedGoodsController.h"
#import "JMReGoodsAddView.h"
#import "MMClass.h"
#import "JMSelecterButton.h"
#import "JMChooseLogisticsController.h"
#import "JMRefundModel.h"
#import "HCScanQRViewController.h"
#import "SystemFunctions.h"

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

@implementation JMReturnedGoodsController {
    NSString *_expressName;
    NSString *_expressNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"填写快递单" selecotr:@selector(backClicked:)];
    [self createUI];
    [self createRightButonItem];

}
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)createUI {
    kWeakSelf

    UIScrollView *baseScrollV = [[UIScrollView alloc] init];
    [self.view addSubview:baseScrollV];
    self.baseScrollV = baseScrollV;
    self.baseScrollV.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 620);
    self.baseScrollV.scrollEnabled = YES;

    
    JMReGoodsAddView *reGoodsV = [JMReGoodsAddView new];
    [self.baseScrollV addSubview:reGoodsV];
    self.reGoodsV =reGoodsV;
//    NSString *nameStr = self.refundModelr.buyer_nick;
//    NSString *phoneStr = self.refundModelr.mobile;
    NSString *addStr = self.refundModelr.return_address;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:nameStr forKey:@"buyer_nick"];
//    [dict setValue:phoneStr forKey:@"mobile"];
    [dict setValue:addStr forKey:@"return_address"];
    self.reGoodsV.reGoodsDic = dict;
    
    [self.reGoodsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.baseScrollV);
        make.left.equalTo(weakSelf.baseScrollV);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@420);
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
        make.width.mas_equalTo(SCREENWIDTH - 80);
        make.height.mas_equalTo(@60);
    }];
    
    UIButton *erweimaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textTFV addSubview:erweimaButton];
    [erweimaButton addTarget:self action:@selector(erweimaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [erweimaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(textTFV);
        make.width.height.mas_equalTo(@60);
    }];
    UIImageView *buttonImage = [UIImageView new];
    [erweimaButton addSubview:buttonImage];
    buttonImage.image = [UIImage imageNamed:@"mamaeryaoqing"];
    [buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(erweimaButton.mas_centerX);
        make.centerY.equalTo(erweimaButton.mas_centerY).offset(-5);
        make.width.height.mas_equalTo(@31);
    }];
    UILabel *buttonLabel = [UILabel new];
    [erweimaButton addSubview:buttonLabel];
    buttonLabel.text = @"扫一扫";
    buttonLabel.textColor = [UIColor buttonTitleColor];
    buttonLabel.font = [UIFont systemFontOfSize:10.];
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(erweimaButton.mas_centerX);
        make.top.equalTo(buttonImage.mas_bottom);
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
#pragma mark --- 扫描二维码
- (void)erweimaButtonClick:(UIButton *)button {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未获得授权使用摄像头哦~\n去\"设置-隐私-相机\"开启一下吧" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
        scan.showQRCodeInfo = YES;
        //调用此方法来获取二维码信息
        [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
            NSLog(@"%@",QRCodeInfo);
            if ([NSString isStringEmpty:QRCodeInfo]) {
                [MBProgressHUD showError:@"扫描有误,请重试"];
            }else {
                self.expressListTF.text = QRCodeInfo;
            }
            
        }];
        [self.navigationController pushViewController:scan animated:YES];
    }
}
#pragma mark --- 联系客服
- (void)rightClicked:(UIButton *)button {
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",self.refundModelr.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
}

#pragma mark --- 选择物流公司
- (void)choiseClick:(UIButton *)btn {
    [self.expressListTF resignFirstResponder];
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
    _expressName = self.expressL.text;
    _expressNum = self.expressListTF.text;
    
    [self.expressListTF resignFirstResponder];
    NSLog(@"提交。。。。");
    if([_expressName isEqualToString:@"请选择快递公司"]){
        [MBProgressHUD showError:@"请填写快递公司信息"];
        return;
    }
    
    if([[_expressNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [MBProgressHUD showError:@"请填写快递单号信息"];
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
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
            NSDictionary *parameters = @{@"id":self.refundModelr.order_id,
                                         @"modify":@2,
                                         @"company":_expressName,
                                         @"sid":_expressNum
                                         };
            [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:parameters WithSuccess:^(id responseObject) {
                if (!responseObject) {
                    return ;
                }else {
                    NSString *info = responseObject[@"info"];
                    
                    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    alterView.tag = 4321;
                    alterView.delegate = self;
                    [alterView show];
                    
                }
            } WithFail:^(NSError *error) {
                NSLog(@"Error: %@", error);
                NSLog(@"erro = %@\n%@", error.userInfo, error.description);
                [MBProgressHUD showError:@"提交退货快递信息失败，请检查网络后重试！"];
            } Progress:^(float progress) {
                
            }];
        }
        
    }
    if (alertView.tag == 4321) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark ==== 输入框协议方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (!_isPopup) {
    }else {
        _isPopup = NO;
        self.expressBtn.enabled = YES;
        CGPoint center = self.baseScrollV.center;
        center.y += 260;
        self.baseScrollV.center = center;
    }
    
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_isPopup) {
        return;
    }
    _isPopup = YES;
    self.expressBtn.enabled = NO;
    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 620);
    CGPoint center = self.baseScrollV.center;
    center.y -= 260;
    self.baseScrollV.center = center;
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
    self.baseScrollV.contentSize = CGSizeMake(SCREENWIDTH, 620);
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMReturnedGoodsController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"JMReturnedGoodsController"];
}


#pragma mark - 点击隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!_isPopup) {
    }else {
        _isPopup = NO;
        self.expressBtn.enabled = YES;
        CGPoint center = self.baseScrollV.center;
        center.y += 260;
        self.baseScrollV.center = center;
    }

    [self.baseScrollV endEditing:YES];
    NSLog(@"点击了");
}

@end



































