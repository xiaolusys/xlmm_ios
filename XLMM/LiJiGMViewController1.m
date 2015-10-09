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


#define kUrlScheme @"wx25fcb32689872499"
@interface LiJiGMViewController1 ()<YouhuiquanDelegate>

@end

@implementation LiJiGMViewController1{
    AddressModel *addressModel;
    int price;
    int allprice;
    int yunfeifee;
    int youhuifee;
    int allpay;
    NSNumber *buyNumber;
    YHQModel *yhqModel;
    NSString *zhifuSelected;
    NSString *uuid;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.containterWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [self downloadAddressData];
    [self downloadYouhuiData];

    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        
        
    }
    else{
        NSLog(@"没有安装微信");
        
         self.zhifuHeight.constant = 80;
        zhifuSelected = @"alipay";
        self.weixinImageView.image = [UIImage imageNamed:@"icon-radio.png"];
        self.zhifuImageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
        /*
         icon-radio.png
         icon-radio-select.png
         wx
         alipay
         
         */
        NSLog(@"zhifu = %@", zhifuSelected);

    }
 

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    

    buyNumber = @1;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/now_payinfo?sku_id=%@", Root_URL,self.skuID];
  
    NSLog(@"sku_id = %@, ",self.skuID);
    
    NSLog(@"urlString = %@", urlString);
    
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDetailsData:)];
    
  
    
    
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
- (void)downloadYouhuiData{
    NSString *urlstring = [NSString stringWithFormat:@"%@/rest/v1/usercoupons.json", Root_URL];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSLog(@"url = %@", urlstring);
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    if (data == nil) {
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"youhuiquan = %@", array);
    NSInteger number = 0;
    for (NSDictionary *dic in array) {
        NSLog(@"dic = %@", dic);
        if ([[dic objectForKey:@"status"]integerValue] == 0) {
            NSLog(@"可用优惠券");
            number++;
            
            NSLog(@"可用优惠券(%ld)", (long)number);
        }
    }
    self.usableNumber.text = [NSString stringWithFormat:@"可用优惠券（%ld）", (long)number];
    
    
    // http://m.xiaolu.so/rest/v1/usercoupons
}


- (void)setDetailsInfo{
    
}

- (void)fetchedDetailsData:(NSData *)responseData{
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"dic = %@", dic);
    
    NSLog(@"---------------");
    NSDictionary *coupon_ticket = [dic objectForKey:@"coupon_ticket"];
    NSLog(@"coupon_ticket = %@", coupon_ticket);
    NSLog(@"---------------");
    
    
    
    NSDictionary *dic2 = [dic objectForKey:@"sku"];
    NSDictionary *dic3 = [dic2 objectForKey:@"product"];
    self.myimageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic3 objectForKey:@"pic_path"]]]];
    // self.myimageView.image = [UIimage im dic3 objectForKey:@"pic_path"]]];
    self.sizeLabel.text = [dic2 objectForKey:@"name"];
    self.nameLabel.text = [dic3 objectForKey:@"name"];
    price = (int)[[dic2 objectForKey:@"agent_price"] integerValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [dic2 objectForKey:@"agent_price"]];
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic2 objectForKey:@"std_sale_price"]];
    allprice = (int)[[dic objectForKey:@"total_fee"]integerValue];
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"total_fee"]];
    yunfeifee = (int)[[dic objectForKey:@"post_fee"]integerValue];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"post_fee"]];
    youhuifee = (int)[[dic objectForKey:@"discount_fee"] integerValue];
    self.youhuiLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"discount_fee"]];
    allpay = (int)[[dic objectForKey:@"total_payment"] integerValue];
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"total_payment"]];
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
        self.modifyButton.userInteractionEnabled = NO;
        return;
        
    } else {
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
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%i", allprice];
    allpay = allprice + yunfeifee -youhuifee;
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%i", allpay];
    buyNumber = [NSNumber numberWithInt:i];
    self.numberLabel.text = [buyNumber stringValue];
    
}

- (IBAction)plusClicked:(id)sender {
    
    int i = [buyNumber intValue];
    i++;
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/carts/sku_num_enough", Root_URL];
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
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%i", allprice];
    allpay = allprice + yunfeifee -youhuifee;
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%i", allpay];
    
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
    self.allPaymentLabel.text = [NSString stringWithFormat:@"￥%d", allpay - [yhqModel.coupon_value intValue]];
}

- (IBAction)zhifubaoClicked:(id)sender {
    NSLog(@"支付宝支付");
    zhifuSelected = @"alipay";
    self.weixinImageView.image = [UIImage imageNamed:@"icon-radio.png"];
    self.zhifuImageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
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
    self.weixinImageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
    self.zhifuImageView.image = [UIImage imageNamed:@"icon-radio.png"];
 
       NSLog(@"zhifu = %@", zhifuSelected);
}

- (IBAction)buyClicked:(id)sender {
    NSLog(@"购买！！");
    
    int payment = allprice + yunfeifee - youhuifee;

    NSLog(@"应付金额：%i", payment);

    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/buynow_create", Root_URL];
    NSLog(@"urlstring = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSString* dict = [NSString stringWithFormat:@"addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&item_id=%@&sku_id=%@&num=%@",addressModel.addressID ,zhifuSelected, [NSNumber numberWithInt:payment],[NSNumber numberWithInt:yunfeifee],[NSNumber numberWithInt:youhuifee],[NSNumber numberWithInt:allprice],uuid, self.itemID, self.skuID, buyNumber];
    
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
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
