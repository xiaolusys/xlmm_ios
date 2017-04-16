//
//  JMVipRenewController.m
//  XLMM
//
//  Created by zhang on 16/7/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMVipRenewController.h"
#import "JMOrderPayView.h"
#import "WXApi.h"
#import "WebViewController.h"
#import "JMRichTextTool.h"
#import "JMPayment.h"
#import "JMOrderListController.h"



@interface JMVipRenewController ()<JMOrderPayViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) UIScrollView *baseScrollView;

@property (nonatomic, strong) UIButton *halfyearButton;

@property (nonatomic, strong) UIButton *allyearButton;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) JMOrderPayView *payView;

@property (nonatomic, assign)BOOL isInstallWX;

@property (nonatomic, assign) BOOL isEnoughBudgetPay;

@property (nonatomic, strong) UILabel *descLabel;

@end



@implementation JMVipRenewController {
    NSDictionary *_renewDic;
    // 支付请求参数
    NSString *_productID;   // 产品ID
    NSString *_skuID;
    NSString *_payment;     // 实际支付
    NSString *_channel;     // 支付方式
    NSString *_num;         // 商品个数
    NSString *_postfee;     // 运费
    NSString *_discounefee; // 优惠金额
    NSString *_orderID;     // 订单编号
    NSString *_totalfee;    // 实际支付
    CGFloat _descLabelValue;// 抵扣金额
    NSInteger _numCount;
    
    CGFloat _walletCash;     // 小鹿钱包的金额
    
    CGFloat _wxOraliPayment; // 如果钱包金额不足支付
    
    NSString *_exchangeType; // 选择续费的类型 --> 半年或者一年
    BOOL isAgreeTerms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"小鹿妈妈身份续费" selecotr:@selector(backClick:)];
    
    [self createRenewView];
    [self initView];
    [self loadDataSource];
    
    if ([WXApi isWXAppInstalled]) {
        //  NSLog(@"安装了微信");
        self.isInstallWX = YES;
    }
    else{
        self.isInstallWX = NO;
    }
    _numCount = 1;
}
- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/get_register_pro_info",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }else {
            _renewDic = [NSDictionary dictionary];
            _renewDic = responseObject[@"product"];
            [self upDataRenew:responseObject];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)upDataRenew:(NSDictionary *)renewDic {
    NSDictionary *productDic = renewDic[@"product"];
    _productID = productDic[@"id"];
    _orderID = renewDic[@"uuid"];
    
//    NSArray *payinfosArr = renewDic[@"payinfos"];
//    NSDictionary *walletCashDic = payinfosArr[0];
//    _walletCash = [walletCashDic[@"wallet_cash"] floatValue];
    _walletCash = self.cashValue;
    
    NSArray *skusArr = _renewDic[@"normal_skus"];
    NSDictionary *renewDict = skusArr[_numCount];
    CGFloat paument = [renewDict[@"agent_price"] floatValue];
    _skuID = renewDict[@"id"];
    if (_walletCash - paument > 0.00001) {
        self.isEnoughBudgetPay = YES;
        _descLabelValue = paument;
        _exchangeType = @"half";
    }else {
        _wxOraliPayment = paument - _walletCash;
        _descLabelValue = _walletCash;
        self.isEnoughBudgetPay = NO;
    }
    self.descLabel.text = [NSString stringWithFormat:@"默认使用小鹿妈妈钱包金额抵扣%.2f元 \n\n 为确保您的权利和权益，请尽快续费。",_descLabelValue];
}

- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)]];
    
    JMOrderPayView *payView = [[JMOrderPayView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 180, SCREENWIDTH, 180)];
    self.payView = payView;
    self.payView.delegate = self;
    self.payView.cs_w = SCREENWIDTH;

}
- (void)createRenewView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
//    UIScrollView *baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    [self.view addSubview:baseScrollView];
//    self.baseScrollView = baseScrollView;
//    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, 610);
//    self.baseScrollView.showsHorizontalScrollIndicator = NO;
//    self.baseScrollView.showsVerticalScrollIndicator = NO;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 280)];
//    [self.baseScrollView addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 480)];
//    [self.baseScrollView addSubview:footView];
    footView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footView;
    
    // headView //
    UIButton *halfyearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [halfyearButton setBackgroundImage:[UIImage imageNamed:@"MaMaRenewHalfyear_Nomal"] forState:UIControlStateNormal];
    [halfyearButton setBackgroundImage:[UIImage imageNamed:@"MaMaRenewHalfyear_Selected"] forState:UIControlStateSelected];
    [headView addSubview:halfyearButton];
    self.halfyearButton = halfyearButton;
    self.halfyearButton.tag = 100;
    self.halfyearButton.selected = YES;
    [self.halfyearButton addTarget:self action:@selector(renewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *allyearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allyearButton setBackgroundImage:[UIImage imageNamed:@"MaMaRenewAllyear_Nomal"] forState:UIControlStateNormal];
    [allyearButton setBackgroundImage:[UIImage imageNamed:@"MaMaRenewAllyear_Selected"] forState:UIControlStateSelected];
    [headView addSubview:allyearButton];
    self.allyearButton = allyearButton;
    self.allyearButton.tag = 101;
    [self.allyearButton addTarget:self action:@selector(renewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *currentView = [UIView new];
    [headView addSubview:currentView];
    currentView.backgroundColor = [UIColor lineGrayColor];
    
    // footView //
    UILabel *titleLabel = [UILabel new];
    [footView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16.];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.text = @"保卫我的三大特权";
    
    UIImageView *image1 = [UIImageView new];
    [footView addSubview:image1];
    image1.image = [UIImage imageNamed:@"MaMaExplainFirst"];
    
    UIImageView *image2 = [UIImageView new];
    [footView addSubview:image2];
    image2.image = [UIImage imageNamed:@"MaMaExplainSecond"];
    
    UIImageView *image3 = [UIImageView new];
    [footView addSubview:image3];
    image3.image = [UIImage imageNamed:@"MaMaExplainThird"];
    
    UILabel *notesLabel = [UILabel new];
    [footView addSubview:notesLabel];
    notesLabel.text = @"注意事项";
    notesLabel.textColor = [UIColor buttonTitleColor];
    notesLabel.font = [UIFont boldSystemFontOfSize:16.];
    
    UILabel *descNotesLabel = [UILabel new];
    [footView addSubview:descNotesLabel];
    descNotesLabel.numberOfLines = 0;
    descNotesLabel.text = @"99元包含半年小鹿美美大数据系统使用权；188元包含一年小鹿美美大数据系统使用权，此外188元用户附加权限每活跃一天会员期限增加一天。";
    descNotesLabel.textColor = [UIColor dingfanxiangqingColor];
    descNotesLabel.font = [UIFont systemFontOfSize:13.];
    
    UIView *lineView = [UIView new];
    [footView addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    UILabel *termsLabel = [UILabel new];
    [footView addSubview:termsLabel];
    termsLabel.font = [UIFont systemFontOfSize:13.];
    NSString *termStr = @"我已阅读并同意小鹿美美购买条款";
    termsLabel.attributedText = [JMRichTextTool cs_changeColorWithColor:[UIColor buttonEnabledBackgroundColor] AllString:termStr SubStringArray:@[@"小鹿美美购买条款"]];
    termsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *termsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsTapClick:)];
    [termsLabel addGestureRecognizer:termsTap];
    
    UIButton *termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:termsButton];
    [termsButton setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
    [termsButton setImage:[UIImage imageNamed:@"termsImage"] forState:UIControlStateSelected];
    //    termsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -SCREENWIDTH + 40);
    termsButton.tag = 103;
    termsButton.selected = YES;
    isAgreeTerms = YES;
    [termsButton addTarget:self action:@selector(renewButton:) forControlEvents:UIControlEventTouchUpInside];

    
    UILabel *titleLabel1 = [UILabel new];
    [footView addSubview:titleLabel1];
    titleLabel1.font = [UIFont systemFontOfSize:13.];
    titleLabel1.textColor = [UIColor dingfanxiangqingColor];
    titleLabel1.numberOfLines = 0;
    titleLabel1.text = @"推荐奖金:招代理邀请奖金最高可达110元/每人。";
    
    UILabel *titleLabel2 = [UILabel new];
    [footView addSubview:titleLabel2];
    titleLabel2.font = [UIFont systemFontOfSize:13.];
    titleLabel2.textColor = [UIColor dingfanxiangqingColor];
    titleLabel2.numberOfLines = 0;
    titleLabel2.text = @"销售佣金:销售单品佣金提成比率8-30%，考试可快速提升佣金。";
    
    UILabel *titleLabel3 = [UILabel new];
    [footView addSubview:titleLabel3];
    titleLabel3.font = [UIFont systemFontOfSize:13.];
    titleLabel3.textColor = [UIColor dingfanxiangqingColor];
    titleLabel3.numberOfLines = 0;
    titleLabel3.text = @"点击补贴:一份耕耘一分收获，每次基础点击0.1-1元。";
    
    UIView *bottomView = [UIView new];
    [footView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [UIView new];
    [bottomView addSubview:view1];
    view1.backgroundColor = [UIColor countLabelColor];
    
    UILabel *descLabel = [UILabel new];
    [view1 addSubview:descLabel];
    descLabel.font = [UIFont systemFontOfSize:13.];
    descLabel.textColor = [UIColor buttonTitleColor];
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel = descLabel;
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:sureButton];
    self.sureButton = sureButton;
    self.sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.sureButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = 20.;
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.tag = 102;
    [self.sureButton addTarget:self action:@selector(renewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat space = (SCREENWIDTH - 280) / 3;
    
    kWeakSelf

//    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(weakSelf.baseScrollView);
//        make.top.equalTo(weakSelf.baseScrollView);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@280);
//    }];
    [self.halfyearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(space);
        make.top.equalTo(headView).offset(66);
        make.width.mas_equalTo(@143);
        make.height.mas_equalTo(@165.5);
    }];
    [self.allyearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.halfyearButton.mas_right).offset(space);
        make.top.equalTo(headView).offset(66);
        make.width.mas_equalTo(@143);
        make.height.mas_equalTo(@165.5);
    }];
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headView);
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(headView).offset(-1);
    }];
    
//    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headView.mas_bottom);
//        make.left.equalTo(weakSelf.baseScrollView);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(@210);
//    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).offset(17);
        make.centerX.equalTo(footView.mas_centerX);
    }];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(30);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.mas_equalTo(@30);
    }];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(30);
        make.top.equalTo(image1.mas_bottom).offset(22);
        make.width.height.mas_equalTo(@30);
    }];
    [image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(30);
        make.top.equalTo(image2.mas_bottom).offset(22);
        make.width.height.mas_equalTo(@30);
    }];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image1.mas_right).offset(15);
        make.right.equalTo(footView.mas_right).offset(-15);
        make.centerY.equalTo(image1.mas_centerY);
    }];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image2.mas_right).offset(15);
        make.right.equalTo(footView.mas_right).offset(-15);
        make.centerY.equalTo(image2.mas_centerY);
    }];
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image3.mas_right).offset(15);
        make.right.equalTo(footView.mas_right).offset(-15);
        make.centerY.equalTo(image3.mas_centerY);
    }];
    [notesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image3.mas_bottom).offset(22);
        make.left.equalTo(footView).offset(30);
    }];
    [descNotesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notesLabel);
        make.top.equalTo(notesLabel.mas_bottom).offset(5);
        make.right.equalTo(footView.mas_right).offset(-15);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descNotesLabel.mas_bottom).offset(10);
        make.left.right.equalTo(footView);
        make.height.mas_equalTo(@10);
    }];
    [termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.left.equalTo(footView).offset(30);
    }];
    [termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView).offset(-20);
        make.centerY.equalTo(termsLabel.mas_centerY);
    }];
    
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(footView);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@120);
    }];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bottomView);
        make.height.mas_equalTo(@60);
    }];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view1).offset(-5);
        make.centerX.equalTo(view1.mas_centerX);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView).offset(-10);
        make.height.mas_equalTo(@40);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
    }];
    
    
    
}
- (void)termsTapClick:(UITapGestureRecognizer *)tap {
    NSMutableDictionary *dictionDic = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:@"%@/static/tiaokuan.html",Root_URL];
    [dictionDic setValue:urlString forKey:@"web_url"];
    WebViewController *webView = [[WebViewController alloc] init];
    webView.webDiction = [NSMutableDictionary dictionaryWithDictionary:dictionDic];
    webView.isShowNavBar =true;
    webView.isShowRightShareBtn=false;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)payMoney {
    NSArray *skusArr = _renewDic[@"normal_skus"];
    NSDictionary *renewDic = skusArr[_numCount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"product_id"] = _productID;
//    params[@"sku_id"] = renewDic[@"id"];
//    params[@"payment"] = renewDic[@"agent_price"];
//    params[@"channel"] = _channel;
//    params[@"num"] = @"1";
//    params[@"post_fee"] = @"0.00";
//    params[@"discount_fee"] = @"0.00";
//    params[@"uuid"] = _orderID;
//    params[@"total_fee"] = renewDic[@"std_sale_price"];
    params[@"product_id"] = _productID;
    params[@"sku_id"] = renewDic[@"id"];
    params[@"uuid"] = _orderID;
    params[@"post_fee"] = @"0.00";
    params[@"discount_fee"] = @"0.00";
    params[@"total_fee"] = renewDic[@"std_sale_price"];
    params[@"channel"] = _channel;
    params[@"wallet_renew_deposit"] = [NSString stringWithFormat:@"%.2f",_walletCash];
    params[@"payment"] = [NSString stringWithFormat:@"%.2f",_wxOraliPayment];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/mama_register_pay",Root_URL];
    
//    JMVipRenewController * __weak weakSelf = self;
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlStr WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [MBProgressHUD hideHUD];
        
//        NSError *parseError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
//        NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [JMPayment createPaymentWithType:thirdPartyPayMentTypeForWechat Parame:responseObject URLScheme:kUrlScheme ErrorCodeBlock:^(JMPayError *error) {
                NSLog(@"%ld",error.errorStatus);
                if (error.errorStatus == payMentErrorStatusSuccess) {
                    [self paySuccessful];
                }else if (error.errorStatus == payMentErrorStatusFail) { // 取消
                    [self popview];
                }else { }
            }];
//            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//                if (error == nil) {
//                    [MBProgressHUD showSuccess:@"支付成功"];
//                    [MobClick event:@"renewBuy_succ"];
//                } else {
//                    if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
//                        [MBProgressHUD showError:@"用户取消支付"];
//                        [MobClick event:@"renewBuy_cancel"];
//                    } else {
//                        [MBProgressHUD showError:@"支付失败"];
//                        NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",(unsigned long)error.code]};
//                        [MobClick event:@"renewBuy_fail" attributes:temp_dict];
//                    }
//                    
//                }
//                
//            }];
        });
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"续费失败,请稍后尝试 ~~(>_<)~~ !"];
    } Progress:^(float progress) {
        
    }];
}

- (void)xiaoluPay:(NSString *)exchangeType {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/exchange_deposit",Root_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"exchange_type"] = exchangeType;
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD showSuccess:@"续费成功......"];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
    
}

#pragma mark --- 支付成功的弹出框
- (void)paySuccessful{
    [MobClick event:@"renewBuy_succ"];
    [self.navigationController popViewControllerAnimated:YES];
    [JMNotificationCenter removeObserver:self name:@"ZhifuSeccessfully" object:nil];
}
- (void)popview{
    [MobClick event:@"renewBuy_cancel"];
    JMOrderListController *orderVC = [[JMOrderListController alloc] init];
    orderVC.currentIndex = 101;
    [self.navigationController pushViewController:orderVC animated:YES];
}
/**
 *  / // 支付请求参数
 NSString *_productID;   // 产品ID
 NSString *_skuID;
 NSString *_payment;     // 实际支付
 NSString *_channel;     // 支付方式
 NSString *_num;         // 商品个数
 NSString *_postfee;     // 运费
 NSString *_discounefee; // 优惠金额
 NSString *_orderID;     // 订单编号
 NSString *_totalfee;    // 实际支付
 *
 *  @param button
 */
- (void)renewButton:(UIButton *)button {
    if (button.tag == 100) {
        self.halfyearButton.selected = !self.halfyearButton.selected;
        self.halfyearButton.selected = YES;
        self.allyearButton.selected = NO;

        _numCount = 1;
        
        NSArray *skusArr = _renewDic[@"normal_skus"];
        NSDictionary *renewDic = skusArr[_numCount];
        CGFloat paument = [renewDic[@"agent_price"] floatValue];
        _skuID = renewDic[@"id"];
        if (_walletCash - paument > 0.00001) {
            self.isEnoughBudgetPay = YES;
            _exchangeType = @"half";
            _descLabelValue = paument;
        }else {
            self.isEnoughBudgetPay = NO;
            _wxOraliPayment = paument - _walletCash;
            _descLabelValue = _walletCash;
        }
        
        self.descLabel.text = [NSString stringWithFormat:@"默认使用小鹿妈妈钱包金额抵扣%.2f元 \n\n 为确保您的权利和权益，请尽快续费。",_descLabelValue];
    }else if (button.tag == 101) {
        self.allyearButton.selected = !self.allyearButton.selected;
        self.allyearButton.selected = YES;
        self.halfyearButton.selected = NO;

        _numCount = 0;
        
        NSArray *skusArr = _renewDic[@"normal_skus"];
        NSDictionary *renewDic = skusArr[_numCount];
        CGFloat paument = [renewDic[@"agent_price"] floatValue];
        _skuID = renewDic[@"id"];
        if (_walletCash - paument > 0.00001) {
            self.isEnoughBudgetPay = YES;
            _exchangeType = @"full";
            _descLabelValue = paument;
        }else {
            self.isEnoughBudgetPay = NO;
            _wxOraliPayment = paument - _walletCash;
            _descLabelValue = _walletCash;
        }
        self.descLabel.text = [NSString stringWithFormat:@"默认使用小鹿妈妈钱包金额抵扣%.2f元 \n\n 为确保您的权利和权益，请尽快续费。",_descLabelValue];
    }else if (button.tag == 102){
        if (isAgreeTerms) {
            if (self.isEnoughBudgetPay) {
                _channel = @"budget";

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要全部用妈妈钱包金额续费吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                
            }else {
                [self createPayPopView];
            }
        }else {
            [MBProgressHUD showWarning:@"请您阅读和同意购买条款!"];
        }
    }else {
        button.selected = !button.selected;
        if (button.selected) {
            isAgreeTerms = YES;
        }else {
            isAgreeTerms = NO;
        }
    }


}

#pragma mark --- 选择支付方式
- (void)composePayButton:(JMOrderPayView *)payButton didClick:(NSInteger)index {
    if (index == 100) { // 点击了返回按钮 -- 弹出框  选择放弃或者继续支付
        
        [self payBackAlter];
        
    }else if (index == 101) { //点击了微信支付
        [MBProgressHUD showLoading:@"正在支付中....."];
        if (!self.isInstallWX) {
            [MBProgressHUD showError:@"亲，没有安装微信哦"];
            return;
        }
        _channel = @"wx";
        [self hidePickerView];
        [self payMoney];
        
    }else if (index == 102) { //点击了支付宝支付
        [MBProgressHUD showLoading:@"正在支付中....."];
        _channel = @"alipay";
        [self hidePickerView];
        [self payMoney];
    }else {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"取消妈妈钱包全额支付");
    } else if (buttonIndex == 1){
        NSLog(@"妈妈钱包全额支付");
        [self xiaoluPay:_exchangeType];
    }
}

#pragma mark ----  支付弹出框 点击去结算按钮的时候弹出
- (void)createPayPopView {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.payView];
    self.maskView.alpha = 0;
    self.payView.cs_x = self.view.cs_h - 150;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.payView.bottom = self.view.cs_h;
    }];
}
/**
 *  隐藏
 */
- (void)hidePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.payView.cs_x = self.view.cs_h;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.payView removeFromSuperview];
    }];
}

#pragma mark ---- 点击返回按钮 弹出警告框 --> 选择放弃或者继续
- (void)payBackAlter {
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"请及时续费会员哦!享受多多优惠." delegate:self cancelButtonTitle:@"忍痛放弃" otherButtonTitles:@"开心续费", nil];
    alterView.tag = 888;
    [alterView show];
}
//- (void)viewDidLayoutSubviews {
//    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH, 610);
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [JMNotificationCenter addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    
    [MobClick beginLogPageView:@"JMVipRenewController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMVipRenewController"];
}
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    [JMNotificationCenter removeObserver:self];
}
@end














































































