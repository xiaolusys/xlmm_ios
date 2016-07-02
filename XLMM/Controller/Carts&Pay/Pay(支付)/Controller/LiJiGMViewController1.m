//
//  LiJiGMViewController1.m
//  XLMM
//
//  Created by younishijie on 15/9/28.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "LiJiGMViewController1.h"
#import "AddressViewController.h"
#import "AddAdressViewController.h"
#import "MMClass.h"
#import "AddressModel.h"
#import "YouHuiQuanViewController.h"
#import "YHQModel.h"
#import "Pingpp.h"
#import "AFNetworking.h"
#import "WXApi.h"
#import "UIViewController+NavigationBar.h"
#import "PersonCenterViewController1.h"
#import "MMUserCoupons.h"
#import "AFNetworking.h"


#define kUrlScheme @"wx25fcb32689872499"
@interface LiJiGMViewController1 ()<YouhuiquanDelegate>

@end

@implementation LiJiGMViewController1{
    AddressModel *addressModel;
    float price;
    float allprice;
    float yunfeifee;
    float youhuifee;
    float allpay;
    NSNumber *buyNumber;
    YHQModel *yhqModel;
    NSString *zhifuSelected;
    NSString *uuid;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelZhifu:) name:@"CancleZhifu" object:nil];

    self.containterWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [self downloadAddressData];

    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        self.weixinView.hidden = YES;
        
    }
    else{
        NSLog(@"没有安装微信");
        self.weixinView.hidden = NO;
         self.zhifuHeight.constant = 80;
        zhifuSelected = @"alipay";
        self.weixinImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
        self.zhifuImageView.image = [UIImage imageNamed:@"selected_icon.png"];
        /*
         icon-radio.png
         icon-radio-select.png
         wx
         alipay
         
         */
        NSLog(@"zhifu = %@", zhifuSelected);

    }
    if (yhqModel == nil) {
        self.yhqImageView.hidden = YES;
    } else{
        self.yhqImageView.hidden = NO;
    }
 

    
}


- (void)cancelZhifu:(NSNotification *)notification{
    NSLog(@"取消支付了");
    [self.navigationController pushViewController:[[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:nil] animated:YES];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CancleZhifu" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"确认订单";

    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backButtonClicked:)];

    buyNumber = @1;
    zhifuSelected = @"alipay";
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/now_payinfo?sku_id=%@", Root_URL,self.skuID];
  
    NSLog(@"sku_id = %@, ",self.skuID);
    
    NSLog(@"urlString = %@", urlString);
    
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDetailsData:)];
    self.buyButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];

    
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    self.buyButton.layer.cornerRadius = 20;
 
    MMUserCoupons *coupons = [[MMUserCoupons alloc] init];
    if (coupons.couponValue == 0) {
       // self.couponButton.enabled = NO;
        self.couponLabel.hidden = NO;
        self.couponImageView.hidden = YES;
    } else {
     //   self.couponButton.enabled = YES;
        self.couponLabel.hidden = YES;
        self.couponImageView.hidden = NO;
        
        
    }
  
    
    
}

- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}



- (void)setDetailsInfo{
    
}

- (void)fetchedDetailsData:(NSData *)responseData{
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"dic = %@", dic);
    
    NSLog(@"---------------");
    __unused NSDictionary *coupon_ticket = [dic objectForKey:@"coupon_ticket"];
    NSLog(@"coupon_ticket = %@", coupon_ticket);
    NSLog(@"---------------");
    
    
    
    NSDictionary *dic2 = [dic objectForKey:@"sku"];
    NSDictionary *dic3 = [dic2 objectForKey:@"product"];
    self.myimageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic3 objectForKey:@"pic_path"]]]];
    // self.myimageView.image = [UIimage im dic3 objectForKey:@"pic_path"]]];
    self.myimageView.layer.masksToBounds = YES;
    self.myimageView.layer.cornerRadius = 8;
    self.myimageView.layer.borderWidth = 0.5;
    self.myimageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    
    
    
    self.sizeLabel.text = [dic2 objectForKey:@"name"];
    self.nameLabel.text = [dic3 objectForKey:@"name"];
    price = [[dic2 objectForKey:@"agent_price"] floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dic2 objectForKey:@"agent_price"] floatValue]];
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic2 objectForKey:@"std_sale_price"]];
    allprice = [[dic objectForKey:@"total_fee"]floatValue];
    self.allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%.1f", [[dic objectForKey:@"total_fee"] floatValue]];
    yunfeifee = [[dic objectForKey:@"post_fee"]floatValue];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"¥%.0f", [[dic objectForKey:@"post_fee"] floatValue]];
    youhuifee = [[dic objectForKey:@"discount_fee"] floatValue];
    self.youhuiLabel.text = [NSString stringWithFormat:@"已节省¥%.0f", [[dic objectForKey:@"discount_fee"] floatValue]];
    allpay = [[dic objectForKey:@"total_payment"] floatValue];
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dic objectForKey:@"total_payment"] floatValue]];
    self.numberLabel.text = @"1";
    uuid = [dic objectForKey:@"uuid"];
    

    
}

- (void)downloadAddressData{
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/address.json", Root_URL];
    NSLog(@"url = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    if (data == nil) {
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"address = %@", array);
    if (array.count == 0) {
        NSLog(@"地址为空");
        self.shouhuodizhi.text = @"";
        self.shouhuoren.text = @"";
        self.addressZeroLabel.hidden = NO;
        self.modifyButton.userInteractionEnabled = NO;
        return;
        
    } else {
        self.addressZeroLabel.hidden = YES;
        self.modifyButton.userInteractionEnabled = YES;
    }
    NSDictionary *dic = [array firstObject];
    addressModel = [AddressModel new];
    addressModel.provinceName = [dic objectForKey:@"receiver_state"];
    addressModel.cityName = [dic objectForKey:@"receiver_city"];
    addressModel.countyName = [dic objectForKey:@"receiver_district"];
    addressModel.streetName = [dic objectForKey:@"receiver_address"];
    addressModel.buyerName = [dic objectForKey:@"receiver_name"];
    addressModel.phoneNumber = [dic objectForKey:@"receiver_mobile"];
    addressModel.addressID = [dic objectForKeyedSubscript:@"id"];
    
//    @property (nonatomic, retain)NSString *provinceName;
//    @property (nonatomic, retain)NSString *cityName;
//    @property (nonatomic, retain)NSString *countyName;
//    @property (nonatomic, copy)NSString *streetName;
//    @property (nonatomic, copy)NSString *buyerName;
//    @property (nonatomic, copy)NSString *phoneNumber;
    
    
    
    NSString *shouhuoren = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"receiver_name"],[dic objectForKey:@"receiver_mobile"]];
    NSString *shouhuoAddress = [NSString stringWithFormat:@"%@-%@-%@-%@", [dic objectForKey:@"receiver_state"], [dic objectForKey:@"receiver_city"], [dic objectForKey:@"receiver_district"], [dic objectForKey:@"receiver_address"]];
    self.shouhuodizhi.text = shouhuoAddress;
    self.shouhuoren.text = shouhuoren;
    
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

- (IBAction)addAddressClicked:(id)sender {
    NSLog(@"增加地址");
    AddressViewController *addVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

- (IBAction)modifyAddressClicked:(id)sender {
    NSLog(@"修改地址");
    AddAdressViewController *addVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
    addVC.isAdd = NO;
    addVC.addressModel = addressModel;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)reduceClicked:(id)sender {
    NSLog(@"----");
    int i = [buyNumber intValue];
    i--;
    if (i == 0) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"至少买一件嘛" delegate:nil
                                             cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [view show];
        i = 1;
    }
    allprice = price * i;
    self.allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%.1f", allprice];
    allpay = allprice + yunfeifee -youhuifee;
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%.1f", allpay];
    buyNumber = [NSNumber numberWithInt:i];
    self.numberLabel.text = [buyNumber stringValue];
    
}

- (IBAction)plusClicked:(id)sender {
    
    int i = [buyNumber intValue];
    i++;
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/carts/sku_num_enough", Root_URL];
    NSLog(@"url = %@", string);
    NSURL *url = [NSURL URLWithString:string];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = [NSString stringWithFormat:@"sku_id=%@&sku_num=%i", self.skuID, i];//设置参数
    NSLog(@"params = %@", str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:&error];
    NSLog(@"dic = %@", dic);
    if ([[dic objectForKey:@"sku_id"]integerValue] == [self.skuID integerValue]) {
        NSLog(@"ok");
    } else{
        i--;
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"库存不足赶快下单" delegate:nil
                                             cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [view show];
    }
    allprice = price * i;
    self.allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%.1f", allprice];
    allpay = allprice + yunfeifee -youhuifee;
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%.1f", allpay];
    
    buyNumber = [NSNumber numberWithInt:i];
    self.numberLabel.text = [buyNumber stringValue];
    NSLog(@"++++");
}

- (IBAction)selectYouhuiClicked:(id)sender {
    NSLog(@"选择优惠券");
    YouHuiQuanViewController *vc = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
    vc.isSelectedYHQ = YES;
    vc.payment = allprice;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
- (void)updateYouhuiquanWithmodel:(YHQModel *)model{
    
    NSLog(@"立即购买优惠券更新");
    NSLog(@"model = %@", model);
    yhqModel = model;
    
    
    NSLog(@"model.title = %@, %@-%@", yhqModel.title, yhqModel.deadline, yhqModel.created);
    
    NSLog(@"coupon_id = %@", yhqModel.ID);

    
    self.yhqCreateLabel.text = yhqModel.created;
    self.yhqdeadlineLabel.text = yhqModel.deadline;
    self.yhqNameLabel.text = yhqModel.title;
    youhuifee = [yhqModel.coupon_value intValue];
    
   
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥%@", yhqModel.coupon_value];
//    allpay -= [yhqModel.coupon_value intValue];
    self.allPaymentLabel.text = [NSString stringWithFormat:@"￥%.1f", allpay - [yhqModel.coupon_value floatValue]];
}

- (IBAction)zhifubaoClicked:(id)sender {
    NSLog(@"支付宝支付");
    zhifuSelected = @"alipay";
    self.weixinImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    self.zhifuImageView.image = [UIImage imageNamed:@"selected_icon.png"];
    /*
     icon-radio.png
     icon-radio-select.png
     wx
     alipay
     
    */
    NSLog(@"zhifu = %@", zhifuSelected);
    
}

- (IBAction)weixinClicked:(id)sender {
    NSLog(@"微信支付");
    zhifuSelected = @"wx";
    self.weixinImageView.image = [UIImage imageNamed:@"selected_icon.png"];
    self.zhifuImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
 
       NSLog(@"zhifu = %@", zhifuSelected);
}

- (IBAction)buyClicked:(id)sender {
    NSLog(@"购买！！");
    
    float payment = allprice + yunfeifee - youhuifee;

    NSLog(@"应付金额：%.1f", payment);

    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/buynow_create", Root_URL];
    NSLog(@"urlstring = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSString* dict;
    if (yhqModel.ID == nil) {
        dict = [NSString stringWithFormat:@"addr_id=%@&channel=%@&payment=%.1f&post_fee=%@&discount_fee=%@&total_fee=%.1f&uuid=%@&item_id=%@&sku_id=%@&num=%@",addressModel.addressID ,zhifuSelected, payment,[NSNumber numberWithInt:yunfeifee],[NSNumber numberWithInt:youhuifee],allprice,uuid, self.itemID, self.skuID, buyNumber];
    } else {
   dict = [NSString stringWithFormat:@"addr_id=%@&channel=%@&payment=%.1f&post_fee=%@&discount_fee=%@&total_fee=%.1f&uuid=%@&item_id=%@&sku_id=%@&num=%@&coupon_id=%@",addressModel.addressID ,zhifuSelected, payment,[NSNumber numberWithInt:yunfeifee],[NSNumber numberWithInt:youhuifee],allprice,uuid, self.itemID, self.skuID, buyNumber, yhqModel.ID];
    }
   
    uuid = nil;
    
    
    
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", dict);
    // NSLog(@"string ------>>>%@", bodyData);
    NSLog(@"data = ---->>>>%@", data);
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    LiJiGMViewController1 * __weak weakSelf = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //  [self showAlertWait];
    
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"response = %@", httpResponse);
        
        NSLog(@"data = %@", data);
        __unused NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"dataString = %@", str);
        if (httpResponse.statusCode != 200) {
            NSLog(@"出错了");
            //  return;
        }
        
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
            return;
        }
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"charge = %@", charge);
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"diction = %@", diction);
        __unused NSString *chargeID = [diction objectForKey:@"order_no"];
        
        NSLog(@"chargeID = %@", chargeID);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                
                NSLog(@"completion block: %@", result);
                
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
        });

    }];

}
@end
