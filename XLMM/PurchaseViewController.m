//
//  PurchaseViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/5.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PurchaseViewController.h"
#import "MMClass.h"
#import "AddressView.h"
#import "AddAdressViewController.h"
#import "AddressModel.h"
#import "ShoppingCartModel.h"
#import "BuyModel.h"
#import "BuyCartsView.h"
#import "Pingpp.h"
#import "AddressViewController.h"
#import "UIImage+ImageWithUrl.h"
#import "YHQModel.h"
#import "YouHuiQuanViewController.h"
#import "WXApi.h"
#import "UIViewController+NavigationBar.h"
#import "NewCartsModel.h"
#import "PersonCenterViewController1.h"
#define kUrlScheme @"wx25fcb32689872499" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

@interface PurchaseViewController ()<BuyAddressDelegate, YouhuiquanDelegate>{
    YHQModel *yhqModel;

}


@end

@implementation PurchaseViewController{
    NSMutableArray *dataArray;
    NSMutableArray *cartsDataArray;
    AddressView *owner;
    AddressModel *selectedAddModel;
    BuyCartsView *cartOwner;
    
    float totalfee;
    NSInteger postfee;
    NSInteger discountfee;
    float totalpayment;
    
    NSString *channel;
    NSString *addressID;
    NSString *cartsIDs;
    NSString *payment;
    NSString *post_fee;
    NSString *discount_fee;
    NSString *total_fee;
    NSString *uuid;
    BOOL paySucceed;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelZhifuCatrs:) name:@"CancleZhifu" object:nil];
    self.navigationController.navigationBarHidden = NO;
    [self downloadAddressData];
    [self downloadYouhuiData];

    NSLog(@"selectAddressModel = %@", selectedAddModel.addressID);
    //CALayer
    // CGFloat
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        
        
    }
    else{
        NSLog(@"没有安装微信");
        
        self.zhifuHeight.constant = 100;
        channel = @"alipay";
      
        self.zhifuImageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
        /*
         icon-radio.png
         icon-radio-select.png
         wx
         alipay
         
         */
        NSLog(@"zhifu = %@", channel);
        
    }
    
    if (yhqModel == nil) {
        self.yhqImageView.hidden = YES;
        
        self.yhqViewHeight.constant = 66;
    } else{
        self.yhqImageView.hidden = NO;
        self.yhqViewHeight.constant = 150;
    }
    

}

- (void)cancelZhifuCatrs:(NSNotification *)notification{
    NSLog(@"取消购物车支付");
    [self.navigationController pushViewController:[[PersonCenterViewController1 alloc] initWithNibName:@"PersonCenterViewController1" bundle:nil] animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CancleZhifu" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单";
    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backButtonClicked:)];
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    cartsDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:self.myScrollView];
    self.screenWidth.constant = SCREENWIDTH;
   // yhqModel = [YHQModel new];
    NSLog(@"%@", self.cartsArray);
    [self downloadCartsData];
    
    if (yhqModel == nil) {
        self.yhqImageView.hidden = YES;
    } else{
        self.yhqImageView.hidden = NO;
    }

    
    
}

- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadCartsData{
    
    
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    if (self.cartsArray.count == 0) {
        //购物车为空。
        
        NSLog(@"购物车为空");
        
        return;
    }
    for (NewCartsModel *model in self.cartsArray) {
        NSString *str = [NSString stringWithFormat:@"%d,",model.ID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    NSLog(@"paramString = %@", paramstring);
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/carts_payinfo?cart_ids=%@", Root_URL,paramstring];
    
    NSLog(@"urlstring = %@", urlString);
    NSLog(@"--------");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:@selector(fetchedCartsData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (void)fetchedCartsData:(NSData *)responseData{
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"****************");
    NSLog(@"dic = %@", dic);
    
    NSArray *array = [dic objectForKey:@"cart_list"];
    
    totalfee = [[dic objectForKey:@"total_fee"] floatValue];
    postfee = [[dic objectForKey:@"post_fee"] integerValue];
    discountfee = [[dic objectForKey:@"discount_fee"] integerValue];
    totalpayment = [[dic objectForKey:@"total_payment"] floatValue];
    
    uuid = [dic objectForKey:@"uuid"];
    discount_fee = [dic objectForKey:@"discount_fee"];
    post_fee = [dic objectForKey:@"post_fee"];
    cartsIDs = [dic objectForKey:@"cart_ids"];
    total_fee = [dic objectForKey:@"total_fee"];
    payment = [dic objectForKey:@"total_payment"];
    
    for (NSDictionary *dicInfo in array) {
        BuyModel *model = [BuyModel new];
        model.addressID = [dicInfo objectForKey:@"id"];
        model.payment = [dic objectForKey:@"total_payment"];
         model.postFee = [dic objectForKey:@"post_fee"];
         model.discountFee = [dic objectForKey:@"discount_fee"];
         model.totalFee = [dic objectForKey:@"total_fee"];
         model.uuID = [dic objectForKey:@"uuid"];
         model.itemID = [dicInfo objectForKey:@"item_id"];
         model.skuID = [dicInfo objectForKey:@"sku_id"];
         model.buyNumber = [[dicInfo objectForKey:@"num"]integerValue];
        model.imageURL = [dicInfo objectForKey:@"pic_path"];
        model.name = [dicInfo objectForKey:@"title"];
        model.sizeName = [dicInfo objectForKey:@"sku_name"];
        model.price = [dicInfo objectForKey:@"price"];
        model.oldPrice = [dicInfo objectForKey:@"std_sale_price"];
        
        
        [cartsDataArray addObject:model];
    }
    
    NSLog(@"cartsDataArray = %@", cartsDataArray);
    
    [self createCartsView];
    [self createBuyView];
    
    NSLog(@"****************");
}

//
- (void)createBuyView{
    self.discountfeeLabel.text = [NSString stringWithFormat:@"￥%ld",(long)discountfee];
    self.totalPayLabel.text = [NSString stringWithFormat:@"￥%.1f", totalpayment];
}
- (void)createCartsView{
    self.cartsViewHeight.constant = cartsDataArray.count * 120 + 125;
 //   self.myCartsView.backgroundColor = [UIColor orangeColor];
    
    [self createCartsHeaderView];
    [self createCartsListView];
    [self createCartsFooterView];
    
}

- (void)createCartsHeaderView{
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 200, 40)];
    headLabel.text = @"商品支付详情";
    headLabel.font = [UIFont systemFontOfSize:18];
    headLabel.textAlignment = NSTextAlignmentLeft;
    [self.myCartsView addSubview:headLabel];
}

- (void)createCartsListView{
   cartOwner = [BuyCartsView new];
    

    for (int i = 0; i<cartsDataArray.count; i++) {
        
        BuyModel *model = [cartsDataArray objectAtIndex:i];
        [[NSBundle mainBundle] loadNibNamed:@"BuyCartsView" owner:cartOwner options:nil];
    
    cartOwner.view.frame = CGRectMake(0, 40 + i*120, SCREENWIDTH, 120);
   // cartOwner.view.backgroundColor = [UIColor redColor];
        
        cartOwner.nameLabel.text = model.name;
        cartOwner.sizeLabel.text = model.sizeName;
        cartOwner.numberLabel.text = [[NSNumber numberWithInteger:model.buyNumber ]stringValue ];
        cartOwner.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", [model.price floatValue]];
        cartOwner.myImageView.image = [UIImage imagewithURLString:model.imageURL];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 75, 36, 36)];
        view.backgroundColor = [UIColor whiteColor];
        [view.layer setMasksToBounds:YES];
        [view.layer setBorderWidth:1];
        [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cartOwner.view addSubview:view];
        
    [self.myCartsView addSubview:cartOwner.view];
    
    }
}

- (void)createCartsFooterView{
    NSInteger height = self.cartsViewHeight.constant;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(8, height - 90, 200, 30)];
    label1.text = @"商品总金额";
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentLeft;
    [self.myCartsView addSubview:label1];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80, height - 90, 80, 30)];
    label3.text = [NSString stringWithFormat:@"￥%.1f", totalfee];
    label3.textColor = [UIColor colorWithR:224 G:48 B:116 alpha:1];
    label3.font = [UIFont systemFontOfSize:16];
    label3.textAlignment = NSTextAlignmentLeft;
    [self.myCartsView addSubview:label3];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8, height - 50, 200, 30)];
    label2.text = @"小鹿美美运费";
    label2.font = [UIFont systemFontOfSize:16];
    label2.textAlignment = NSTextAlignmentLeft;
    [self.myCartsView addSubview:label2];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, height - 50, 60, 30)];
    label4.text = [NSString stringWithFormat:@"￥%ld", (long)postfee];
     label4.textColor = [UIColor colorWithR:224 G:48 B:116 alpha:1];
    label4.font = [UIFont systemFontOfSize:16];
    label4.textAlignment = NSTextAlignmentLeft;
    [self.myCartsView addSubview:label4];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height - 10, SCREENWIDTH, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.myCartsView addSubview:view];
    
}

- (void)downloadAddressData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kAddress_List_URL]];
        [self performSelectorOnMainThread:@selector(fetchedAddressData:) withObject:data waitUntilDone:YES];
        
        
    });
}

- (void)fetchedAddressData:(NSData *)responseData{
    NSError *error;
    NSArray *addressArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (addressArray.count == 0) {
        return;
    }
    [dataArray removeAllObjects];
    NSLog(@"address list = %@", addressArray);
    for (NSDictionary *dic in addressArray) {
        AddressModel *model = [AddressModel new];
        model.buyerName = [dic objectForKey:@"receiver_name"];
        model.phoneNumber = [dic objectForKey:@"receiver_mobile"];
        model.provinceName = [dic objectForKey:@"receiver_state"];
        model.cityName = [dic objectForKey:@"receiver_city"];
        model.countyName = [dic objectForKey:@"receiver_district"];
        model.streetName = [dic objectForKey:@"receiver_address"];
        model.isDefault = [[dic objectForKey:@"default"] boolValue];
        model.addressID = [dic objectForKey:@"id"];
        [dataArray addObject:model];

    }
    NSLog(@"addressData = %@", dataArray);

    [self createAddressView];
    
    
    
}
- (void)createAddressView{
   // NSArray *addArray = [NSArray arrayWithContentsOfFile:path];
    if (dataArray.count == 0) {
        return;
    }
    
    NSLog(@"addArray = %@", dataArray);
    NSUInteger addNumber = dataArray.count;
    NSLog(@"addNumber = %lu", (unsigned long)addNumber);

  //  self.addressView.backgroundColor = [UIColor orangeColor];
    self.addressViewHeight.constant = 100;
    
    
}




- (void)addClicked:(UIButton *)button{
    NSLog(@"增加收货地址");
    AddressViewController *addVC = [[AddressViewController alloc] initWithNibName:NSStringFromClass([AddressViewController class]) bundle:nil];
//    addVC.isAdd = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    

    
    
}
- (void)createAddressListView{
    for (int i = 0; i<1; i++) {
        owner = [AddressView new];
        AddressView *myowner = owner;
        [[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:myowner options:nil];
        AddressModel *model = [dataArray objectAtIndex:i];
        NSString *nameString = [NSString stringWithFormat:@"%@  %@", model.buyerName, model.phoneNumber];
        NSString *addString = [NSString stringWithFormat:@"%@-%@-%@-%@", model.provinceName, model.cityName, model.countyName, model.streetName];
        myowner.nameLabel.text = nameString;
        myowner.delegate = self;
        myowner.addressLabel.text = addString;
        myowner.view.frame = CGRectMake(0, i*100+60, SCREENWIDTH, 100);
        [self.addressView addSubview:myowner.view];
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectAddress:(AddressView *)view{
    NSLog(@"我选择这个地址");
    view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
//    NSUInteger number = dataArray.count;
    for (int i = 0; i<1; i++) {
        if(owner == view)
        {
            view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
            
            selectedAddModel = [dataArray objectAtIndex:i];
            NSLog(@"选择的地址ID为：%@", selectedAddModel.addressID);
            addressID = selectedAddModel.addressID;
            NSLog(@"addr_id = %@", addressID);
        }
        else
        {
            owner.headImage.image = [UIImage imageNamed:@"icon-radio.png"];
        }
    }
    
}
- (void)modifyAddress:(AddressView *)view{
    
    NSLog(@"我要修改此地址");
//    NSUInteger number = dataArray.count;
    for (int i = 0; i<1; i++) {
        if(owner == view)
        {
            view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
            
            selectedAddModel = [dataArray objectAtIndex:i];
            NSLog(@"修改的地址ID为：%@", selectedAddModel.addressID);
            
            [self modifyaddressWithModel:(AddressModel *)selectedAddModel];
        }
        else
        {
            owner.headImage.image = [UIImage imageNamed:@"icon-radio.png"];
        }
    }
}

- (void)modifyaddressWithModel:(AddressModel *)model{
    AddAdressViewController *modifyVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
    modifyVC.isAdd = NO;
    modifyVC.addressModel = model;
    [self.navigationController pushViewController:modifyVC animated:YES];
    
    NSLog(@"进入修改地址");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)zhifuSelected:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    
    if (button.tag == 80) {
        //NSLog(@"weixin");
        
        channel = @"alipay";
        
        for (int i = 60; i<64; i++) {
            UIImageView *imageView = (UIImageView *)[self.zhifuView viewWithTag:i];
            if (i == button.tag - 20) {
                imageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"icon-radio.png"];
            }
        }
        
        
        
        
        
    }else if (button.tag == 81){
        //NSLog(@"zhifubao");
        channel = @"wx";
        for (int i = 60; i<64; i++) {
            UIImageView *imageView = (UIImageView *)[self.zhifuView viewWithTag:i];
            if (i == button.tag - 20) {
                imageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"icon-radio.png"];
            }
        }
        
    }
    NSLog(@"channel = %@", channel);
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
        if ([[dic objectForKey:@"status"]integerValue] == 0 && [[dic objectForKey:@"poll_status"] integerValue]!= 2) {
            NSLog(@"可用优惠券");
            number++;
            
            NSLog(@"可用优惠券(%ld)", (long)number);
        }
    }
    self.usableNumber.text = [NSString stringWithFormat:@"可用优惠券（%ld）", (long)number];
    
    
    // http://m.xiaolu.so/rest/v1/usercoupons
}

- (IBAction)goumaiClicked:(id)sender {
    
    NSLog(@"购买商品");
    
    
    if (addressID == nil) {
        NSLog(@"请选择收货地址");
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 150, 240, 300, 40)];
        view.backgroundColor = [UIColor blackColor];
        view.layer.cornerRadius = 8;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        label.text = @"请填写收货信息";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:24];
        [view addSubview:label];
        [self.view addSubview:view];
        
        self.myScrollView.contentOffset = CGPointMake(0, 0);
        
        [UIView animateWithDuration:2 animations:^{
            view.alpha = 0;
            
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            
        }];
        
        
        return;
        
    }
   
    //   http://m.xiaolu.so/rest/v1/trades/shoppingcart_create
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/shoppingcart_create", Root_URL];
    NSLog(@"urlstring = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    float allpay = totalfee - discountfee + postfee;
    
    NSLog(@"allpay = %.1f", allpay);
    
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSString* dict;
    
    if (yhqModel.ID == nil) {
        dict  = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@",cartsIDs,addressID ,channel, [NSString stringWithFormat:@"%.1f", allpay],post_fee,discount_fee,total_fee,uuid];
    } else {
     dict = [NSString stringWithFormat:@"cart_ids=%@&addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&coupon_id=%@",cartsIDs,addressID ,channel, [NSString stringWithFormat:@"%.1f", allpay],post_fee,discount_fee,total_fee,uuid, yhqModel.ID];
    }
   
    NSLog(@"%@", dict);
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
 

    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    PurchaseViewController * __weak weakSelf = self;
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
- (IBAction)selectYHqClicked:(id)sender {
    
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
    self.yhqCreateLabel.text = yhqModel.created;
    self.yhqdeadlineLabel.text = yhqModel.deadline;
    self.yhqtitleLabel.text = yhqModel.title;
    discountfee = [yhqModel.coupon_value intValue];
    
    
    self.discountfeeLabel.text = [NSString stringWithFormat:@"￥%@", yhqModel.coupon_value];
    //    allpay -= [yhqModel.coupon_value intValue];
    self.totalPayLabel.text = [NSString stringWithFormat:@"￥%d",(int)(totalpayment - [yhqModel.coupon_value intValue])];
    
    
    
}
@end
