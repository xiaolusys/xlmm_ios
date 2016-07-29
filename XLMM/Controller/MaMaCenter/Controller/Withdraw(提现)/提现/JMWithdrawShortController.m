//
//  JMWithdrawShortController.m
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMWithdrawShortController.h"
#import "MMClass.h"
#import "JMCouponCell.h"
#import "JMCouponView.h"
#import "JMCouponSuccessController.h"
#import "TixianHistoryViewController.h"

@interface JMWithdrawShortController ()<JMCouponViewDelegate,UIAlertViewDelegate>

/*
 我的余额
 */
@property (nonatomic,strong) UIView *myBlanceView;
@property (nonatomic,strong) UILabel *blanceLabel;
@property (nonatomic,strong) UILabel *blanceMoneyLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) JMCouponView *couponView;

@end

@implementation JMWithdrawShortController {
    NSInteger _choiseMoney;
    NSString *_imageStrTwo;
    NSString *_imageStrFive;
    NSInteger _withdrawMoneyNum;
    CGFloat _mywithBlance;
}
//- (JMCouponView *)couponView {
//    if (_couponView == nil) {
//        _couponView = [[JMCouponView alloc] init];
//    }
//    return _couponView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];

    [self createCoupon];
    [self createRightButonItem];
    
}
- (void)setMyBalance:(CGFloat)myBalance {
    _myBalance = myBalance;
    _mywithBlance = myBalance;
}

// /rest/v1/pmt/cashout/exchange_coupon?template_id=62&exchange_num=3   72 20 73 50
#pragma mark --- 取现金额不足100显示领取优惠券视图
- (void)createCoupon {
    
    JMCouponView *couponView = [[JMCouponView alloc] initWithFrame:CGRectMake(0, 200 , SCREENWIDTH, 220)];
    [self.view addSubview:couponView];
    self.couponView = couponView;
    self.couponView.myCouponBlance = _mywithBlance;
    couponView.delegate = self;
    
    /*
     我的余额
     */
    UIView *myBlanceView = [[UIView alloc] init];
    [self.view addSubview:myBlanceView];
    self.myBlanceView = myBlanceView;
    self.myBlanceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *blanceLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceLabel];
    self.blanceLabel = blanceLabel;
    self.blanceLabel.font = [UIFont systemFontOfSize:14.];
    self.blanceLabel.text = @"小鹿妈妈账户余额：";
    
    UILabel *blanceMoneyLabel = [[UILabel alloc] init];
    [self.myBlanceView addSubview:blanceMoneyLabel];
    self.blanceMoneyLabel = blanceMoneyLabel;
    self.blanceMoneyLabel.font = [UIFont systemFontOfSize:12.];
    self.blanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",_mywithBlance];
    
    UIView *headView = [UIView new];
    [self.view addSubview:headView];
    
    UILabel *notEngouthLabel = [UILabel new];
    [self.view addSubview:notEngouthLabel];
    notEngouthLabel.textColor = [UIColor redColor];
    notEngouthLabel.font = [UIFont systemFontOfSize:11.];
    notEngouthLabel.text = self.descStr;
    
    UILabel *convertCouponLabel = [UILabel new];
    [self.view addSubview:convertCouponLabel];
    convertCouponLabel.text = @"兑换现金券";
    convertCouponLabel.font = [UIFont systemFontOfSize:12.];
    convertCouponLabel.textColor = [UIColor buttonTitleColor];
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:sureButton];
    self.sureButton = sureButton;
    self.sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.sureButton setTitle:@"确认兑换" forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = 15;
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.myBalance >= 20) {
        self.sureButton.enabled = YES;
    }else {
        self.sureButton.enabled = NO;
    }
    
    
    kWeakSelf
    //我的余额
    [self.myBlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@60);
    }];
    
    [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myBlanceView).offset(20);
        make.left.equalTo(weakSelf.myBlanceView.mas_left).offset(11);
        make.height.mas_equalTo(@20);
    }];
    
    [self.blanceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.blanceLabel.mas_centerY);
        make.left.equalTo(weakSelf.blanceLabel.mas_right).offset(5);
    }];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myBlanceView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@80);
    }];
    
    [notEngouthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).offset(10);
        make.right.equalTo(headView).offset(-10);
    }];
    
    [convertCouponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(10);
        make.bottom.equalTo(headView).offset(-20);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.top.equalTo(bottomView).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 30);
    }];
    
    
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
- (void)sureButtonClick:(UIButton *)button {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"兑换提示" message:@"兑换此现金券后，小鹿妈妈账户余额会相应扣减金额，此现金券能够用于商城购买商品，无法取消" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1) {
            NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/exchange_coupon?template_id=%ld&exchange_num=1", Root_URL,_choiseMoney];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager GET:stringurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject == nil) {
                    return ;
                }else {
                    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                    if (code == 0) {
                        _mywithBlance -= _withdrawMoneyNum;
                        if (_mywithBlance < 20) {
                            self.sureButton.enabled = NO;
                        }
                        self.blanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",_mywithBlance];
                        JMCouponSuccessController *vc = [[JMCouponSuccessController alloc] init];
                        vc.moneyNum = _withdrawMoneyNum;
                        vc.withDrawMoney = _mywithBlance;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else {
                        [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                    }
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];

        }else {
            
        }
        
    }else {
        
    }
}

/**
 *  NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
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
 */
- (void)composeCouponBtn:(JMCouponView *)shareBtn Button:(UIButton *)button didClickBtn:(NSInteger)index {
    
    
    
    if (index == 1) {
        _choiseMoney = 72;
        _withdrawMoneyNum = 20;
    }else {
        _withdrawMoneyNum = 50;
        _choiseMoney = 73;
    }
    
    for (int i = 1 ; i < 3; i++) {
        UIButton *btni = (UIButton *)[self.view viewWithTag:i];
        UIButton *btnTag = (UIButton *)[self.view viewWithTag:index];
        if (i == index) {
            btnTag.selected = YES;
        }else {
            btni.selected = NO;
        }
    }
    
    
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMWithdrawShortController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"JMWithdrawShortController"];
}


@end






































