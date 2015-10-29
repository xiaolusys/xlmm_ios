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
#import "AddressView.h"
#import "BuyCartsView.h"
#import "BuyModel.h"
#import "YouHuiQuanViewController.h"
#import "YHQModel.h"
#import "AFNetworking.h"
#import "Pingpp.h"
#import "WXApi.h"
#define kUrlScheme @"wx25fcb32689872499" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。


//购物车支付界面
@interface PurchaseViewController1 ()<YouhuiquanDelegate>{
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
    
    
  
}

@property (nonatomic, strong)NSMutableArray *MutCatrsArray;     //购物车数组
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoImageView;//选中图片
@property (weak, nonatomic) IBOutlet UIImageView *wxImageView;      //未选中图片

@end

@implementation PurchaseViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self downloadAddressData];
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        self.weixinView.hidden = YES;
        
    }
    else{
        NSLog(@"没有安装微信");
        self.weixinView.hidden = NO;
        payMethod = @"alipay";
        self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
        /*
         icon-radio.png
         icon-radio-select.png
         wx
         alipay
         
         */
        NSLog(@"zhifu = %@", payMethod);
        
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backButtonClicked:)];
    self.addressViewWidth.constant = SCREENWIDTH;
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor colorWithR:217 G:140 B:13 alpha:1].CGColor;
    self.buyButton.layer.cornerRadius = 20;
    self.MutCatrsArray = [[NSMutableArray alloc] initWithCapacity:0];
    addressModel = [AddressModel new];
    [self downloadCartsData];
    
    payMethod = @"alipay";
    
    
}

- (void)downloadCartsData{
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.cartsArray.count == 0) {
        //购物车为空。
        NSLog(@"购物车为空");
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
    NSLog(@"cartsURLString = %@", urlString);
   
    //下载购物车支付界面数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (data == nil) {
            NSLog(@"下载失败");
        }
        [self performSelectorOnMainThread:@selector(fetchedCartsData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedCartsData:(NSData *)responseData{
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"解析失败");
    }
    NSLog(@"dic = %@", dic);
    
    NSArray *array = [dic objectForKey:@"cart_list"];
    
    
    
   
    uuid = [dic objectForKey:@"uuid"];
    cartIDs = [dic objectForKey:@"cart_ids"];
    totalfee = [[dic objectForKey:@"total_fee"] floatValue];
    totalPayment = [[dic objectForKey:@"total_payment"] floatValue];
    postfee = [[dic objectForKey:@"post_fee"] floatValue];
    discountfee = [[dic objectForKey:@"discount_fee"] floatValue];
    NSLog(@"--->>>%@", [dic objectForKey:@"coupon_ticket"]);
    
    self.totalFeeLabel.text = [NSString stringWithFormat:@"合计:¥%.1f", totalfee];
    self.postFeeLabel.text = [NSString stringWithFormat:@"¥%.1f", postfee];
    self.youhuijineLabel.text = [NSString stringWithFormat:@"已优惠¥%.1f", discountfee];
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

    NSLog(@"cartsDataArray = %@", self.MutCatrsArray);
    
    [self createCartsListView];
    
    NSLog(@"****************");
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
     
        cartOwner.myImageView.image = [UIImage imagewithURLString:model.imageURL];
        cartOwner.myImageView.layer.masksToBounds = YES;
        cartOwner.myImageView.layer.cornerRadius = 5;
        cartOwner.myImageView.layer.borderWidth = 0.5;
        cartOwner.myImageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
        
        
        [self.detailsView addSubview:cartOwner.view];
        
    }
}

- (void)downloadAddressData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kAddress_List_URL]];
        NSLog(@"addressListURL = %@", kAddress_List_URL);
        
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
        self.peopleLabel.text = @"新增收货地址";
        self.addressLabel.text = @"";
        return;
    }
    NSDictionary *dic = [addressArray objectAtIndex:0];
    NSLog(@"dic = %@", dic);
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
    NSLog(@"新增地址");
    AddressViewController *addVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];

    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)yhqClicked:(id)sender {
    NSLog(@"使用优惠券");

    
    
    NSLog(@"选择优惠券");
    YouHuiQuanViewController *vc = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:nil];
    vc.isSelectedYHQ = YES;
    vc.payment = totalfee;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)updateYouhuiquanWithmodel:(YHQModel *)model{
    
    NSLog(@"立即购买优惠券更新");
    NSLog(@"model = %@", model);
    yhqModel = model;
    
    NSLog(@"model.title = %@, %@-%@", yhqModel.title, yhqModel.deadline, yhqModel.created);
    
    NSLog(@"coupon_id = %@", yhqModel.ID);
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    //   NSFontAttributeName
}

- (void)updateUI{
    
}
- (IBAction)zhifubaoClicked:(id)sender {
   //  NSLog(@"选择支付宝");
    payMethod = @"alipay";
    self.zhifubaoImageView.image = [UIImage imageNamed:@"selected_icon.png"];
    self.wxImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    NSLog(@"payMethod = %@", payMethod);
    
}



- (IBAction)weixinZhifuClicked:(id)sender {
 //    NSLog(@"选择微信支付");
    payMethod = @"wx";
    self.zhifubaoImageView.image = [UIImage imageNamed:@"unselected_icon.png"];
    self.wxImageView.image = [UIImage imageNamed:@"selected_icon.png"];
    NSLog(@"payMethod = %@", payMethod);

}

- (IBAction)buyClicked:(id)sender {
     NSLog(@"购买商品");
    
    //   http://m.xiaolu.so/rest/v1/trades/shoppingcart_create
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/shoppingcart_create", Root_URL];
    NSLog(@"urlstring = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    float allpay = totalfee - discountfee + postfee;
    
    NSLog(@"allpay = %.1f", allpay);
    
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSString* dict;
    
    if (yhqModel.ID == nil) {
        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@",cartIDs,addressModel.addressID ,payMethod, [NSString stringWithFormat:@"%.1f", allpay],[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", discountfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid];
    } else {
        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&coupon_id=%@",cartIDs,addressModel.addressID ,payMethod, [NSString stringWithFormat:@"%.1f", allpay],[NSString stringWithFormat:@"%.1f", postfee],[NSString stringWithFormat:@"%.1f", discountfee],[NSString stringWithFormat:@"%.1f", totalfee],uuid, yhqModel.ID];
    
    }
    
    NSLog(@"%@", dict);
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    PurchaseViewController1 * __weak weakSelf = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"response = %@", httpResponse);
        
        NSLog(@"data = %@", data);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"charge = %@", dic);
        
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
                    paySucceed = YES;
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                    paySucceed = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                //[weakSelf showAlertMessage:result];
            }];
        });
        
        
        
    }];
    
}
@end
