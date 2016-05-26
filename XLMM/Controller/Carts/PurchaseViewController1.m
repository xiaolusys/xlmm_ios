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
#import "PersonOrderViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "GoodsInfoModel.h"

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

@property (nonatomic,strong) BuyCartsView *cartOwner;

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

/**
 *  判断优惠券是否可用
 */
@property (nonatomic, assign)BOOL isCanCoupon;

/**
 *  优惠券是否满足条件
 */
@property (nonatomic, assign)BOOL isEnoughCoupon;


@property (nonatomic, assign)BOOL isEnoughRight;
@property (nonatomic, assign)BOOL isEnoughBudget;

@property (nonatomic, assign)BOOL isUserCoupon;

@property (nonatomic, assign)BOOL isInstallWX;
@property (nonatomic, assign)BOOL isAgreeTerms;

/**
 *  获取商品购买商品ID
 */
@property (nonatomic ,strong) NSMutableString *paramstring;
/**
 *  优惠券信息
 */
@property (nonatomic,copy) NSString *couponMessage;


@end


@implementation PurchaseViewController1





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
    self.isAgreeTerms = YES;
    
    MMUserCoupons *coupons = [[MMUserCoupons alloc] init];
    if (coupons.couponValue == 0) {
        self.couponLabel.hidden = NO;
        self.couponImageView.hidden = YES;
        
        
    } else {
        self.couponImageView.hidden = NO;
        self.couponLabel.hidden = YES;
    }
    
//    [self initMsgTextField];
    //can not editable
    self.tfMsg.userInteractionEnabled = NO;
    
    [self downloadAddressData];

    
    
}
#pragma mark ------ 创建一个请求
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
    self.paramstring = paramstring;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@", Root_URL,paramstring];
//    NSLog(@"------cartsURLString = %@", urlString);
    
   
    //下载购物车支付界面数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] ];
        
        if (data == nil) {
         //   NSLog(@"下载失败");
        }
        [self performSelectorOnMainThread:@selector(fetchedCartsData2:) withObject:data waitUntilDone:YES];
    });
}

#pragma mark ---- 首次数据请求
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
//    NSLog(@"-----------------%@", dic);
    
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
    if(self.MutCatrsArray.count >1){
//        NSLog(@"containter height  %f", self.containterView.frame.size.height  );
        self.containterHeight.constant = self.containterView.frame.size.height + (self.MutCatrsArray.count - 1) * 80;
        
//        NSArray *views = [self.containterView subviews];
//        NSInteger containterHeight = 0;
//        for(UIView* view in views)
//        {
//            containterHeight += view.frame.size.height;
//        }
//        NSLog(@"containter subview height sum %ld", (long)containterHeight);
    }
    
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
        self.cartOwner = cartOwner;
        
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
    if(data == nil) return;
    
    NSError *error = nil;
    
    NSArray *addressArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"下载失败");
        return;
    }
    if ((addressArray == nil) || (addressArray.count == 0)) {
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

#pragma mark ------ 选择优惠券回调过来的代理方法
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
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@&coupon_id=%@", Root_URL,_paramstring,model.ID];
        
        [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSDictionary *dict = [[NSDictionary alloc] init];
            //            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            GoodsInfoModel *goodsModel = [GoodsInfoModel mj_objectWithKeyValues:responseObject];
            self.couponMessage = goodsModel.coupon_message;
            if (self.couponMessage.length == 0) {
                //goodsModel.coupon_message 为空的时候表示优惠券可以使用
                //            self.couponLabel.text = model.coupon_value; // ---- > 优惠额金额
                
                
            }else {
                
                //优惠券不满足条件  提示警告信息
                [SVProgressHUD showInfoWithStatus:goodsModel.coupon_message];
                self.couponLabel.text = @"";
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        

        
        
        
        self.isUserCoupon = YES;
        self.couponLabel.text = [NSString stringWithFormat:@"¥%@元优惠券", model.coupon_value];   // === > 返回可以减少的金额
        self.couponLabel.textColor = [UIColor buttonEmptyBorderColor];
        self.couponLabel.hidden = NO;
        yhqModelID = [NSString stringWithFormat:@"%@", model.ID];
        [self calculationLabelValue];
    }
    
    
    
}

- (IBAction)zhifubaoClicked:(id)sender {
    
//    NSNumber *waitPay =[NSNumber numberWithFloat:totalPayment];
//    NSNumber *avaiPay =[NSNumber numberWithFloat:self.availableFloat];
//    NSLog(@"======wait======%@, %@",  avaiPay, waitPay);
    
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
    
//    NSNumber *waitPay =[NSNumber numberWithFloat:totalPayment];
//    NSNumber *avaiPay =[NSNumber numberWithFloat:self.availableFloat];
//    NSLog(@"======wait======%@, %@",  avaiPay, waitPay);
    //NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
     
    if (!self.isInstallWX) {
        [SVProgressHUD showErrorWithStatus:@"亲，没有安装微信哦"];
        return;
    }
    
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
    
//    if(![[self.tfMsg.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
//    {
//        dict = [NSString stringWithFormat:@"%@&buyer_message=%@", dict, [self.tfMsg.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//    }

    

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
            
            dict = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@", dict, discount,[[NSNumber numberWithFloat:totalPayment] floatValue], @"budget", parms];
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
            
            dict = [NSString stringWithFormat:@"%@&discount_fee=%.2f&payment=%.2f&channel=%@&pay_extras=%@",dict,discount, [[NSNumber numberWithFloat:totalPayment] floatValue], payMethod, parms];
            //提交
            [self submitBuyGoods];
        }

    }
    
    
}

- (IBAction)btnCheckClicked:(id)sender {
    UIImage *image = nil;
    if (self.isAgreeTerms) {
        self.isAgreeTerms = NO;
        image = [UIImage imageNamed:@"confirm2.png"];
    }
    else{
        self.isAgreeTerms = YES;
        image = [UIImage imageNamed:@"confirm.png"];
    }
    [self.btnCheck setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)btnAgreeClicked:(id)sender {
    NSString *terms = @"购买条款：亲爱的小鹿用户，由于特卖商品购买人数过多和供应商供货原因，可能存在极少数用户出现缺货的情况。为了避免您长时间等待，一旦出现这种情况，我们在购买后1周会帮您自动退款，并补偿给您一张全场通用优惠券，给您造成不便，敬请谅解！祝您购物愉快！本条款解释权归小鹿美美特卖商城所有。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买条款" message:terms delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


- (NSMutableDictionary *)stringChangeDictionary:(NSString *)str {
    NSArray *firstArr = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *segment in firstArr) {
        NSArray *secondArr = [segment componentsSeparatedByString:@"="];
        [dic setObject:secondArr[1] forKey:secondArr[0]];
//        [dic ];
    }
    
    return dic;
}

- (void)submitBuyGoods {
    
   NSMutableDictionary *dic = [self stringChangeDictionary:dict];
    
    NSString *postPay = [NSString stringWithFormat:@"%@/rest/v2/trades/shoppingcart_create", Root_URL];

    PurchaseViewController1 * __weak weakSelf = self;
    
    //检查地址
    if (!self.isAgreeTerms) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请您阅读和同意购买条款!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:postPay parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:@"code"] integerValue] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                /**
                 *  在这里判断满多少可以使用  -- 这里是点击提交订单按钮判断
                 */
//                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"info"]];
                [self performSelector:@selector(returnCart) withObject:nil afterDelay:1.0];
            });
            return;
        }if ([[dic objectForKey:@"channel"] isEqualToString:@"budget"] && [[dic objectForKey:@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [self performSelector:@selector(returnOrderList) withObject:nil afterDelay:1.0];
            });
            return;
        }
        
        NSDictionary *chargeDic = [dic objectForKey:@"charge"];
        
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chargeDic options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (![[dic objectForKey:@"channel"] isEqualToString:@"budget"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    if (error == nil) {
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        [self performSelector:@selector(returnOrderList) withObject:nil afterDelay:1.0];
                    } else {
                        if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
                            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"支付失败"];
                        }
                        [self performSelector:@selector(returnCart) withObject:nil afterDelay:1.0];
                    }
                    
                }];
            });
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
 }

- (void)returnCart {
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnOrderList {
    PersonOrderViewController *order = [[PersonOrderViewController alloc] init];
    order.index = 102;
    [self.navigationController pushViewController:order animated:YES];
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
#pragma mark ----- 计算最终需要付款的金额展示
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
                self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.2f", amontPayment - couponValue - rightAmount - canUseWallet];
                //节省
                self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.2f", discount];
                //应付
                self.allPayLabel.text = [NSString stringWithFormat:@"¥%.2f", amontPayment - couponValue - rightAmount - canUseWallet];
                //小鹿钱包
                self.availableLabel.text = [NSString stringWithFormat:@"%.2f", canUseWallet];
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


#pragma mark --留言处理
- (void) initMsgTextField{
    //返回键的类型
    self.tfMsg.returnKeyType = UIReturnKeyDefault;
    //键盘类型
    self.tfMsg.keyboardType = UIKeyboardTypeDefault;
    //[self.tvip becomeFirstResponder];
    
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    
    [self.tfMsg setInputAccessoryView:topView];
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.3f];
    
    //设置view的frame，往上平移
    [self.baseScrollView  setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-self.baseScrollView.frame.size.height, self.view.frame.size.width, self.baseScrollView.frame.size.height)];
    
    [UIView commitAnimations];
    
}
//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    //设置view的frame，往下平移
    [self.baseScrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.baseScrollView.frame.size.height)];
    [UIView commitAnimations];
}

- (void)resignKeyboard{
    [self.tfMsg resignFirstResponder];

}
#pragma mark ---- 视图生命周期处理事件
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    
    //添加键盘的监听事件
    
    //注册通知,监听键盘弹出事件
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    if ([WXApi isWXAppInstalled]) {
        //  NSLog(@"安装了微信");
        self.isInstallWX = YES;
    }
    else{
        self.isInstallWX = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
#pragma mark --- 支付成功的弹出框
- (void)paySuccessful{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alterView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)popview{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
/**
 *  ====== 上一个版本判断优惠券的方式  这个版本判断优惠券的方式为发送一个数据 在服务端判断
 
 //            self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f", afterdiscountfee];
 //            self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", aftertotalPayment];
 //            self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.1f", aftertotalPayment];
 
 //更新小鹿钱包提示信息。。。。。
 // 余额足够 显示  小鹿钱包 ＝ 总金额 － 优惠券金额 － 立减金额。
 // 余额不足   显示  小鹿钱包 ＝ 余额数。。。
 
 
 
 //使用优惠券后
 if (yhqModel && yhqModel.coupon_value) {
 CGFloat couponV = [yhqModel.coupon_value floatValue];
 NSNumber *couponNS = [NSNumber numberWithFloat:couponV];
 NSNumber *totalNS = [NSNumber numberWithFloat:totalPayment];   //最终需要支付的金额
 
 CGFloat aftertotalPayment = 0.00;
 CGFloat afterdiscountfee = 0.00;
 
 if ([totalNS compare:couponNS] == NSOrderedDescending) {
 aftertotalPayment = totalPayment - couponV;
 afterdiscountfee = discountfee + couponV;
 self.isEnoughCoupon = NO;
 NSString *str = model.use_fee_des;
 CGFloat canPay = [[str substringWithRange:NSMakeRange(1, str.length - 3)] floatValue];
 

 *  在这里判断是否可用    判断商品总价格  totalFeeLabel
 maxPay  商品总金额 == 商品总金额减去APP支付立减  +  APP支付立减的金额

CGFloat maxPay = totalPayment + discountfee;
if (maxPay >= canPay) {
    aftertotalPayment = 0.00;
    afterdiscountfee = [[self.couponInfo objectForKey:@"total_payment"] floatValue];
    self.isEnoughCoupon = YES;
}else {
    [SVProgressHUD showInfoWithStatus:model.use_fee_des];
    self.couponLabel.text = @"";
}

}else {
    aftertotalPayment = 0.00;
    afterdiscountfee = [[self.couponInfo objectForKey:@"total_payment"] floatValue];
    self.isEnoughCoupon = YES;
    
}


 */
