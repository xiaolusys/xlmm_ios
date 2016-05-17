//
//  TixianViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "TixianSucceedViewController.h"
#import "PublishNewPdtViewController.h"
#import "TixianHistoryViewController.h"
#import "Masonry.h"


@interface TixianViewController ()
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
@property (nonatomic,strong) UIView *withdrawView;
//@property (nonatomic,strong) UIImageView *xiaoluImage;
//@property (nonatomic,strong) UIImageView *wexinImage;
@property (nonatomic,strong) UIButton *xiaoluButton;
@property (nonatomic,strong) UIButton *wexinButton;
//@property (nonatomic,strong) UILabel *xiaoluLabel;
//@property (nonatomic,strong) UILabel *weixinLabel;




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
@property (nonatomic,strong) UIButton *sureButton;

//@property (nonatomic,assign) NSInteger numValue;

@property (nonatomic,strong) NSMutableArray *buttonArray;

@property (nonatomic,assign) BOOL isSelecterMoney;

@property (nonatomic,assign) BOOL isSelecterPay;

@end

@implementation TixianViewController{
    BOOL ishongbao1Opened;
    BOOL ishongbao2Opened;
    NSString *type;
    NSString *walletType;
//    float zhanghuyue;
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


- (void)setCantixianjine:(float)cantixianjine {
    
    _cantixianjine = cantixianjine;
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
    self.blanceLabel.text = @"我的余额：";
    
//    zhanghuyue = self.cantixianjine;
    UILabel *blanceMoneyLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceMoneyLabel];
    self.blanceMoneyLabel = blanceMoneyLabel;
    self.blanceMoneyLabel.font = [UIFont systemFontOfSize:12.];
    self.blanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",_cantixianjine];
    
    /*
        判断
     */
    if (_cantixianjine < 100) {
        
        self.bottomView.hidden = YES;
        _oneHunderBtn.enabled = NO;
        
    }else if (_cantixianjine < 200 && _cantixianjine >=100) {
        
        self.bottomView.hidden = NO;
        
//        if (_cantixianjine < 200 && _cantixianjine >=100) {
        
            _twoHUnderBtn.enabled = NO;

            
//        }else {
//            
//        
//        }
//        
    }else {
        
        
    }
    
    
    /*
        提现至
     */
    UIView *withdrawView = [[UIView alloc] init];
    [self.view addSubview:withdrawView];
    self.withdrawView = withdrawView;

    
//    UIImageView *xiaoluImage = [[UIImageView alloc] init];
//    [self.withdrawView addSubview:xiaoluImage];
//    self.xiaoluImage = xiaoluImage;
////    self.xiaoluImage.image = [UIImage imageNamed:@"Circle_Normal"];
//    xiaoluImage.image = [UIImage imageNamed:@"wallet_xiaolu"];
    
    
//    UIImageView *wexinImage = [[UIImageView alloc] init];
//    [self.withdrawView addSubview:wexinImage];
//    self.wexinImage = wexinImage;
////    self.wexinImage.image = [UIImage imageNamed:@"Circle_Normal"];
//    wexinImage.image = [UIImage imageNamed:@"wallet_weixin"];

    UIButton *xiaoluButton = [[UIButton alloc] init];
    [self.withdrawView addSubview:xiaoluButton];
    self.xiaoluButton = xiaoluButton;
    [xiaoluButton setBackgroundImage:[UIImage imageNamed:@"xiaolu_nomal"] forState:UIControlStateNormal];
    [xiaoluButton setBackgroundImage:[UIImage imageNamed:@"xiaolu_selecter"] forState:UIControlStateSelected];
//    xiaoluButton.selected = YES;
    [xiaoluButton addTarget:self action:@selector(withdrawToWallet:) forControlEvents:UIControlEventTouchUpInside];
    xiaoluButton.tag = 200;
    
    UIButton *wexinButton = [[UIButton alloc] init];
    [self.withdrawView addSubview:wexinButton];
    self.wexinButton = wexinButton;
    [wexinButton setBackgroundImage:[UIImage imageNamed:@"weixin_nomal"] forState:UIControlStateNormal];
    [wexinButton setBackgroundImage:[UIImage imageNamed:@"weixin_selecter"] forState:UIControlStateSelected];
    [wexinButton addTarget:self action:@selector(withdrawToWallet:) forControlEvents:UIControlEventTouchUpInside];
    wexinButton.tag = 201;
    
//    [_buttonArray addObject:xiaoluButton];
//    [_buttonArray addObject:wexinButton];
    
//    UILabel *xiaoluLabel = [[UILabel alloc] init];
//    [self.xiaoluButton addSubview:xiaoluLabel];
//    self.xiaoluLabel = xiaoluLabel;
//    self.xiaoluLabel.text = @"提现至小鹿钱包";
//    self.xiaoluLabel.font = [UIFont systemFontOfSize:14.];
//    
//    UILabel *weixinLabel = [[UILabel alloc] init];
//    [self.withdrawView addSubview:weixinLabel];
//    self.weixinLabel = weixinLabel;
//    self.weixinLabel.text = @"提现至微信红包";
//    self.weixinLabel.font = [UIFont systemFontOfSize:14.];
//
    /*
        提现金额
     */
    
    UIView *withdrawMonryView = [[UIView alloc] init];
    [self.view addSubview:withdrawMonryView];
    self.withdrawMonryView = withdrawMonryView;

    
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
//    _oneHunderBtn.selected = YES;
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
    
//    activeNum = [self.activeValue floatValue];
    
    _active = 10;
//    if (_oneHunderBtn.selected == YES) {
//        activeV = 10;
//    }else if(_twoHUnderBtn.selected == YES){
//        activeV = 20;
//    }else {
//    
//    }
    
//    _oneHunderBtn.selected = 1 ? 10 : 20;
    self.activeLabel.text = [NSString stringWithFormat:@"消耗%ld点活跃值，剩余%ld点活跃值",_active,_activeValue];
    self.activeLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *sureButton = [[UIButton alloc] init];
    [self.bottomView addSubview:sureButton];
    self.sureButton = sureButton;
    [sureButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [sureButton setTitle:@"确认提现" forState:UIControlStateNormal];
    
    sureButton.enabled = NO;
    
    
    
    //(_isSelecterMoney  && _isSelecterPay );
    
//    self.sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//    self.sureButton.layer.borderColor = [UIColor  buttonEnabledBorderColor].CGColor;
//    self.sureButton.enabled = NO;
    
//    [sureButton setTitle:@"确认提现" forState:UIControlStateNormal];
//    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

//    if ((_oneHunderBtn.selected == YES | _twoHUnderBtn.selected == YES) && (_xiaoluButton.selected == YES|_wexinButton.selected == YES)) {
//        self.sureButton.enabled = YES;
//    }
////
//    _isSelecterMoney = (_oneHunderBtn.selected == YES | _twoHUnderBtn.selected == YES);
//    _isSelecterPay = (_xiaoluButton.selected == YES | _wexinButton.selected == YES);
    
//    sureButton.enabled = (_isSelecterMoney == YES && _isSelecterPay == YES);
    
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
//            [self enableTijiaoButton];
                _oneHunderBtn.selected = YES;
                _twoHUnderBtn.selected = NO;
                _active = 10;
            tixianjine = 100;
            if (ishongbao2Opened) {
                ishongbao2Opened = !ishongbao2Opened;
//                button.selected = NO;
                _twoHUnderBtn.selected = NO;
                _oneHunderBtn.selected = YES;
            }
        }else {
            type = nil;
//            [self disableTijiaoButton];
            _oneHunderBtn.selected = YES;
        }
        
    }else if (button.tag == 101) {

//        _oneHunderBtn.selected = NO;
        ishongbao2Opened = !ishongbao2Opened;
        if (ishongbao2Opened) {
            type = @"c2";
//            [self enableTijiaoButton];
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
            type = nil;
//            [self disableTijiaoButton];
            _twoHUnderBtn.selected = YES;
        }
        
    }
    
    _isSelecterMoney = (_oneHunderBtn.selected == YES | _twoHUnderBtn.selected == YES);
    
    _sureButton.enabled = (_isSelecterMoney  && _isSelecterPay );
    
    self.activeLabel.text = [NSString stringWithFormat:@"消耗%ld点活跃值，剩余%ld点活跃值",_active,_activeValue];

}

#pragma mark --- 选择提现到那个钱包
- (void)withdrawToWallet:(UIButton *)button {
    
    
    
    if (button.tag == 200) {

        isXiaolupened = !isXiaolupened;
        if (isXiaolupened) {
            _xiaoluButton.selected = YES;
            _wexinButton.selected = NO;
            if (isWeixinpend) {
                isWeixinpend = !isWeixinpend;
                _wexinButton.selected = NO;
                _xiaoluButton.selected = YES;
            }else {

            }
        }else {
            type = nil;
//            [self disableTijiaoButton];
            _xiaoluButton.selected = YES;
        }
        
    }else if (button.tag == 201) {

        isWeixinpend = !isWeixinpend;
        if (isWeixinpend) {
//            walletType = @"cashout_to_budget";
//            [self enableTijiaoButton];
            _wexinButton.selected = YES;
            _xiaoluButton.selected = NO;
//            tixianjine = 200.;
            if (isXiaolupened) {
                isXiaolupened = !isXiaolupened;
                _xiaoluButton.selected = NO;
                _wexinButton.selected = YES;
            }
        }else {
            type = nil;
//            [self disableTijiaoButton];
            _wexinButton.selected = YES;
        }
        
    }
    _isSelecterPay = (_xiaoluButton.selected == YES | _wexinButton.selected == YES);
    
    _sureButton.enabled = (_isSelecterMoney  && _isSelecterPay );
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cantixianjine = [self.carryNum floatValue];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    
    [self createWithdraw];
    [self createAutolayouts];
  
    
    [self createRightButonItem];

    
}

- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//    label.textColor = [UIColor textDarkGrayColor];
//    label.font = [UIFont systemFontOfSize:14];
//    label.textAlignment = NSTextAlignmentRight;
//    [rightBtn addSubview:label];
//    label.text = @"提现历史";
    [rightBtn setTitle:@"提现历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{
    NSLog(@"历史提现");
    
    
    
    TixianHistoryViewController *historyVC = [[TixianHistoryViewController alloc] init];
    
    
    
    [self.navigationController pushViewController:historyVC animated:YES];
    
    
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


//- (void)enableTijiaoButton{
//    self.sureButton.enabled = YES;
//    self.sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//    self.sureButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//}
//
//- (void)disableTijiaoButton{
//    self.sureButton.enabled = NO;
//    self.sureButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
//    self.sureButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
//}

//- (void)showHongBaoImage:(UIImageView *)imageView andImageNamed:(NSString *)name{
//   imageView.image = [UIImage imageNamed:name];
//    
//}
//
//- (void)hiddenHongBaoImage:(UIImageView *)imageView atIndex:(int)index{
//    if (index == 0) {
//        imageView.image = [UIImage imageNamed:@"hongbaoclose100.png"];
//
//    } else if (index == 1) {
//        imageView.image = [UIImage imageNamed:@"hongbaoclose200.png"];
//
//    }
//}

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
- (void)sureBtnClick:(UIButton *)btn {
    
    if (_wexinButton.selected == YES) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout", Root_URL];
        
        NSDictionary *paramters = @{@"choice":type};
        
        [manager POST:stringurl parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            
            if (code == 0) {
                TixianSucceedViewController *vc = [[TixianSucceedViewController alloc] init];
                vc.tixianjine = tixianjine;
                vc.activeValueNum = _activeValue;
                
                vc.surplusMoney = _cantixianjine;
                
                [self.navigationController pushViewController:vc animated:YES];
            } else if (code == 1){
                [self alterMessage:@"参数错误"];
                
            } else if (code == 2){
                [self alterMessage:@"不足提现金额"];
            } else if (code == 3){
                [self alterMessage:@"有待审核记录不予再次提现"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        ////http://m.xiaolumeimei.com/rest/v1/pmt/cashout/cashout_to_budget?cashout_amount=100
        NSInteger numMoney = 0;
        if (_oneHunderBtn.selected == YES) {
            numMoney = 100;
        }else {
            numMoney = 200;
        }
        
        NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cashout_to_budget?cashout_amount=%ld", Root_URL,(long)numMoney];
        
        
        
//        NSDictionary *paramters = @{@"choice":@"cashout_amount"};
        
        [manager POST:stringurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            
            if (code == 0) {
                TixianSucceedViewController *vc = [[TixianSucceedViewController alloc] init];
                vc.tixianjine = tixianjine;
                
                vc.surplusMoney = _cantixianjine;
                vc.activeValueNum = _activeValue;
                
                [self.navigationController pushViewController:vc animated:YES];
            } else if (code == 1){
                [self alterMessage:@"参数错误"];
                
            } else if (code == 2){
                [self alterMessage:@"不足提现金额"];
            } else if (code == 3){
                [self alterMessage:@"有待审核记录不予再次提现"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }
    
}


- (void)alterMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

//- (IBAction)fabuClicked:(id)sender {
// //   NSLog(@"发布产品");
//    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
//    [self.navigationController pushViewController:publish animated:YES];
//}
- (void)createAutolayouts {
    
    [self.myBlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.blanceBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBlanceView.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@30);
    }];
    
    [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBlanceView.mas_top).offset(45/2);
        make.left.equalTo(self.myBlanceView.mas_left).offset(11);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@(43/2));
    }];
    
    [self.blanceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBlanceView.mas_top).offset(45/2);
        make.left.equalTo(self.blanceLabel.mas_right).offset(5);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@19);
    }];
    
    /**********/
    [self.withdrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blanceBottomView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@120);
    }];
    
    [self.xiaoluButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_offset(@60);
        make.top.equalTo(self.withdrawView);
        make.left.equalTo(self.withdrawView);
    }];
    
    [self.wexinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_offset(@60);
        make.top.equalTo(self.firstLine);
        make.left.equalTo(self.withdrawView);
    }];

    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawView.mas_top).offset(60);
        make.width.mas_offset(SCREENWIDTH);
        make.left.equalTo(self.withdrawView.mas_left).offset(0);
        make.height.mas_offset(0.5);
    }];
    
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_top).offset(60);
        make.width.mas_offset(SCREENWIDTH);
        make.left.equalTo(self.withdrawView.mas_left).offset(0);
        make.height.mas_offset(0.5);
    }];

    
    
    /**************/
    [self.withdrawMonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.bottom.equalTo(self.oneHunderBtn.mas_bottom).offset(20);
//        make.height.mas_equalTo(@(199/2));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawMonryView.mas_top).offset(11);
        make.left.equalTo(self.withdrawMonryView.mas_left).offset(11);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@(37/2));
    }];
    
    [self.oneHunderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(13);
        make.left.equalTo(self.withdrawMonryView.mas_left).offset(40);
//        make.right.equalTo(self.twoHUnderBtn.mas_left).offset(-102/2);
//        make.width.equalTo(self.twoHUnderBtn);
        make.width.mas_offset(@103);
        make.height.mas_equalTo(@35);
    }];
    
    [self.twoHUnderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneHunderBtn);
//        make.left.equalTo(self.oneHunderBtn.mas_right).offset(102/2);
        make.right.equalTo(self.withdrawMonryView.mas_right).offset(-40);
        make.width.mas_offset(@103);
        make.height.mas_equalTo(@35);
    }];
    
    /***************/
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawMonryView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@(590/2));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@19);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activeLabel.mas_bottom).offset(35);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@(79/2));
    }];
    
}

@end
