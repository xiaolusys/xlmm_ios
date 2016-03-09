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
    
    BOOL paySucceed;
    NSString *coupon_message;
    NSString *errorCharge;
    UIAlertView *alertViewError;
    
    BOOL isWallPay;
    NSString *mamaqianbaoInfo;
    
    
  
}

@property (nonatomic, strong)NSMutableArray *MutCatrsArray;     //购物车数组
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoImageView;//选中图片
@property (weak, nonatomic) IBOutlet UIImageView *wxImageView;      //未选中图片

@end

@implementation PurchaseViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    if ([WXApi isWXAppInstalled]) {
      //  NSLog(@"安装了微信");
        self.weixinView.hidden = YES;
        
    }
    else{
    //    NSLog(@"没有安装微信");
        self.weixinView.hidden = NO;
        payMethod = @"alipay";
        self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
        /*
         icon-radio.png
         icon-radio-select.png
         wx
         alipay
         
         */
   //     NSLog(@"zhifu = %@", payMethod);
        
    }

    
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
    
    payMethod = @"alipay";
    
    
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

- (void)downloadCartsData{
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.cartsArray.count == 0) {
        //购物车为空。
      //  NSLog(@"购物车为空");
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
  //  NSLog(@"cartsURLString = %@", urlString);
    
   
    //下载购物车支付界面数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] ];
        
        if (data == nil) {
         //   NSLog(@"下载失败");
        }
        [self performSelectorOnMainThread:@selector(fetchedCartsData2:) withObject:data waitUntilDone:YES];
    });
}

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
    NSLog(@"dic = %@", dic);
    
    NSArray *array = [dic objectForKey:@"cart_list"];
    
    
    coupon_message = [dic objectForKey:@"coupon_message"];
    
  //  NSLog(@"coupon_message= %@", coupon_message);
    
    uuid = [dic objectForKey:@"uuid"];
    cartIDs = [dic objectForKey:@"cart_ids"];
    totalfee = [[dic objectForKey:@"total_fee"] floatValue];
    totalPayment = [[dic objectForKey:@"total_payment"] floatValue];
    postfee = [[dic objectForKey:@"post_fee"] floatValue];
    discountfee = [[dic objectForKey:@"discount_fee"] floatValue];
    NSLog(@"--->>>%@", [dic objectForKey:@"coupon_ticket"]);
    
    //self.totalFeeLabel.text = [NSString stringWithFormat:@"合计:¥%.1f", totalfee];
    self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.1f", totalPayment];
    self.postFeeLabel.text = [NSString stringWithFormat:@"¥%.1f", postfee];
    self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f", discountfee];
    self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", totalPayment];
    
    
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
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    
    if ([[dic objectForKey:@"budget_payable"] boolValue]) {
        isWallPay = YES;
    } else {
        isWallPay = NO;
    }
    
    if ([coupon_message isEqualToString:@""]) {
        NSLog(@"okokoko");
        
    } else {
        
        alertViewError = [[UIAlertView alloc] initWithTitle:nil message:coupon_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertViewError.tag = 2000;
        [alertViewError show];
        
        
    }
    
    // NSLog(@"****************");
}

-(void) performDismiss:(NSTimer *)timer
{
    self.couponLabel.hidden = YES;
    yhqModel = nil;
    
      [self downloadCartsData];
    [alertViewError dismissWithClickedButtonIndex:0 animated:NO];
}


- (void)fetchedCartsData:(NSData *)responseData{
    NSError *error = nil;
    // 返回数据为空 异常处理。。。。
    if (responseData == nil) {
        return;
    }
 
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

    if (error != nil) {
        NSLog(@"解析失败");
    }
    NSLog(@"dic = %@", dic);
    
    NSArray *array = [dic objectForKey:@"cart_list"];
    
    
    coupon_message = [dic objectForKey:@"coupon_message"];
    
   // NSLog(@"coupon_message= %@", coupon_message);
    
    if ([coupon_message isEqualToString:@""]) {
        NSLog(@"okokoko");
        
    } else {
        
        yhqModel = nil;
        alertViewError = [[UIAlertView alloc] initWithTitle:nil message:coupon_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];

        alertViewError.tag = 2000;
        
        
        [alertViewError show];
        return;
        
    }
   
    uuid = [dic objectForKey:@"uuid"];
    cartIDs = [dic objectForKey:@"cart_ids"];
    totalfee = [[dic objectForKey:@"total_fee"] floatValue];
    totalPayment = [[dic objectForKey:@"total_payment"] floatValue];
    postfee = [[dic objectForKey:@"post_fee"] floatValue];
    discountfee = [[dic objectForKey:@"discount_fee"] floatValue];
    NSLog(@"--->>>%@", [dic objectForKey:@"coupon_ticket"]);
    
    self.totalFeeLabel.text = [NSString stringWithFormat:@"合计:¥%.1f", totalfee];
    self.postFeeLabel.text = [NSString stringWithFormat:@"¥%.1f", postfee];
    self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f", discountfee];
    self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", totalPayment];
    self.totalFeeLabel.text = [NSString stringWithFormat:@"合计¥%.1f", totalPayment];
    
    
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
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];

    
   
    
   // NSLog(@"****************");
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
    //NSLog(@"使用优惠券");

    
    
   // NSLog(@"选择优惠券");
    YouHuiQuanViewController *vc = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
    vc.isSelectedYHQ = YES;
    vc.payment = totalfee;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)downloadCartsData2{
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.cartsArray.count == 0) {
        //购物车为空。
        //  NSLog(@"购物车为空");
        return;
    }
    //构造参数字符串
    for (NewCartsModel *model in self.cartsArray) {
        NSString *str = [NSString stringWithFormat:@"%d,",model.ID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    NSString *urlString;
    if (yhqModel == nil) {
         urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@", Root_URL,paramstring];
        
        
    } else {
  urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@&coupon_id=%@", Root_URL,paramstring, yhqModel.ID];
    }
   
    
    NSLog(@"cartsURLString = %@", urlString);
    

    
    //下载购物车支付界面数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"url = %@", url);
        if (url == nil) {
            return ;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        NSLog(@"error = %@", error);
        if (data == nil) {
               NSLog(@"下载失败");
            return;
        }
        [self performSelectorOnMainThread:@selector(fetchedCartsData:) withObject:data waitUntilDone:YES];
    });
}



- (void)updateYouhuiquanWithmodel:(YHQModel *)model{
    
    //NSLog(@"立即购买优惠券更新");
    //NSLog(@"model = %@", model);
    yhqModel = model;
    
    
    [self downloadCartsData2];
    if (model == nil) {
        self.couponLabel.hidden = YES;
        
    } else {
        self.couponLabel.text = [NSString stringWithFormat:@"¥%@", model.coupon_value];
        self.couponLabel.textColor = [UIColor buttonEmptyBorderColor];
        self.couponLabel.hidden = NO;
    }
    
    
    //NSLog(@"model.title = %@, %@-%@", yhqModel.title, yhqModel.deadline, yhqModel.created);
    
    //NSLog(@"coupon_id = %@", yhqModel.ID);
    
    //   NSFontAttributeName
}

- (void)updateUI{
    self.youhuijineLabel.text = [NSString stringWithFormat:@"已节省¥%.1f",[yhqModel.coupon_value floatValue]];
    
    discountfee = [yhqModel.coupon_value floatValue];

    float allpay = totalfee - discountfee + postfee;
    
   // NSLog(@"allpay = %.1f", allpay);
    self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", allpay];
    
}
- (IBAction)zhifubaoClicked:(id)sender {
   //  NSLog(@"选择支付宝");
    payMethod = @"alipay";
    self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
    self.wxImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    self.xiaoluimageView.image = [UIImage imageNamed:@"unselected_icon.png"];
  //  NSLog(@"payMethod = %@", payMethod);
    
}



- (IBAction)weixinZhifuClicked:(id)sender {
 //    NSLog(@"选择微信支付");
    payMethod = @"wx";
    self.zhifubaoImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    self.wxImageView.image = [UIImage imageNamed:@"selected_icon.png"];
    self.xiaoluimageView.image = [UIImage imageNamed:@"unselected_icon.png"];
  //  NSLog(@"payMethod = %@", payMethod);

}
- (IBAction)xiaoluqianbaoSelected:(id)sender {
    
    if (isWallPay == YES) {
    
        payMethod = @"budget";
        self.zhifubaoImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
        self.wxImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
        self.xiaoluimageView.image = [UIImage imageNamed:@"selected_icon.png"];
        NSLog(@"payMethod = %@", payMethod);
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"不能使用钱包支付"];
        
        
    }
    
    

    
}
- (IBAction)buyClicked:(id)sender {
  //   NSLog(@"购买商品");
    
    if (addressModel.addressID == nil) {
    //    NSLog(@"地址为空");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请填写收货地址" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //   http://m.xiaolu.so/rest/v1/trades/shoppingcart_create
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/shoppingcart_create", Root_URL];
 //   NSLog(@"urlstring = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    float allpay = totalfee - discountfee + postfee;
    
  //  NSLog(@"allpay = %.1f", allpay);
    
    
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSString* dict;
  //  NSLog(@"youhuiquan.ID = %@", yhqModel.ID);
    
    if (yhqModel.ID == nil) {
        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@",cartIDs,addressModel.addressID ,payMethod, [NSString stringWithFormat:@"%.1f", allpay],[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", discountfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid];
    } else {
        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&coupon_id=%@",cartIDs,addressModel.addressID ,payMethod, [NSString stringWithFormat:@"%.1f", allpay],[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", discountfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid, yhqModel.ID];
    
    }
    
    NSLog(@"dict = %@", dict);
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    PurchaseViewController1 * __weak weakSelf = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"response = %@", httpResponse);
        
        if ([payMethod isEqualToString:@"budget"]) {
          
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"dic = %@", dic);
            
            /*
             dic = {
             channel = budget;
             id = 305313;
             info = "\U8ba2\U5355\U652f\U4ed8\U6210\U529f";
             success = 1;
             */
            MMLOG([dic objectForKey:@"info"]);
            mamaqianbaoInfo = [dic objectForKey:@"info"];
            
            [self performSelectorOnMainThread:@selector(showXiaoluQianbaoView) withObject:nil waitUntilDone:YES];
//            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"info"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alertView show];
           // [SVProgressHUD showInfoWithStatus:[dic objectForKey:@"info"]];
            
            
            
            return ;
        }
        
      
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
        }
        
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"charge = %@", charge);
        errorCharge = charge;
        
        
        
        
        
        
        
        if (httpResponse.statusCode != 200) {
         //   NSLog(@"出错了");
            self.couponLabel.hidden = YES;
            [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:YES];
           
            return;
        }
        
        
        
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                
             //   NSLog(@"completion block: %@", result);
                
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                    paySucceed = YES;
                    
                    [SVProgressHUD showInfoWithStatus:@"支付成功"];
                    
                    
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                    
                    if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
                        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                        
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"支付失败"];
                        
                    }
                    paySucceed = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                //[weakSelf showAlertMessage:result];
            }];
        });
        
        
        
    }];
    
}

- (void)showXiaoluQianbaoView{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:mamaqianbaoInfo delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alertView.tag = 666;
    
    [alertView show];
    
}

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


@end
