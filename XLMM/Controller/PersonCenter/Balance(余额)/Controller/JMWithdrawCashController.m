//
//  JMWithdrawCashController.m
//  XLMM
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWithdrawCashController.h"
#import "TixianSucceedViewController.h"
#import "JMSelecterButton.h"

#define COUNTING_LIMIT 60


@interface JMWithdrawCashController ()<UITextFieldDelegate> {
    NSDictionary *_userBudget;
    CGFloat _withDrawMoney;
    CGFloat _textFieldMoney;
    CGFloat _minWithDrawMoney;      // 最小提现金额
    CGFloat _maxWithDrawMoney;      // 最大提现金额
    NSString *phoneNumber;
    BOOL isUserEnable;
    BOOL isUserEnableAuth;
}


@property (nonatomic, strong) UILabel *myBlanceLabel;

@property (nonatomic, strong) UIButton *withdrawButton;

@property (nonatomic, strong) UITextField *moneyTextF;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *sureWithdrawButton;

@property (nonatomic, strong) UILabel *descTitleLabel;

@property (nonatomic,strong) UITextField *authcodeTextF;

@property (nonatomic,strong) JMSelecterButton *selButton;

@end

@implementation JMWithdrawCashController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClick:)];
    isUserEnable = NO;
    _maxWithDrawMoney = 200.00;
    [self createWtihdrawView];
    
    if (self.isMaMaWithDraw) {
        [self loadCashoutPolicyData];
    }
    
}
- (void)setPersonCenterDict:(NSDictionary *)personCenterDict {
    _personCenterDict = personCenterDict;
    phoneNumber = personCenterDict[@"mobile"];
    if ([personCenterDict isKindOfClass:[NSDictionary class]] && [personCenterDict objectForKey:@"user_budget"]) {
        _userBudget = personCenterDict[@"user_budget"];
        if ([_userBudget isKindOfClass:[NSDictionary class]] && [_userBudget objectForKey:@"cash_out_limit"]) {
            _minWithDrawMoney = [_userBudget[@"cash_out_limit"] floatValue];
        }else {
            _minWithDrawMoney = 8.88;
        }
    }else {
        _minWithDrawMoney = 8.88;
    }
}

- (void)loadCashoutPolicyData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/cashout_policy",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        
        _minWithDrawMoney = [responseObject[@"min_cashout_amount"] floatValue];
        _maxWithDrawMoney = [responseObject[@"audit_cashout_amount"] floatValue];
        self.descTitleLabel.text = responseObject[@"message"];
        self.myBlanceLabel.text = CS_FLOAT(self.myBlabce);
        _withDrawMoney = self.myBlabce;
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)createWtihdrawView {
    
    UIView *firstView = [UIView new];
    [self.view addSubview:firstView];
    firstView.backgroundColor = [UIColor whiteColor];
    
    UIView *twoView = [UIView new];
    [self.view addSubview:twoView];
    twoView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    
    UIView *threeView = [UIView new];
    [self.view addSubview:threeView];
    threeView.backgroundColor = [UIColor whiteColor];
    
    UIView *authCodeView = [UIView new];
    [self.view addSubview:authCodeView];
    authCodeView.backgroundColor = [UIColor whiteColor];
    
    UILabel *myBlanceLabel = [UILabel new];
    [firstView addSubview:myBlanceLabel];
    self.myBlanceLabel = myBlanceLabel;
    self.myBlanceLabel.textColor = [UIColor dingfanxiangqingColor];
    self.myBlanceLabel.font = [UIFont systemFontOfSize:12.];
    CGFloat budgerCash = [_userBudget[@"budget_cash"] floatValue];
    self.myBlanceLabel.text = [NSString stringWithFormat:@"%.2f",budgerCash];
    _withDrawMoney = budgerCash;

    
    UIButton *withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstView addSubview:withdrawButton];
    self.withdrawButton = withdrawButton;
    [self.withdrawButton setImage:[UIImage imageNamed:@"circle_wallet_Normal"] forState:UIControlStateNormal];
    [self.withdrawButton setImage:[UIImage imageNamed:@"circle_wallet_Selected"] forState:UIControlStateSelected];
    [self.withdrawButton setTitle:@"全部提现" forState:UIControlStateNormal];
    self.withdrawButton.titleLabel.font = [UIFont systemFontOfSize:13.];
    [self.withdrawButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    self.withdrawButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.withdrawButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    [self.withdrawButton addTarget:self action:@selector(withDrawClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *moneyTextF = [UITextField new];
    [twoView addSubview:moneyTextF];
    self.moneyTextF = moneyTextF;
    self.moneyTextF.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTextF.leftViewMode = UITextFieldViewModeAlways;
    self.moneyTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.moneyTextF.font = [UIFont systemFontOfSize:14.];
    self.moneyTextF.placeholder = @"请输入提现金额";
    self.moneyTextF.delegate = self;
    
    
    UILabel *nameLabel = [UILabel new];
    [threeView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.text = self.personCenterDict[@"nick"];
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    self.nameLabel.font = [UIFont systemFontOfSize:13.];
    
    UILabel *descTitleLabel = [UILabel new];
    [self.view addSubview:descTitleLabel];
    self.descTitleLabel = descTitleLabel;
//    self.descTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.descTitleLabel.textColor = [UIColor timeLabelColor];
    self.descTitleLabel.font = [UIFont systemFontOfSize:12.];
    self.descTitleLabel.numberOfLines = 0;
    if ([_userBudget[@"is_cash_out"] integerValue] == 1) {
        self.descTitleLabel.text = [NSString stringWithFormat:@"提现金额将以微信红包形式，24小时内发至你绑定的微信账户  \n\n提现说明:默认最低提现金额为8.88元，根据推广活动会调整此最低提现金额，目前最低提现金额为%.2f元。不提现时零钱可以购物消费。",_minWithDrawMoney];
    }else {
        self.descTitleLabel.text = @"暂时不可提现,如有疑问,请询问小鹿客服哦~!";
    }
    
    
    UIButton *sureWithdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sureWithdrawButton];
    self.sureWithdrawButton = sureWithdrawButton;
    [self.sureWithdrawButton setTitle:@"确认提现" forState:UIControlStateNormal];
    self.sureWithdrawButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.sureWithdrawButton.layer.cornerRadius = 20.;
    [self.sureWithdrawButton addTarget:self action:@selector(withdrawSureButton:) forControlEvents:UIControlEventTouchUpInside];
    
    kWeakSelf
    
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];

    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@20);
    }];
    
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    
    [authCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    
    
    UILabel *blanceL = [UILabel new];
    [firstView addSubview:blanceL];
    blanceL.text = @"我的零钱:";
    blanceL.textColor = [UIColor buttonTitleColor];
    blanceL.font = [UIFont systemFontOfSize:13.];
    [blanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    [self.myBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blanceL.mas_right).offset(10);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    
    [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.centerY.equalTo(firstView.mas_centerY);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@40);
    }];
    
    UILabel *moneyL = [UILabel new];
    [twoView addSubview:moneyL];
    moneyL.textColor = [UIColor buttonTitleColor];
    moneyL.font = [UIFont systemFontOfSize:13.];
    moneyL.text = @"金额(元):";
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.centerY.equalTo(twoView.mas_centerY);
    }];
    
    [self.moneyTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyL.mas_right).offset(10);
        make.centerY.equalTo(twoView.mas_centerY);
        make.width.mas_equalTo(SCREENWIDTH - 80);
    }];
    
    UITextField *authcodeTextF = [UITextField new];
    [authCodeView addSubview:authcodeTextF];
    self.authcodeTextF = authcodeTextF;
    self.authcodeTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.authcodeTextF.leftViewMode = UITextFieldViewModeAlways;
    self.authcodeTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.authcodeTextF.font = [UIFont systemFontOfSize:14.];
    self.authcodeTextF.placeholder = @"请输入短信验证码";
    self.authcodeTextF.delegate = self;
    
    self.selButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [authCodeView addSubview:self.selButton];
    [_selButton setNomalBorderColor:[UIColor buttonDisabledBorderColor] TitleColor:[UIColor buttonDisabledBackgroundColor] Title:@"获取验证码" TitleFont:13. CornerRadius:15.];
    self.selButton.selected = NO;
    self.selButton.enabled = NO;
    [_selButton addTarget:self action:@selector(getAuthcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.authcodeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(authCodeView).offset(15);
        make.right.equalTo(weakSelf.selButton.mas_left).offset(-15);
        make.centerY.equalTo(authCodeView.mas_centerY);
    }];
    
    [self.selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(authCodeView.mas_centerY);
        make.right.equalTo(authCodeView).offset(-10);
        make.width.mas_equalTo(@87);
        make.height.mas_equalTo(@32);
    }];
    
    
    UIImageView *weXinImage = [UIImageView new];
    [threeView addSubview:weXinImage];
    weXinImage.image = [UIImage imageNamed:@"wallet_weixin"];
    UILabel *wtihToL = [UILabel new];
    [threeView addSubview:wtihToL];
    wtihToL.text = @"提现至微信红包";
    wtihToL.textColor = [UIColor dingfanxiangqingColor];
    wtihToL.font = [UIFont systemFontOfSize:13.];
    
    [weXinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeView).offset(10);
        make.centerY.equalTo(threeView.mas_centerY);
        make.width.mas_equalTo(@22);
        make.height.mas_equalTo(@20);
    }];
    [wtihToL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weXinImage.mas_right).offset(10);
        make.centerY.equalTo(threeView.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.centerY.equalTo(threeView.mas_centerY);
    }];
    
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authCodeView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view).offset(30);
        make.width.mas_equalTo(SCREENWIDTH - 60);
    }];
    
    [self.sureWithdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.descTitleLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(@40);
    }];
    
}

- (void)withDrawClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        if (_maxWithDrawMoney - _withDrawMoney > 0.00001) {
            self.moneyTextF.text = [NSString stringWithFormat:@"%.2f",_withDrawMoney];
        }else {
            self.moneyTextF.text = [NSString stringWithFormat:@"%.2f",_maxWithDrawMoney];
        }
        self.selButton.enabled = YES;
        self.selButton.selected = YES;
        isUserEnable = YES;
    }else {
        self.moneyTextF.text = @"";
        self.selButton.enabled = NO;
        self.selButton.selected = NO;
        isUserEnable = NO;
    }
    if (self.authcodeTextF.text.length == 0) {
        isUserEnableAuth = NO;
    }else {
        isUserEnableAuth = YES;
    }
    if (isUserEnable && isUserEnableAuth) {
        [self rightDrawCashBtn:YES];
    }else {
        [self rightDrawCashBtn:NO];
    }
    
}
- (void)withdrawSureButton:(UIButton *)button {
    button.enabled = NO;
    _textFieldMoney = [self.moneyTextF.text floatValue];
    NSNumber *withdrawNum = [NSNumber numberWithFloat:_textFieldMoney];
    NSString *verfiyStr = self.authcodeTextF.text;
    if (self.isMaMaWithDraw) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/noaudit_cashout",Root_URL];
        NSDictionary *param = @{@"amount":withdrawNum,
                                @"verify_code":verfiyStr};
        [self withDrawRequestURL:urlStr Param:param ActiveBOOL:YES];
    }else {
        if ([_userBudget[@"is_cash_out"] integerValue] != 1) {
            return ;
        }else {
            NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/users/budget_cash_out",Root_URL];
            NSDictionary *param = @{@"cashout_amount":withdrawNum,
                                    @"verify_code":verfiyStr};
            [self withDrawRequestURL:urlStr Param:param ActiveBOOL:NO];
        }
    }    
}
- (void)withDrawRequestURL:(NSString *)urlString Param:(NSDictionary *)param ActiveBOOL:(BOOL)activeType {
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
        if (!responseObject) {
            self.sureWithdrawButton.enabled = YES;
            return ;
        }else {
            self.sureWithdrawButton.enabled = YES;
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                _withDrawMoney -= _textFieldMoney;
                NSString *str = [NSString stringWithFormat:@"%.2f",_withDrawMoney];
                [JMNotificationCenter postNotificationName:@"drawCashMoeny" object:str];
                self.myBlanceLabel.text = [NSString stringWithFormat:@"%.2f",_withDrawMoney];
                TixianSucceedViewController *successVC = [[TixianSucceedViewController alloc] init];
                successVC.tixianjine = _textFieldMoney;
                successVC.surplusMoney = _withDrawMoney;
                successVC.isActiveValue = activeType;
                [self.navigationController pushViewController:successVC animated:YES];
            }else {
                [self showDrawResults:responseObject[@"info"]];
            }
            //            self.moneyTextF.text = @"";
        }
    } WithFail:^(NSError *error) {
        self.sureWithdrawButton.enabled = YES;
        [self showDrawResults:@"提现失败,请稍后重试"];
    } Progress:^(float progress) {
        
    }];
    
    
}

//- (void)changeButtonStatus:(UIButton *)button {
//    NSLog(@"button.enabled = YES; ========== ");
//    button.enabled = YES;
//}
- (void)showDrawResults:(NSString *)messageStr {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)getAuthcodeClick:(UIButton *)sender {
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v2/request_cashout_verify_code");
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSInteger rcodeStr = [[responseObject objectForKey:@"code"] integerValue];
        if (rcodeStr == 0) {
            [self startTime];
        }else {
            [MBProgressHUD showWarning:[responseObject objectForKey:@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"获取失败！"];
    } Progress:^(float progress) {
        
    }];
    
}

- (void)startTime {
    __block int secondsCountDown = COUNTING_LIMIT;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    
    dispatch_source_set_event_handler(_timer, ^{
        if(secondsCountDown<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_selButton setNomalBorderColor:[UIColor buttonDisabledBorderColor] TitleColor:[UIColor buttonDisabledBackgroundColor] Title:@"获取验证码" TitleFont:13. CornerRadius:15.];
                _selButton.enabled = YES;
                _selButton.selected = YES;
            });
        }else{
            int seconds = secondsCountDown % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%02d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                self.selButton.titleLabel.text = [NSString stringWithFormat:@" 剩余%02d秒",seconds];
                [UIView commitAnimations];
                _selButton.enabled = NO;
                _selButton.selected = NO;
            });
            secondsCountDown--;
        }
    });
    dispatch_resume(_timer);
    
}


#pragma mark -----UITextFieldDelegate
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
//输入框获得焦点，执行这个方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
//点击键盘的返回键  执行这个方法  -- 用来隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.moneyTextF resignFirstResponder];
    [self.authcodeTextF resignFirstResponder];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.authcodeTextF) {
        [self rightDrawCashBtn:NO];
    }else {
        [self rightDrawCashBtn:NO];
        isUserEnable = NO;
        self.withdrawButton.selected = NO;
        self.selButton.enabled = NO;
        self.selButton.selected = NO;
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    CGFloat stringF = [muString floatValue];
    
    if (textField == self.moneyTextF) {
        BOOL isTFtoMineWithDrawMoeny = (stringF - _minWithDrawMoney) > 0.00001 || fabs(stringF - _minWithDrawMoney) <= 0.00001;    // 判断输入金额与最小提现金额比较
        BOOL isTFtoWitrDrawmoney = (_withDrawMoney - stringF) >0.00001 || fabs(_withDrawMoney - stringF) <= 0.00001;               // 判断输入金额与我的余额比较
        
        if (isTFtoMineWithDrawMoeny && isTFtoWitrDrawmoney) {
            isUserEnable = YES;
            self.selButton.enabled = YES;
            self.selButton.selected = YES;
        }else {
            isUserEnable = NO;
            self.selButton.enabled = NO;
            self.selButton.selected = NO;
        }
    }else {
        if (muString.length == 0) {
            isUserEnableAuth = NO;
        }else {
            isUserEnableAuth = YES;
        }
    }
    if (isUserEnable && isUserEnableAuth) {
        [self rightDrawCashBtn:YES];
    }else {
        [self rightDrawCashBtn:NO];
    }
    
    
    
    return YES;
}
- (void)rightDrawCashBtn:(BOOL)type {
    if (type) {
        self.sureWithdrawButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;//buttonEnabledBorderColor
        self.sureWithdrawButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];//buttonDisabledBackgroundColor
        self.sureWithdrawButton.userInteractionEnabled = YES;
    }else {
        self.sureWithdrawButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;//buttonEnabledBorderColor
        self.sureWithdrawButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];//buttonDisabledBackgroundColor
        self.sureWithdrawButton.userInteractionEnabled = NO;
    }
}

- (void)backClick:(UIButton *)btn {
//    if (self.block) {
//        self.block(_withDrawMoney);
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"BlanceWithDrawCash"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"BlanceWithDrawCash"];
}


@end

































































