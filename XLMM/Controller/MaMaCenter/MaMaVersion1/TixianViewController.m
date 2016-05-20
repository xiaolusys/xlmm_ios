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
@property (nonatomic,strong) UIImageView *xiaoluBackImage; //圆点
@property (nonatomic,strong) UIImageView *weixinBackImage; //圆点
@property (nonatomic,strong) UIImageView *xiaoluImage;
@property (nonatomic,strong) UIImageView *wexinImage;
@property (nonatomic,strong) UIButton *xiaoluButton;
@property (nonatomic,strong) UIButton *wexinButton;
@property (nonatomic,strong) UILabel *xiaoluLabel;
@property (nonatomic,strong) UILabel *weixinLabel;

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
        _twoHUnderBtn.enabled = NO;
    }else if (_cantixianjine < 200 && _cantixianjine >=100) {
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
        isXiaolupened = !isXiaolupened;
        if (isXiaolupened) {
            _xiaoluButton.selected = YES;
            _wexinButton.selected = NO;
            _xiaoluBackImage.image = selecterImage;
            _weixinBackImage.image = nomalImage;
            
            if (isWeixinpend) {
                isWeixinpend = !isWeixinpend;
                _wexinButton.selected = NO;
                _xiaoluButton.selected = YES;
                _weixinBackImage.image = nomalImage;
                _xiaoluBackImage.image = selecterImage;
            }else {
            }
        }else {
            type = nil;
            _xiaoluButton.selected = YES;
            _xiaoluBackImage.image = selecterImage;
        }
    }else if (button.tag == 201) {
        isWeixinpend = !isWeixinpend;
        if (isWeixinpend) {
            _wexinButton.selected = YES;
            _xiaoluButton.selected = NO;
            _weixinBackImage.image = selecterImage;
            _xiaoluBackImage.image = nomalImage;
            if (isXiaolupened) {
                isXiaolupened = !isXiaolupened;
                _xiaoluButton.selected = NO;
                _wexinButton.selected = YES;
                _xiaoluBackImage.image = nomalImage;
                _weixinBackImage.image = selecterImage;
            }
        }else {
            type = nil;
            _wexinButton.selected = YES;
            _weixinBackImage.image = selecterImage;
        }
    }
    _isSelecterPay = (_xiaoluButton.selected == YES | _wexinButton.selected == YES);
    _sureButton.enabled = (_isSelecterMoney  && _isSelecterPay );
}
#pragma mark ---- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cantixianjine = [self.carryNum floatValue];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    [self createWithdraw];
    [self createAutolayouts];
    [self createRightButonItem];
    
    type = @"";
}
#pragma mark ---- 导航栏右侧体现历史
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"提现历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{
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

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 确认提现按钮点击
- (void)sureBtnClick:(UIButton *)btn {
    
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
        NSInteger numMoney = 0;
        if (_oneHunderBtn.selected == YES) {
            numMoney = 100;
        }else {
            numMoney = 200;
        }
        stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cashout_to_budget?cashout_amount=%ld", Root_URL,(long)numMoney];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:stringurl parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject == nil) {
            return ;
        }
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        TixianSucceedViewController *vc = [[TixianSucceedViewController alloc] init];

        switch (code) {
            case 0:
                vc.tixianjine = tixianjine;
                vc.activeValueNum = _activeValue;
                vc.surplusMoney = _cantixianjine;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            case 1:
                [self alterMessage:@"参数错误"];
                break;
            case 2:
                [self alterMessage:@"不足提现金额"];
                break;
            case 3:
                [self alterMessage:@"有待审核记录不予再次提现"];
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];

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
    
    //我的余额
    [self.myBlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.blanceBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBlanceView.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@30);
    }];
    
    [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBlanceView).offset(20);
        make.left.equalTo(self.myBlanceView.mas_left).offset(11);
        make.width.mas_equalTo(@70);
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
        make.top.equalTo(self.withdrawMonryView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@(590/2));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.centerX.equalTo(self.bottomView.mas_centerX);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@19);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activeLabel.mas_bottom).offset(30);
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

@end











