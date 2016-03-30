//
//  PurchaseViewController1.m
//  XLMM
//
//  Created by younishijie on 15/10/22.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "PurchaseViewController1.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AddressModel.h"
#import "AddAdressViewController.h"
#import "AddressViewController.h"
#import "NewCartsModel.h"
#import "BuyCartsView.h"
#import "BuyModel.h"
#import "YouHuiQuanViewController.h"
#import "YHQModel.h"
#import "MMUserCoupons.h"
#import "NSString+URL.h"
#import "AFNetworking.h"
#import "Pingpp.h"
#import "WXApi.h"
#define kUrlScheme @"wx25fcb32689872499" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
#import "SVProgressHUD.h"

#import "NSDictionary+UrlEncoding.h"

//购物车支付界面
@interface PurchaseViewController1 ()<YouhuiquanDelegate, UIAlertViewDelegate>{
    AddressModel *addressModel;//默认收货地址
    NSString *payMethod; //支付方式
    NSString *uuid;      //uuid
    NSString *cartIDs;   //购物车id
    YHQModel *yhqModel;  //优惠券
    float totalfee;      //总金额
    float totalPayment;  //应付款金额
    float postfee;       //运费金额
    float discountfee;   //优惠券金额
    
    float couponValue;//优惠券金额
    float amontPayment;//总需支付金额
    float canUseWallet;
    float rightAmount;
    
    float discount;
    
    BOOL paySucceed;
    NSString *coupon_message;
    NSString *errorCharge;
    UIAlertView *alertViewError;
    
    BOOL isWallPay;
    NSString *mamaqianbaoInfo;
    
    NSString *yhqModelID;
    
    NSArray *pay_extras;
    
     NSString *dict;
    
    float lijianpay;
    
   
}

@property (nonatomic, strong)NSMutableArray *MutCatrsArray;     //购物车数组
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoImageView;//选中图片
@property (weak, nonatomic) IBOutlet UIImageView *wxImageView;      //未选中图片

@property (nonatomic, strong)NSString *availableString;
@property (nonatomic, assign)CGFloat availableFloat;
@property (nonatomic, assign)BOOL isUseXLW;

@property (nonatomic, assign)NSInteger userPayMent;
@property (nonatomic, assign)NSInteger enough;

@property (nonatomic, strong)NSDictionary *rightReduce;
@property (nonatomic, strong)NSDictionary *xlWallet;
@property (nonatomic, strong)NSDictionary *couponInfo;

@property (nonatomic, assign)BOOL isCanCoupon;


@property (nonatomic, assign)BOOL isEnoughCoupon;
@property (nonatomic, assign)BOOL isEnoughRight;
@property (nonatomic, assign)BOOL isEnoughBudget;

@property (nonatomic, assign)BOOL isUserCoupon;

@end


@implementation PurchaseViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
//    if ([WXApi isWXAppInstalled]) {
//      //  NSLog(@"安装了微信");
//        self.weixinView.hidden = YES;
//        
//    }
//    else{
//    //    NSLog(@"没有安装微信");
//        self.weixinView.hidden = NO;
//        payMethod = @"alipay";
//        self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
//        /*
//         icon-radio.png
//         icon-radio-select.png
//         wx
//         alipay
//         
//         */
//   //     NSLog(@"zhifu = %@", payMethod);
//        
//    }

    
}

- (void)paySuccessful{
    
  //  NSLog(@"恭喜你支付成功，");
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alterView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];

}
- (void)dealloc{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backButtonClicked:)];
    self.addressViewWidth.constant = SCREENWIDTH;
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    self.buyButton.layer.cornerRadius = 20;
    self.MutCatrsArray = [[NSMutableArray alloc] initWithCapacity:0];
    addressModel = [AddressModel new];
    [self downloadCartsData];
    
//    payMethod = @"alipay";
    
    
    self.xlwButton.selected = NO;
    self.alipayButton.selected = NO;
    self.wxButton.selected = NO;
    
    self.isUseXLW = NO;
    self.enough = 0;
    
    //新的
    self.isCanCoupon = NO;
    
    self.isEnoughRight = NO;
    self.isEnoughBudget = NO;
    self.isEnoughCoupon = NO;
    
    self.isUserCoupon = NO;
    
    MMUserCoupons *coupons = [[MMUserCoupons alloc] init];
    if (coupons.couponValue == 0) {
        self.couponLabel.hidden = NO;
        self.couponImageView.hidden = YES;
        
        
    } else {
        self.couponImageView.hidden = NO;
        self.couponLabel.hidden = YES;
    }
    
    [self downloadAddressData];

    
    
}

//首次进来请求数据
- (void)downloadCartsData{
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.cartsArray.count == 0) {
        return;
    }
    //构造参数字符串
    for (NewCartsModel *model in self.cartsArray) {
        NSString *str = [NSString stringWithFormat:@"%d,",model.ID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@", Root_URL,paramstring];
    NSLog(@"------cartsURLString = %@", urlString);
    
   
    //下载购物车支付界面数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] ];
        
        if (data == nil) {
         //   NSLog(@"下载失败");
        }
        [self performSelectorOnMainThread:@selector(fetchedCartsData2:) withObject:data waitUntilDone:YES];
    });
}

//首次数据请求
- (void)fetchedCartsData2:(NSData *)responseData{
    NSError *error = nil;
    if (responseData == nil) {
        NSLog(@"无数据");
        return;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"解析失败");
    }
    NSLog(@"-----------------%@", dic);
    
    NSArray *array = [dic objectForKey:@"cart_list"];
    coupon_message = [dic objectForKey:@"coupon_message"];

    pay_extras = [dic objectForKey:@"pay_extras"];
    
    amontPayment = [[dic objectForKey:@"total_payment"] floatValue];
    
    totalPayment = [[dic objectForKey:@"total_payment"] floatValue];
    discountfee = [[dic objectForKey:@"discount_fee"] floatValue];
    for (NSDictionary *dicExtras in pay_extras) {
        //优惠券
        if ([[dicExtras objectForKey:@"pid"] integerValue] == 2) {
            self.couponInfo = dicExtras;
            if ([[dicExtras objectForKey:@"use_coupon_allowed"] integerValue] == 1) {
                self.isCanCoupon = YES;
            }
            continue;
        }
        //app立减
        if ([[dicExtras objectForKey:@"pid"] integerValue] == 1) {
            self.rightReduce = dicExtras;
            CGFloat appcut = [[dicExtras objectForKey:@"value"] floatValue];
            if ([[dic objectForKey:@"total_payment"] compare:[dicExtras objectForKey:@"value"]] == NSOrderedDescending) {
                totalPayment = totalPayment - appcut;
                discountfee = discountfee + appcut;
            }else {
                //app立减已够使用
                totalPayment = 0.0;
                discountfee = [[dic objectForKey:@"total_payment"] floatValue];
                
                self.isEnoughRight = YES;
            }
            rightAmount = [[dicExtras objectForKey:@"value"] floatValue];
            self.zhifulijianLabel.text = [NSString stringWithFormat:@"APP支付立减%@元哦", dicExtras[@"value"]];
            continue;
        }
        //余额
        if ([[dicExtras objectForKey:@"pid"] integerValue] == 3 && totalPayment > 0) {
            self.xlWallet = dicExtras;
            self.availableFloat = [[dicExtras objectForKey:@"value"] floatValue];
            
            canUseWallet = [[dicExtras objectForKey:@"value"] floatValue];
            //设置小鹿钱包提示信息。。。。
//            self.availableLabel.text = [NSString stringWithFormat:@"本次可用%.2f", self.availableFloat];
            
            if ([[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:totalPayment]] == NSOrderedDescending ||[[dicExtras objectForKey:@"value"] compare:[NSNumber numberWithFloat:totalPayment]] == NSOrderedSame) {
                //足够支付
                self.isEnoughBudget = YES;
            }else {
                //不足支付
                self.isEnoughBudget = NO;
            }
            
        }
    }
    
//    app支付立减
//    self.rightReduce = pay_extras[0];
//    NSString *name = pay_extras[0][@"name"];
//    NSDictionary *pay_ex = pay_extras[0];
//    lijianpay = [pay_ex[@"value"] floatValue];
//    
//    
//    
//    //遍历小鹿钱包
//    self.availableFloat = 0.0;
//    for (NSDictionary *dic in pay_extras) {
//        if ([dic[@"pid"] integerValue] == 3) {
//            self.xlWallet = dic;
//            
//            self.availableString = [NSString stringWithFormat:@"%.2f", [self.xlWallet[@"value"] floatValue]];
//            self.availableFloat = [self.availableString floatValue];
//            
//            self.availableLabel.text = [NSString stringWithFormat:@"本次可用%.2f", self.availableFloat];
//        }
//    }
    
    uuid = [dic objectForKey:@"uuid"];
    cartIDs = [dic objectForKey:@"cart_ids"];
    totalfee = [[dic objectForKey:@"total_fee"] floatValue];
    postfee = [[dic objectForKey:@"post_fee"] floatValue];
    
    [self calculationLabelValue];
    
//    //合计
//    self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.1f", totalPayment];
//    //邮费
//    self.postFeeLabel.text = [NSString stringWithFormat:@"¥%.1f", postfee];
//    //节省
//    self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f", discountfee];
//    //应付
//    self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", totalPayment];


    [self.MutCatrsArray removeAllObjects];
    
    for (NSDictionary *dicInfo in array) {
        BuyModel *model = [BuyModel new];
        
        model.addressID = [dicInfo objectForKey:@"id"];
        model.payment = [dic objectForKey:@"total_payment"];
        model.postFee = [dic objectForKey:@"post_fee"];
        model.discountFee = [dic objectForKey:@"discount_fee"];
        model.totalFee = [dic objectForKey:@"total_fee"];
        totalfee = [[dic objectForKey:@"total_fee"] floatValue];
        model.uuID = [dic objectForKey:@"uuid"];
        model.itemID = [dicInfo objectForKey:@"item_id"];
        model.skuID = [dicInfo objectForKey:@"sku_id"];
        model.buyNumber = [[dicInfo objectForKey:@"num"]integerValue];
        model.imageURL = [dicInfo objectForKey:@"pic_path"];
        model.name = [dicInfo objectForKey:@"title"];
        model.sizeName = [dicInfo objectForKey:@"sku_name"];
        model.price = [dicInfo objectForKey:@"price"];
        model.oldPrice = [dicInfo objectForKey:@"std_sale_price"];
        
        
        [self.MutCatrsArray addObject:model];
    }
    
    //NSLog(@"cartsDataArray = %@", self.MutCatrsArray);
    
    [self createCartsListView];
    
//    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    
//    if ([[dic objectForKey:@"budget_payable"] boolValue]) {
//        isWallPay = YES;
//    } else {
//        isWallPay = NO;
//    }
//    
//    if ([coupon_message isEqualToString:@""]) {
//        NSLog(@"okokoko");
//        
//    } else {
//        
//        alertViewError = [[UIAlertView alloc] initWithTitle:nil message:coupon_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        alertViewError.tag = 2000;
//        [alertViewError show];
//        
//        
//    }
    
    // NSLog(@"****************");
}

-(void)performDismiss:(NSTimer *)timer
{
    self.couponLabel.hidden = YES;
    yhqModel = nil;
    
      [self downloadCartsData];
    [alertViewError dismissWithClickedButtonIndex:0 animated:NO];
}


- (void)createCartsListView{
    BuyCartsView * cartOwner = [BuyCartsView new];
    self.detailsViewHeight.constant = self.MutCatrsArray.count * 80;
    
    for (int i = 0; i<self.MutCatrsArray.count; i++) {
        
        BuyModel *model = [self.MutCatrsArray objectAtIndex:i];
        [[NSBundle mainBundle] loadNibNamed:@"BuyCartsView" owner:cartOwner options:nil];
        
        cartOwner.view.frame = CGRectMake(0, i*80, SCREENWIDTH, 80);
        // cartOwner.view.backgroundColor = [UIColor redColor];
        
        cartOwner.nameLabel.text = model.name;
        cartOwner.sizeLabel.text = model.sizeName;
        cartOwner.numberLabel.text = [NSString stringWithFormat:@"x%@",[[NSNumber numberWithInteger:model.buyNumber ]stringValue]];
        
        cartOwner.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", [model.price floatValue]];
     
       // cartOwner.myImageView.image = [UIImage imagewithURLString:[model.imageURL URLEncodedString]];
        [cartOwner.myImageView sd_setImageWithURL:[NSURL URLWithString:[model.imageURL URLEncodedString]]];
        cartOwner.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        cartOwner.myImageView.layer.masksToBounds = YES;
        cartOwner.myImageView.layer.cornerRadius = 5;
        cartOwner.myImageView.layer.borderWidth = 0.5;
        cartOwner.myImageView.layer.borderColor = [UIColor lineGrayColor].CGColor;
        
        
        [self.detailsView addSubview:cartOwner.view];
        
    }
}

- (void)downloadAddressData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kAddress_List_URL]];
      //  NSLog(@"addressListURL = %@", kAddress_List_URL);
        
        
        [self performSelectorOnMainThread:@selector(fetchedAddressData:) withObject:data waitUntilDone:YES];
        
        
    });
}

- (void)fetchedAddressData:(NSData *)data{
    NSError *error = nil;
    
    NSArray *addressArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"下载失败");
        return;
    }
    if (addressArray.count == 0) {
        self.peopleLabel.text = @"";
        self.addressLabel.text = @"";
        self.addressZeroLabel.hidden = NO;
        self.addressZeroLabel.text = @"请填写收货地址";
        return;
    } else {
        self.addressZeroLabel.hidden = YES;
    }
    NSDictionary *dic = [addressArray objectAtIndex:0];
   // NSLog(@"dic = %@", dic);
    addressModel.buyerName = [dic objectForKey:@"receiver_name"];     //收货人名字
    addressModel.phoneNumber = [dic objectForKey:@"receiver_mobile"]; //收货人手机号
    addressModel.provinceName = [dic objectForKey:@"receiver_state"]; //省
    addressModel.cityName = [dic objectForKey:@"receiver_city"];      //市
    addressModel.countyName = [dic objectForKey:@"receiver_district"];//区
    addressModel.streetName = [dic objectForKey:@"receiver_address"]; //街道
    addressModel.addressID = [dic objectForKey:@"id"];                //地址id
    self.peopleLabel.text = [NSString stringWithFormat:@"%@ %@", addressModel.buyerName, addressModel.phoneNumber];
    self.addressLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",addressModel.provinceName, addressModel.cityName, addressModel.countyName, addressModel.streetName];
}

- (void)backButtonClicked:(UIButton *)button{
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

- (IBAction)addAddress:(id)sender {
    //NSLog(@"新增地址");
    AddressViewController *addVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    addVC.isSelected = YES;
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)yhqClicked:(id)sender {
    if (!self.isCanCoupon) {
        [SVProgressHUD showInfoWithStatus:@"当前优惠券不能使用！"];
        return;
    }
    
    YouHuiQuanViewController *vc = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
    vc.isSelectedYHQ = YES;
    vc.payment = totalfee;
    vc.delegate = self;
    vc.selectedModelID = yhqModelID;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)updateYouhuiquanWithmodel:(YHQModel *)model{
    //优惠券一定可以使用
    yhqModel = model;
    
    couponValue = [yhqModel.coupon_value floatValue];
    
    if (model == nil) {
        self.couponLabel.hidden = YES;
        yhqModelID = @"";
        //未使用优惠券
        self.isUserCoupon = NO;
        [self calculationLabelValue];
    } else {
        self.isUserCoupon = YES;
        
        self.couponLabel.text = [NSString stringWithFormat:@"¥%@", model.coupon_value];
        self.couponLabel.textColor = [UIColor buttonEmptyBorderColor];
        self.couponLabel.hidden = NO;
        yhqModelID = [NSString stringWithFormat:@"%@", model.ID];
        
        //使用优惠券后
        if (yhqModel && yhqModel.coupon_value) {
            CGFloat couponV = [yhqModel.coupon_value floatValue];
            NSNumber *couponNS = [NSNumber numberWithFloat:couponV];
            NSNumber *totalNS = [NSNumber numberWithFloat:totalPayment];
            
            CGFloat aftertotalPayment = 0.00;
            CGFloat afterdiscountfee = 0.00;
            
            if ([totalNS compare:couponNS] == NSOrderedDescending) {
                aftertotalPayment = totalPayment - couponV;
                afterdiscountfee = discountfee + couponV;
                self.isEnoughCoupon = NO;
            }else {
                aftertotalPayment = 0.00;
                afterdiscountfee = [[self.couponInfo objectForKey:@"total_payment"] floatValue];
                self.isEnoughCoupon = YES;
            }
            
            [self calculationLabelValue];
//            self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f", afterdiscountfee];
//            self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", aftertotalPayment];
//            self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.1f", aftertotalPayment];
            
            //更新小鹿钱包提示信息。。。。。
            // 余额足够 显示  小鹿钱包 ＝ 总金额 － 优惠券金额 － 立减金额。
            // 余额不足   显示  小鹿钱包 ＝ 余额数。。。
            
        }

    }
}

- (void)updateUI{
//    self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f", discountfee];
//    self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", totalPayment];
//    self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.1f", totalPayment];
}

- (IBAction)zhifubaoClicked:(id)sender {
    
    NSNumber *waitPay =[NSNumber numberWithFloat:totalPayment];
    NSNumber *avaiPay =[NSNumber numberWithFloat:self.availableFloat];
    NSLog(@"======wait======%@, %@",  avaiPay, waitPay);
    
    if (self.isEnoughBudget && self.isUseXLW) {
        //支付宝可选可不选
        self.alipayButton.selected = !self.alipayButton.selected;
        
        if (self.alipayButton.selected) {
            self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
            self.wxImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
            self.wxButton.selected = NO;
            payMethod = @"alipay";
        }else {
            self.zhifubaoImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
            payMethod = nil;
        }
    }else {
        payMethod = @"alipay";
        self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
        self.wxImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    }
}


- (IBAction)weixinZhifuClicked:(id)sender {
    
    NSNumber *waitPay =[NSNumber numberWithFloat:totalPayment];
    NSNumber *avaiPay =[NSNumber numberWithFloat:self.availableFloat];
    NSLog(@"======wait======%@, %@",  avaiPay, waitPay);
    //NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
    
    if (self.isEnoughBudget && self.isUseXLW) {
        //微信可选可不选
        self.wxButton.selected = !self.wxButton.selected;
        
        if (self.wxButton.selected) {
            self.wxImageView.image = [UIImage imageNamed:@"selected_icon.png"];
            self.zhifubaoImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
            self.alipayButton.selected = NO;
            payMethod = @"wx";
        }else {
            self.wxImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
            payMethod = nil;
        }
    }else {
        payMethod = @"wx";
        self.wxImageView.image = [UIImage imageNamed:@"selected_icon.png"];
        self.zhifubaoImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    }

}
- (IBAction)xiaoluqianbaoSelected:(id)sender {
    if (self.availableFloat > 0) {
        self.xlwButton.selected = !self.xlwButton.selected;
        
        if (self.xlwButton.selected) {
            self.xiaoluimageView.image = [UIImage imageNamed:@"selected_icon.png"];
            self.isUseXLW = YES;
            [self calculationLabelValue];
        }else {
            self.xiaoluimageView.image = [UIImage imageNamed:@"unselected_icon.png"];
            self.isUseXLW = NO;
            [self calculationLabelValue];
        }
    }else {
        //钱包不可用
        [SVProgressHUD showInfoWithStatus:@"钱包不可用"];
    }
    
}
- (IBAction)buyClicked:(id)sender {
    //检查地址
    if (addressModel.addressID == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请填写收货地址" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    //检查支付方式
    
//    pid:1:value:2
    NSString *parms = [NSString stringWithFormat:@"pid:%@:value:%@",self.rightReduce[@"pid"],self.rightReduce[@"value"]];
//    NSString *parms = nil;
    
    dict = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&post_fee=%@&total_fee=%@&uuid=%@",cartIDs,addressModel.addressID,[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid];
    

//    [NSString stringWithFormat:@"pid:%@:value:%@",self.xlWallet[@"pid"],self.xlWallet[@"value"]];
    //是否使用了优惠券
    if (self.isUserCoupon && self.isEnoughCoupon) {
        //足够
        totalPayment = 0.00;
        discountfee = discountfee + [yhqModel.coupon_value floatValue];
        
        //拼提交信息
        parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:use_coupon_allowed:%.2f", parms,  [self.couponInfo objectForKey:@"pid"], yhqModel.ID, [yhqModel.coupon_value floatValue]];
        dict = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%@&channel=%@&pay_extras=%@",dict,discount,[NSNumber numberWithFloat:totalPayment], @"budget", parms];
        //提交
        [self submitBuyGoods];
    }else {
        if (self.isUserCoupon) {
            //使用不足
            parms = [NSString stringWithFormat:@"%@,pid:%@:couponid:%@:value:%.2f", parms,  [self.couponInfo objectForKey:@"pid"], yhqModel.ID, [yhqModel.coupon_value floatValue]];
            discountfee = discountfee + [yhqModel.coupon_value floatValue];
            
            NSLog(@"----->%.2f", discountfee);
        }else{
            
            //未使用
            if (!self.isUseXLW && payMethod == nil) {
                [SVProgressHUD showErrorWithStatus:@"请至少选择一种支付方式"];
                return;
            }
        }
        
        //不足需要使用小鹿钱包或者其它支付方式
        totalPayment = totalPayment - [yhqModel.coupon_value floatValue];
//        discountfee = discountfee + [yhqModel.coupon_value floatValue];
        if (self.isUseXLW && (self.isEnoughBudget || totalPayment < (self.availableFloat + [yhqModel.coupon_value floatValue]) || totalPayment == (self.availableFloat + [yhqModel.coupon_value floatValue]))) {
            //使用了小鹿钱包 足够提交信息
            CGFloat value = [[self.xlWallet objectForKey:@"value"] floatValue];
            if (totalPayment > value) {
                parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [self.xlWallet objectForKey:@"pid"], value];
            }else {
                parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [self.xlWallet objectForKey:@"pid"], totalPayment];
            }
            
            dict = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@", dict, discountfee,[[NSNumber numberWithFloat:totalPayment] floatValue], @"budget", parms];
            //提交
            [self submitBuyGoods];
        }else {
            if (self.isUseXLW) {
                //使用不足
                CGFloat value = [[self.xlWallet objectForKey:@"value"] floatValue];
                if (totalPayment > value) {
                    parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [self.xlWallet objectForKey:@"pid"], value];
                }else {
                    parms = [NSString stringWithFormat:@"%@,pid:%@:budget:%.2f", parms, [self.xlWallet objectForKey:@"pid"], totalPayment];
                }
            }else {
                //未使用
                if (payMethod == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
                    return;
                }
            }
            
            if (payMethod == nil) {
                [SVProgressHUD showErrorWithStatus:@"余额不足请选择支付方式"];
                return;
            }
            
            dict = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@",dict,discountfee, [[NSNumber numberWithFloat:totalPayment] floatValue], payMethod, parms];
            //提交
            [self submitBuyGoods];
        }

    }
    
//    if (!([avaiPay compare:waitPay] == NSOrderedAscending) && self.isUseXLW) {
//        //小鹿钱包钱大于或者等于待支付且选择了小鹿钱包支付
////        accoutM = [NSString stringWithFormat:@"pid:%@:value:%@",self.xlWallet[@"pid"],self.xlWallet[@"value"]];
//        self.enough = 1;
//        
//    }else {
//        //选择了支付宝或者微信的一种，小鹿钱包不一定选择
//        if (payMethod == nil) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一种支付方式" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            return;
//        }
////        if (self.isUseXLW) {
////            accoutM = [NSString stringWithFormat:@"pid:%@:value:%@",self.xlWallet[@"pid"],self.xlWallet[@"value"]];
////        }
//    }
//    
        //   http://m.xiaolu.so/rest/v1/trades/shoppingcart_create
    
    //    if (yhqModel.ID == nil) {
//        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&pay_extras=%@",cartIDs,addressModel.addressID ,payMethod, [NSString stringWithFormat:@"%.1f", allpay],[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", discountfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid, parms];
//    } else {
//        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&coupon_id=%@&pay_extras=%@",cartIDs,addressModel.addressID ,payMethod, [NSString stringWithFormat:@"%.1f", allpay],[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", discountfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid, yhqModel.ID, parms];
//    }
    
//    NSLog(@"********************%ld", (long)self.userPayMent);
////    return;
//    NSLog(@"dict = %@", dict);
}


- (NSDictionary *)returnDic:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *str1 in arr) {
        NSArray *keyAndV  = [str1 componentsSeparatedByString:@"="];
        [dic setObject:keyAndV[1] forKey:keyAndV[0]];
    }
    return dic;
}

- (void)submitBuyGoods {
    NSLog(@"dict---%@", dict);
    
//   NSDictionary *test = [self returnDic:dict];
////
//    NSString *str = [test urlEncodedString];
    
    NSString *postPay = [NSString stringWithFormat:@"%@/rest/v2/trades/shoppingcart_create", Root_URL];
    NSURL *url = [NSURL URLWithString:postPay];
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    
    PurchaseViewController1 * __weak weakSelf = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@", postRequest);
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"response = %@", httpResponse);
        if (httpResponse.statusCode != 200) {
            //出错
            self.couponLabel.hidden = YES;
            return;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"-------%@", dic);
//        NSLog(@"-------%@", dic[@"info"]);
        
        if ([[dic objectForKey:@"code"] integerValue] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"info"]];
                [self performSelector:@selector(returnCart) withObject:nil afterDelay:1.0];
            });
            return;
        }if ([[dic objectForKey:@"channel"] isEqualToString:@"budget"] && [[dic objectForKey:@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [self performSelector:@selector(returnCart) withObject:nil afterDelay:1.0];
            });
            return;
        }
        
        NSDictionary *chargeDic = [dic objectForKey:@"charge"];
        
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chargeDic options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"-----------%@", parseError);
//        NSLog(@"==========%@", charge);
        
        if (![[dic objectForKey:@"channel"] isEqualToString:@"budget"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    if (error == nil) {
//                        paySucceed = YES;
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                        if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
                            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"支付失败"];
                        }
//                        paySucceed = NO;
                    }
                    [self performSelector:@selector(returnCart) withObject:nil afterDelay:1.0];
        
                }];
            });
        }
        
        
        
        //        if (self.userPayMent == 1 || self.userPayMent == 2) {
        //
        //        }
        
        //        if ([payMethod isEqualToString:@"budget"]) {
        //
        //            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //
        //            NSLog(@"dic = %@", dic);
        //
        //            /*
        //             dic = {
        //             channel = budget;
        //             id = 305313;
        //             info = "\U8ba2\U5355\U652f\U4ed8\U6210\U529f";
        //             success = 1;
        //             */
        //            MMLOG([dic objectForKey:@"info"]);
        //            mamaqianbaoInfo = [dic objectForKey:@"info"];
        //
        //            [self performSelectorOnMainThread:@selector(showXiaoluQianbaoView) withObject:nil waitUntilDone:YES];
        ////
        ////            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"info"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        ////            [alertView show];
        //           // [SVProgressHUD showInfoWithStatus:[dic objectForKey:@"info"]];
        //
        //
        //
        //            return ;
        //        }
        //
        //
        //        if (connectionError != nil) {
        //            NSLog(@"error = %@", connectionError);
        //        }
        //
        //        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"charge = %@", charge);
        //        errorCharge = charge;
        //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //        errorCharge = [dic objectForKey:@"detail"];
        //
        //
        //        if (httpResponse.statusCode != 200) {
        //         //   NSLog(@"出错了");
        //            self.couponLabel.hidden = YES;
        //            [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:YES];
        //
        //            return;
        //        }
        //
        //
        //
        //
        
        
        
    }];

    
}

- (void)returnCart {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)showXiaoluQianbaoView{
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:mamaqianbaoInfo delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    alertView.tag = 666;
//    
//    [alertView show];
//    
//}

- (void)showAlertView{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorCharge delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //[self.navigationController popViewControllerAnimated:YES];
    
    self.couponLabel.hidden = YES;
    yhqModel = nil;
    if (alertView.tag == 2000) {
        return;
    } else if (alertView.tag == 666){
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    [self downloadCartsData];
}


- (void)addressView:(AddressViewController *)addressVC model:(AddressModel *)model{
    
    NSLog(@"%@", model);
    addressModel = model;
    NSLog(@"addressID = %@", addressModel.addressID);
    
    self.peopleLabel.text = [NSString stringWithFormat:@"%@ %@", model.buyerName, model.phoneNumber];
    self.addressLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",model.provinceName, model.cityName, model.countyName, model.streetName];
}

- (void)calculationLabelValue {
    discount = couponValue + rightAmount;
    if (discount - amontPayment > 0.000001) {
        
        discount = amontPayment;
        //合计
        self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.2f", 0.00];
        //节省
        self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.2f", amontPayment];
        //应付
        self.allPayLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
        //小鹿钱包
        self.availableLabel.text = [NSString stringWithFormat:@"%.2f", 0.00];
    }else {
        if (self.isUseXLW) {
            CGFloat surplus = amontPayment - couponValue - rightAmount;
            if (canUseWallet - surplus > 0.000001 || (fabs(canUseWallet - surplus) < 0.000001 || fabs(surplus - couponValue) < 0.000001)) {
                //钱包金额够实用
                //合计
                self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.2f", 0.00];
                //节省
                self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.2f", discount];
                //应付
                self.allPayLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
                //小鹿钱包
                self.availableLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }else {
                //合计
                self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.2f", 0.00];
                //节省
                self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.2f", discount];
                //应付
                self.allPayLabel.text = [NSString stringWithFormat:@"¥%.2f", 0.00];
                //小鹿钱包
                self.availableLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }
        }else {
            //未使用
            CGFloat surplus = amontPayment - couponValue - rightAmount;
            if (canUseWallet - surplus > 0.000001 || (fabs(canUseWallet - surplus) < 0.000001 || fabs(surplus - couponValue) < 0.000001)) {
                //钱包金额够实用
                self.availableLabel.text = [NSString stringWithFormat:@"%.2f", surplus];
            }else {
                self.availableLabel.text = [NSString stringWithFormat:@"%.2f", canUseWallet];
            }
            //合计
            self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.2f", amontPayment  - discount];
            //节省
            self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.2f", discount];
            //应付
            self.allPayLabel.text = [NSString stringWithFormat:@"¥%.2f", amontPayment  - discount];
        }
    }
}

@end
