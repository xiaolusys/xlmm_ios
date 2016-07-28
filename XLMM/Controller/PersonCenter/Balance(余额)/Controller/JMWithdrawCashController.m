//
//  JMWithdrawCashController.m
//  XLMM
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWithdrawCashController.h"
#import "MMClass.h"
#import "Masonry.h"
#import "UIViewController+NavigationBar.h"
#import "AFNetworking.h"
#import "TixianSucceedViewController.h"

@interface JMWithdrawCashController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *myBlanceLabel;

@property (nonatomic, strong) UIButton *withdrawButton;

@property (nonatomic, strong) UITextField *moneyTextF;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *sureWithdrawButton;

@property (nonatomic, strong) UILabel *descTitleLabel;

@end

@implementation JMWithdrawCashController {
    NSDictionary *_userBudget;
    CGFloat _withDrawMoney;
    CGFloat _textFieldMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClick:)];
    
    [self createWtihdrawView];
}
- (void)setPersonCenterDict:(NSDictionary *)personCenterDict {
    _personCenterDict = personCenterDict;
    _userBudget = personCenterDict[@"user_budget"];
    
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
    self.moneyTextF.keyboardType = UIKeyboardTypeNumberPad;
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
    self.descTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.descTitleLabel.textColor = [UIColor timeLabelColor];
    self.descTitleLabel.text = @"提现金额将以微信红包形式，24小时内发至你绑定的微信账户";
    self.descTitleLabel.font = [UIFont systemFontOfSize:11.];
    self.descTitleLabel.numberOfLines = 0;
    
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
    
    UILabel *blanceL = [UILabel new];
    [firstView addSubview:blanceL];
    blanceL.text = @"我的余额:";
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
        make.top.equalTo(threeView.mas_bottom).offset(10);
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
        self.moneyTextF.text = @"200.00";
    }else {
        self.moneyTextF.text = @"";
    }
    CGFloat moneyTextF = [self.moneyTextF.text floatValue];
    if (moneyTextF - _withDrawMoney > 0.000001) {
        [self rightDrawCashBtn:NO];
    }else {
        [self rightDrawCashBtn:YES];
    }
    
}
- (void)withdrawSureButton:(UIButton *)button {
    _textFieldMoney = [self.moneyTextF.text floatValue];
    NSNumber *withdrawNum = [NSNumber numberWithFloat:_textFieldMoney];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/users/budget_cash_out", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *param = @{@"cashout_amount":withdrawNum};
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            return ;
        }else {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                _withDrawMoney -= _textFieldMoney;
                self.myBlanceLabel.text = [NSString stringWithFormat:@"%.2f",_withDrawMoney];
                TixianSucceedViewController *successVC = [[TixianSucceedViewController alloc] init];
                successVC.tixianjine = _textFieldMoney;
                successVC.surplusMoney = _withDrawMoney;
                successVC.isActiveValue = NO;
                [self.navigationController pushViewController:successVC animated:YES];
            }else {
                [self showDrawResults:responseObject];
            }
            self.moneyTextF.text = @"";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)showDrawResults:(NSDictionary *)results {
    NSString *desc = results[@"message"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:desc delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self rightDrawCashBtn:NO];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    CGFloat stringF = [muString floatValue];
    BOOL isEnough = ((_withDrawMoney - stringF) > 0.000001);
    BOOL isSureBtn = ((textField.text != 0) && isEnough);
    [self rightDrawCashBtn:isSureBtn];
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
    self.block(_withDrawMoney);
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

































































