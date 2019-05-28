//
//  TixianViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianViewController.h"
#import "TixianSucceedViewController.h"
#import "TixianHistoryViewController.h"


@interface TixianViewController ()<UITextFieldDelegate> {
    NSDictionary *keyBoardDic;
}



@property (nonatomic,strong) UIView *firstLine;
@property (nonatomic,strong) UIView *secondLine;
/*
 我的余额
 */
@property (nonatomic,strong) UIView *myBlanceView;
@property (nonatomic,strong) UILabel *blanceLabel;
@property (nonatomic,strong) UILabel *blanceMoneyLabel;
@property (nonatomic,strong) UIView *blanceBottomView;
/*
 提现至--
 */
@property (nonatomic,strong) UIImageView *xiaoluBackImage; //圆点
@property (nonatomic,strong) UIImageView *weixinBackImage; //圆点
@property (nonatomic,strong) UIImageView *xiaoluImage;
@property (nonatomic,strong) UIImageView *wexinImage;
@property (nonatomic,strong) UIButton *xiaoluButton;
@property (nonatomic,strong) UIButton *wexinButton;
@property (nonatomic,strong) UILabel *xiaoluLabel;
@property (nonatomic,strong) UILabel *weixinLabel;


@property (nonatomic, strong) UIView *anyAmountView;
@property (nonatomic, strong) UITextField *anyAmountTextField;
@property (nonatomic, strong) UILabel *anyAmountLabel;


/*
 提现金额选择
 */
@property (nonatomic,strong) UIView *withdrawMonryView;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UIButton *oneHunderBtn;
@property (nonatomic,strong) UIButton *twoHUnderBtn;

/*
 活跃值-确认提现
 */
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *activeLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIButton *sureButton;


@property (nonatomic,strong) NSMutableArray *buttonArray;

@property (nonatomic,assign) BOOL isSelecterMoney;

@property (nonatomic,assign) BOOL isSelecterPay;


@end

@implementation TixianViewController{
    BOOL ishongbao1Opened;
    BOOL ishongbao2Opened;
    NSString *type;
    NSString *walletType;
    float tixianjine;
    float activeNum;
    BOOL isXiaolupened;
    BOOL isWeixinpend;
    
    NSInteger _active;
    
}

- (NSMutableArray *)buttonArray {
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

/*
 提现界面＝＝＝＝
 */
- (void)createWithdraw {
    UIView *firstLine = [[UIView alloc] init];
    [self.view addSubview:firstLine];
    self.firstLine = firstLine;
    self.firstLine.backgroundColor = [UIColor lightGrayColor];
    
    UIView *secondLine = [[UIView alloc] init];
    [self.view addSubview:secondLine];
    self.secondLine = secondLine;
    self.secondLine.backgroundColor = [UIColor lightGrayColor];
    
    /*
     我的余额
     */
    UIView *myBlanceView = [[UIView alloc] init];
    [self.view addSubview:myBlanceView];
    self.myBlanceView = myBlanceView;
    
    UIView *blanceBottomView = [[UIView alloc] init];
    [self.view addSubview:blanceBottomView];
    self.blanceBottomView = blanceBottomView;
    self.blanceBottomView.backgroundColor = [UIColor lineGrayColor];
    
    UILabel *blanceLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceLabel];
    self.blanceLabel = blanceLabel;
    self.blanceLabel.font = [UIFont systemFontOfSize:14.];
    self.blanceLabel.text = @"小鹿妈妈账户余额：";
    
    UILabel *blanceMoneyLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceMoneyLabel];
    self.blanceMoneyLabel = blanceMoneyLabel;
    self.blanceMoneyLabel.font = [UIFont systemFontOfSize:12.];
    self.blanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.cantixianjine];
    
    /*
     判断
     */
    if (self.cantixianjine < 100) {
        self.bottomView.hidden = YES;
        _oneHunderBtn.enabled = NO;
        _twoHUnderBtn.enabled = NO;
    }else if (self.cantixianjine < 200 && self.cantixianjine >=100) {
        self.bottomView.hidden = NO;
        _twoHUnderBtn.enabled = NO;
        _oneHunderBtn.enabled = YES;
    }else {
        _oneHunderBtn.enabled = NO;
        _twoHUnderBtn.enabled = NO;
        self.bottomView.hidden = NO;
    }
    
    /*
     提现至
     */
    UIButton *xiaoluButton = [[UIButton alloc] init];
    [self.view addSubview:xiaoluButton];
    self.xiaoluButton = xiaoluButton;
    [xiaoluButton addTarget:self action:@selector(withdrawToWallet:) forControlEvents:UIControlEventTouchUpInside];
    xiaoluButton.tag = 200;
    [xiaoluButton setAdjustsImageWhenHighlighted:NO];
    [xiaoluButton setBackgroundColor:[UIColor whiteColor]];
    
    
    UIButton *wexinButton = [[UIButton alloc] init];
    [self.view addSubview:wexinButton];
    self.wexinButton = wexinButton;
    [wexinButton addTarget:self action:@selector(withdrawToWallet:) forControlEvents:UIControlEventTouchUpInside];
    wexinButton.tag = 201;
    [wexinButton setAdjustsImageWhenHighlighted:NO];
    [wexinButton setBackgroundColor:[UIColor whiteColor]];
    
    
    UIImageView *xiaoluImage = [[UIImageView alloc] init];
    [self.xiaoluButton addSubview:xiaoluImage];
    self.xiaoluImage = xiaoluImage;
    xiaoluImage.image = [UIImage imageNamed:@"wallet_xiaolu"];
    
    
    UIImageView *wexinImage = [[UIImageView alloc] init];
    [self.wexinButton addSubview:wexinImage];
    self.wexinImage = wexinImage;
    wexinImage.image = [UIImage imageNamed:@"wallet_weixin"];
    
    UIImageView *xiaoluBackImage = [[UIImageView alloc] init];
    [self.xiaoluButton addSubview:xiaoluBackImage];
    self.xiaoluBackImage = xiaoluBackImage;
    xiaoluBackImage.image = [UIImage imageNamed:@"circle_wallet_Normal"];//circle_wallet_Selected@2x -- 高亮
    
    
    UIImageView *weixinBackImage = [[UIImageView alloc] init];
    [self.wexinButton addSubview:weixinBackImage];
    self.weixinBackImage = weixinBackImage;
    weixinBackImage.image = [UIImage imageNamed:@"circle_wallet_Normal"];
    
    UILabel *xiaoluLabel = [[UILabel alloc] init];
    [self.xiaoluButton addSubview:xiaoluLabel];
    self.xiaoluLabel = xiaoluLabel;
    self.xiaoluLabel.text = @"提现至小鹿钱包";
    self.xiaoluLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *weixinLabel = [[UILabel alloc] init];
    [self.wexinButton addSubview:weixinLabel];
    self.weixinLabel = weixinLabel;
    self.weixinLabel.text = @"提现至微信红包";
    self.weixinLabel.font = [UIFont systemFontOfSize:14.];
    
    
    self.anyAmountView = [UIView new];
    [self.view addSubview:self.anyAmountView];
    self.anyAmountView.backgroundColor = [UIColor whiteColor];
    
    self.anyAmountTextField = [UITextField new];
    [self.anyAmountView addSubview:self.anyAmountTextField];
    self.anyAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.anyAmountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.anyAmountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.anyAmountTextField.font = [UIFont systemFontOfSize:14.];
    self.anyAmountTextField.placeholder = @"请输入提现金额";
    self.anyAmountTextField.delegate = self;
    
    self.anyAmountLabel = [UILabel new];
    [self.anyAmountView addSubview:self.anyAmountLabel];
    self.anyAmountLabel.textColor = [UIColor buttonTitleColor];
    self.anyAmountLabel.font = [UIFont systemFontOfSize:13.];
    self.anyAmountLabel.text = @"金额(元):";

    //
    /*
     提现金额
     */
    UIView *withdrawMonryView = [[UIView alloc] init];
    [self.view addSubview:withdrawMonryView];
    self.withdrawMonryView = withdrawMonryView;
    self.withdrawMonryView.backgroundColor = [UIColor whiteColor];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    [self.withdrawMonryView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    self.moneyLabel.text = @"提现金额:";
    self.moneyLabel.font = [UIFont systemFontOfSize:11.];
    
    UIButton *oneHunderBtn = [[UIButton alloc] init];
    [self.withdrawMonryView addSubview:oneHunderBtn];
    self.oneHunderBtn = oneHunderBtn;
    oneHunderBtn.tag = 100;
    [oneHunderBtn addTarget:self action:@selector(withdrawMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_oneHunderBtn setBackgroundImage:[UIImage imageNamed:@"chose_withdraw_one_nomal"] forState:UIControlStateNormal];
    [_oneHunderBtn setBackgroundImage:[UIImage imageNamed:@"chose_withdraw_one_selected"] forState:UIControlStateSelected];
    
    UIButton *twoHUnderBtn = [[UIButton alloc] init];
    [self.withdrawMonryView addSubview:twoHUnderBtn];
    self.twoHUnderBtn = twoHUnderBtn;
    twoHUnderBtn.tag = 101;
    [twoHUnderBtn addTarget:self action:@selector(withdrawMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_twoHUnderBtn setBackgroundImage:[UIImage imageNamed:@"chose_withdraw_two_normal"] forState:UIControlStateNormal];
    [_twoHUnderBtn setBackgroundImage:[UIImage imageNamed:@"chose_withdraw_two_selected"] forState:UIControlStateSelected];
    
    /*
     queren
     */
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    self.bottomView.backgroundColor = [UIColor lineGrayColor];
    
    UILabel *activeLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:activeLabel];
    self.activeLabel = activeLabel;
    self.activeLabel.font = [UIFont systemFontOfSize:11.];
    _active = 10;
    self.activeLabel.text = [NSString stringWithFormat:@"消耗%ld点活跃值，剩余%ld点活跃值",(long)_active,(long)_activeValue];
    self.activeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *descLabel = [UILabel new];
    [self.bottomView addSubview:descLabel];
    descLabel.font = [UIFont systemFontOfSize:12.];
    descLabel.textColor = [UIColor dingfanxiangqingColor];
    descLabel.numberOfLines = 0;
    descLabel.text = @"提现说明：由于微信存在提现次数限制，为了在方便妈妈提现和多次小额提现等待审核时间长之间做一个平衡，我们设定提现金额为100元和200元。金额不足100元情况下，妈妈可以兑换现金券进行消费。";
    self.descLabel = descLabel;
    
    UIButton *sureButton = [[UIButton alloc] init];
    [self.bottomView addSubview:sureButton];
    self.sureButton = sureButton;
    [sureButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [sureButton setTitle:@"确认提现" forState:UIControlStateNormal];
    sureButton.enabled = NO;
    

    
    
}
- (void)setActiveValue:(NSInteger)activeValue {
    _activeValue = activeValue;
}
#pragma mark ---   选择提现金额按钮点击事件
- (void)withdrawMoneyClick:(UIButton *)button {
    if (button.tag == 100) {
        ishongbao1Opened = !ishongbao1Opened;
        if (ishongbao1Opened) {
            type = @"c1";
            _oneHunderBtn.selected = YES;
            _twoHUnderBtn.selected = NO;
            _active = 10;
            tixianjine = 100;
            if (ishongbao2Opened) {
                ishongbao2Opened = !ishongbao2Opened;
                _twoHUnderBtn.selected = NO;
                _oneHunderBtn.selected = YES;
            }
        }else {
//            type = nil;
            _oneHunderBtn.selected = YES;
        }
    }else if (button.tag == 101) {
        ishongbao2Opened = !ishongbao2Opened;
        if (ishongbao2Opened) {
            type = @"c2";
            _twoHUnderBtn.selected = YES;
            _oneHunderBtn.selected = NO;
            _active = 20;
            tixianjine = 200;
            if (ishongbao1Opened) {
                ishongbao1Opened = !ishongbao1Opened;
                _oneHunderBtn.selected = NO;
                _twoHUnderBtn.selected = YES;
            }
        }else {
//            type = nil;
            _twoHUnderBtn.selected = YES;
        }
    }
    _isSelecterMoney = (_oneHunderBtn.selected == YES | _twoHUnderBtn.selected == YES);
    _sureButton.enabled = (_isSelecterMoney  && _isSelecterPay );
    self.activeLabel.text = [NSString stringWithFormat:@"消耗%ld点活跃值，剩余%ld点活跃值",(long)_active,(long)_activeValue];
}
#pragma mark --- 选择提现到那个钱包
- (void)withdrawToWallet:(UIButton *)button {
    UIImage *nomalImage = [UIImage imageNamed:@"circle_wallet_Normal"];
    UIImage *selecterImage = [UIImage imageNamed:@"circle_wallet_Selected"];
    if (button.tag == 200) {
//        isXiaolupened = !isXiaolupened;
        [self.view insertSubview:self.anyAmountView aboveSubview:self.withdrawMonryView];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondLine.mas_bottom).offset(60);
        }];
        _xiaoluButton.selected = YES;
        _wexinButton.selected = NO;
        _xiaoluBackImage.image = selecterImage;
        _weixinBackImage.image = nomalImage;
        
        if (self.anyAmountTextField.text.length == 0) {
            self.sureButton.enabled = NO;
        }else {
            self.sureButton.enabled = YES;
        }
        
//        if (isXiaolupened) {
//            _xiaoluButton.selected = YES;
//            _wexinButton.selected = NO;
//            _xiaoluBackImage.image = selecterImage;
//            _weixinBackImage.image = nomalImage;
//            
//            if (isWeixinpend) {
//                isWeixinpend = !isWeixinpend;
//                _wexinButton.selected = NO;
//                _xiaoluButton.selected = YES;
//                _weixinBackImage.image = nomalImage;
//                _xiaoluBackImage.image = selecterImage;
//            }else {
//            }
//        }else {
//            type = nil;
//            _xiaoluButton.selected = YES;
//            _xiaoluBackImage.image = selecterImage;
//        }
    }else if (button.tag == 201) {
        [self.anyAmountTextField resignFirstResponder];
        [self.view insertSubview:self.withdrawMonryView aboveSubview:self.anyAmountView];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondLine.mas_bottom).offset(100);
        }];
        _wexinButton.selected = YES;
        _xiaoluButton.selected = NO;
        _weixinBackImage.image = selecterImage;
        _xiaoluBackImage.image = nomalImage;
        
        _isSelecterPay = YES;
        if (_isSelecterMoney) {
            self.sureButton.enabled = YES;
        }else {
            self.sureButton.enabled = NO;
        }
        
        
//        isWeixinpend = !isWeixinpend;
//        if (isWeixinpend) {
//            _wexinButton.selected = YES;
//            _xiaoluButton.selected = NO;
//            _weixinBackImage.image = selecterImage;
//            _xiaoluBackImage.image = nomalImage;
//            if (isXiaolupened) {
//                isXiaolupened = !isXiaolupened;
//                _xiaoluButton.selected = NO;
//                _wexinButton.selected = YES;
//                _xiaoluBackImage.image = nomalImage;
//                _weixinBackImage.image = selecterImage;
//            }
//        }else {
//            type = nil;
//            _wexinButton.selected = YES;
//            _weixinBackImage.image = selecterImage;
//        }
    }
//    _isSelecterPay = (_xiaoluButton.selected == YES | _wexinButton.selected == YES);
//    _sureButton.enabled = (_isSelecterMoney  && _isSelecterPay );
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"TixianViewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"TixianViewController"];
}
#pragma mark ---- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    [self createWithdraw];
    [self createAutolayouts];
        
    type = @"";

    
}

#pragma mark ----- 体现按钮是否可由点击
- (void)enableSureButton{
    self.sureButton.enabled = YES;
    
    self.sureButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [self.sureButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
}
- (void)disableSiureButton{
    self.sureButton.enabled = NO;
    self.sureButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    
    [self.sureButton setTitleColor:[UIColor buttonDisabledBackgroundColor] forState:UIControlStateNormal];
    //self.obtainCodeButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 确认提现按钮点击
- (void)sureBtnClick:(UIButton *)btn {
    [MBProgressHUD showLoading:@""];
    btn.enabled = NO;
    NSString *stringurl;
    NSDictionary *paramters = [[NSDictionary alloc] init];
    
    if (_wexinButton.selected) {
        stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout", Root_URL];
        if (type != nil) {
            paramters = @{@"choice":type};
        }else {
            return ;
        }
    }else {
        paramters = @{@"value":self.anyAmountTextField.text};
//        NSInteger numMoney = 0;
//        if (_oneHunderBtn.selected == YES) {
//            numMoney = 100;
//        }else {
//            numMoney = 200;
//        }
//        stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cashout_to_budget?cashout_amount=%ld", Root_URL,(long)numMoney];
        stringurl = [NSString stringWithFormat:@"%@/rest/v2/mmcashout/cash_out_2_budget",Root_URL];
        self.cantixianjine -= [self.anyAmountTextField.text floatValue];
    }
    
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:stringurl WithParaments:paramters WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            [MBProgressHUD hideHUD];
            btn.enabled = YES;
            return ;
        }
        [MBProgressHUD hideHUD];
        btn.enabled = YES;
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        TixianSucceedViewController *vc = [[TixianSucceedViewController alloc] init];
        if (code == 0) {
            NSString *str = [NSString stringWithFormat:@"%.2f",_cantixianjine];
            [JMNotificationCenter postNotificationName:@"drawCashMoeny" object:str];
            vc.tixianjine = tixianjine;
            vc.activeValueNum = _activeValue;
            vc.surplusMoney = self.cantixianjine;
            vc.isActiveValue = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [MBProgressHUD showError:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        btn.enabled = YES;
    } Progress:^(float progress) {
        
    }];

}


- (void)alterMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    
}

//- (IBAction)fabuClicked:(id)sender {
// //   NSLog(@"发布产品");
//    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
//    [self.navigationController pushViewController:publish animated:YES];
//}
- (void)createAutolayouts {
    
    //我的余额
    [self.myBlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@50);
    }];
    
    [self.blanceBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBlanceView.mas_bottom).offset(0);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@15);
    }];
    
    [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myBlanceView.mas_left).offset(11);
        make.centerY.equalTo(self.myBlanceView.mas_centerY);
        make.height.mas_equalTo(@20);
    }];
    
    [self.blanceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.blanceLabel.mas_centerY);
        make.left.equalTo(self.blanceLabel.mas_right).offset(5);
//        make.width.mas_equalTo(@300);
//        make.height.mas_equalTo(@18);
    }];

    [self.xiaoluButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blanceBottomView.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        //        make.centerX.equalTo(self.view.mas_centerX);
        //        make.right.equalTo(self.xiaoluBackImage).offset(-12);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(@60);
    }];
    
    [self.xiaoluImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xiaoluButton).offset(22);
        make.left.equalTo(self.xiaoluButton).offset(11);
        make.width.mas_equalTo(@(43/2));
        make.height.mas_equalTo(@16);
    }];
    
    //布局的时候给顶一个固定Y值   是否需要设定高度 ？？？
    [self.xiaoluLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xiaoluImage.mas_centerY);
        make.left.equalTo(self.xiaoluImage.mas_right).offset(10);
        make.width.mas_equalTo(@100);
    }];
    
    
    [self.wexinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.left.equalTo(self.view);
        //        make.right.equalTo(self.xiaoluBackImage).offset(-12);
        make.height.mas_equalTo(@60);
    }];
    
    [self.wexinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wexinButton).offset(20);
        make.left.equalTo(self.wexinButton).offset(11);
        make.width.mas_equalTo(@(45/2));
        make.height.mas_equalTo(@20);
    }];
    
    //布局的时候给顶一个固定Y值   是否需要设定高度 ？？？
    [self.weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wexinImage.mas_centerY);
        make.left.equalTo(self.wexinImage.mas_right).offset(10);
        make.width.mas_equalTo(@100);
    }];
    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xiaoluButton.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wexinButton.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    // 任意金额提现
    [self.anyAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.anyAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.anyAmountView).offset(10);
        make.centerY.equalTo(self.anyAmountView.mas_centerY);
    }];
    
    [self.anyAmountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.anyAmountLabel.mas_right).offset(10);
        make.centerY.equalTo(self.anyAmountView.mas_centerY);
        make.width.mas_equalTo(SCREENWIDTH - 80);
    }];
    
    /**************/
    [self.withdrawMonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@100);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawMonryView.mas_top).offset(11);
        make.left.equalTo(self.withdrawMonryView.mas_left).offset(11);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@18);
    }];
    
    //100元 图片
    [self.oneHunderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(13);
        make.left.equalTo(self.withdrawMonryView.mas_left).offset(40);
        make.width.mas_equalTo(@103);
        make.height.mas_equalTo(@35);
    }];
    
    //200元 图片
    [self.twoHUnderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneHunderBtn);
        //        make.left.equalTo(self.oneHunderBtn.mas_right).offset(102/2);
        make.right.equalTo(self.withdrawMonryView.mas_right).offset(-40);
        make.width.mas_equalTo(@103);
        make.height.mas_equalTo(@35);
    }];
    
    
    /***************/
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@(590/2));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(5);
        make.centerX.equalTo(self.bottomView.mas_centerX);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@19);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.bottomView).offset(20);
        make.width.mas_equalTo(@(SCREENWIDTH - 40));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@(79/2));
    }];
    
    [self.xiaoluBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xiaoluImage.mas_centerY);
        make.width.height.mas_equalTo(@17);
        make.right.equalTo(self.view).offset(-11);
    }];
    
    [self.weixinBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wexinImage.mas_centerY);
        make.width.height.mas_equalTo(@17);
        make.right.equalTo(self.view).offset(-11);
    }];
    
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
    [self.anyAmountTextField resignFirstResponder];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.sureButton.enabled = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    CGFloat stringF = [muString floatValue];
    BOOL isTFtoWitrDrawmoney = (self.cantixianjine - stringF) >0.00001 || fabs(self.cantixianjine - stringF) <= 0.00001;               // 判断输入金额与我的余额比较
    if (isTFtoWitrDrawmoney) {
        self.sureButton.enabled = YES;
    }else {
        self.sureButton.enabled = NO;
        
    }
    if (muString.length == 0) {
        self.sureButton.enabled = NO;
    }else {
    }
    return YES;
}

//- (void)keyNotification:(NSNotification *)notifition {
//    if (SCREENHEIGHT > 480) {
//        return ;
//    }
//    keyBoardDic = notifition.userInfo;
//    CGRect rect = [keyBoardDic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    //    CGRect rect1 = [self convertRect:rect toView:self.superview];
//    //    kWeakSelf
//    [UIView animateWithDuration:[keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//        [UIView setAnimationCurve:[keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
//        CGRect frame = self.view.frame;
//        frame.origin.y = rect.origin.y - frame.size.height;
//        self.view.frame = frame;
//    }];
//    
//}
- (void)keyboardDidShow:(NSNotification *)notification {
    if (SCREENHEIGHT > 480) {
        return ;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.cs_max_Y = SCREENHEIGHT - 120;
    }];
}
- (void)keyboardDidHidden {
    if (SCREENHEIGHT > 480) {
        return ;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.cs_max_Y = SCREENHEIGHT;
    }];
}


@end









































