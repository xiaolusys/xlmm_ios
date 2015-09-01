//
//  LiJiGMViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/22.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "LiJiGMViewController.h"
#import "MMClass.h"
#import "AddressModel.h"
#import "AddressView.h"
#import "AddAdressViewController.h"
#import "AddYouhuiquanViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Pingpp.h"
#import "LiJiBuyModel.h"

#define kUrlScheme      @"m.xiaolu.so" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。


@interface LiJiGMViewController ()<BuyAddressDelegate>{
    NSMutableArray *addressArray;
    AddressView *owner[8];
    AddressModel *selectedAddModel;
    NSNumber *buyNumber;
    LiJiBuyModel *buyModel;
    NSString *zhifufangshi;
}

@end

@implementation LiJiGMViewController{
    int price;
    int allprice;
    int yunfeifee;
    int youhuifee;
    int allpay;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self downLoadData];
    NSLog(@"selectAddressModel = %@", selectedAddModel.addressID);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressViewWidth.constant = SCREENWIDTH;
    // Do any additional setup after loading the view from its nib.
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];
    buyNumber = @1;
    self.numberLabel.text = [buyNumber stringValue];
    buyModel = [LiJiBuyModel new];
    [self setInfo];
//    self.addressViewHeight.constant = 500;
//    self.couponViewHeight.constant = 200;
//    self.payViewHeight.constant = 300;
    [self.view addSubview:self.myScrollView];
    
   // [self downLoadData];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/now_payinfo?sku_id=%@", Root_URL,self.skuID];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn-plus.png"] forState:UIControlStateNormal];
    [self.reduceButton setBackgroundImage:[UIImage imageNamed:@"btn-reduce.png"] forState:UIControlStateNormal];
    
    buyModel.skuID = self.skuID;
    buyModel.itemID = self.itemID;
    NSLog(@"%@", buyModel);
    NSLog(@"sku_id = %@, ",self.skuID);
    
    NSLog(@"urlString = %@", urlString);
    
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDetailsData:)];
    
}

- (void)setDetailsInfo{
    
}

- (void)fetchedDetailsData:(NSData *)responseData{
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"dic = %@", dic);
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
    
    buyModel.uuID = [dic objectForKey:@"uuid"];
    NSLog(@"%@", buyModel);
    
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


- (void)downLoadData{
    [self downLoadWithURLString:kAddress_List_URL andSelector:@selector(fetchedData:)];
}

- (void)fetchedData:(NSData *)responseData{
    NSError *error;
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (array == 0) {
        NSLog(@"地址列表为空");
        return;
    }
    [addressArray removeAllObjects];
    NSLog(@"arrayList = %@", array);
    for (NSDictionary *dic in array) {
        AddressModel *model = [AddressModel new];
        model.buyerName = [dic objectForKey:@"receiver_name"];
        model.phoneNumber = [dic objectForKey:@"receiver_mobile"];
        model.provinceName = [dic objectForKey:@"receiver_state"];
        model.cityName = [dic objectForKey:@"receiver_city"];
        model.countyName = [dic objectForKey:@"receiver_district"];
        model.streetName = [dic objectForKey:@"receiver_address"];
        model.isDefault = [[dic objectForKey:@"default"] boolValue];
        model.addressID = [dic objectForKey:@"id"];
        [addressArray addObject:model];
    
    }
    NSLog(@"addressArray = %@", addressArray);
    
    [self createAddressList];
    
}

- (void)createAddressList{
    
    NSLog(@"创建地址列表");
    
    
    NSLog(@"count = %ld", (unsigned long)addressArray.count);
    
    
    self.addressViewHeight.constant = 100 * addressArray.count + 60;
    NSLog(@"height = %d",(int) self.addressViewHeight.constant);
    NSUInteger number = addressArray.count;
    for (int i = 0; i<number; i++) {
        NSLog(@"i = %d", i);
       owner[i] = [AddressView new];
        AddressView *myowner = owner[i];
        NSLog(@"%@", owner[i]);
        [[NSBundle mainBundle]loadNibNamed:@"AddressView" owner:myowner options:nil];
        myowner.view.frame = CGRectMake(0, i*100 + 60, SCREENWIDTH, 100);
        NSLog(@"%@", myowner.view);
        
        AddressModel *model = [addressArray objectAtIndex:i];
//        myowner.view.backgroundColor = [UIColor redColor];
        NSString *nameStr = [NSString stringWithFormat:@"%@  %@", model.buyerName, model.phoneNumber];
        NSString *addStr = [NSString stringWithFormat:@"%@-%@-%@", model.provinceName, model.cityName, model.countyName];
        myowner.delegate = self;
        myowner.nameLabel.text = nameStr;
        
        myowner.addressLabel.text = addStr;
        myowner.selectBtn.tag = 600 + i;
        myowner.modifyBtn.tag = 800 + i;
        
        if (model.addressID == selectedAddModel.addressID) {
            myowner.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
        }
        [self.addressViewContaint addSubview:myowner.view];
        
        
    }
}



- (IBAction)addAddress:(id)sender {
    
    NSLog(@"增加收货地址");
    AddAdressViewController *addVC = [[AddAdressViewController alloc] initWithNibName:NSStringFromClass([AddAdressViewController class]) bundle:nil];
    addVC.isAdd = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    
    
    
    
}

- (IBAction)reduceClicked:(id)sender {
    int i = [buyNumber intValue];
    i--;
    if (i == 0) {
        i = 1;
    }
    
    allprice = price * i;
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%i", allprice];
    allpay = allprice + yunfeifee -youhuifee;
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%i", allpay];
    buyNumber = [NSNumber numberWithInt:i];
    self.numberLabel.text = [buyNumber stringValue];
    
    NSLog(@"-------");
}

- (IBAction)addClicked:(id)sender {
    int i = [buyNumber intValue];
    i++;
   
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/carts/sku_num_enough", Root_URL];
    NSLog(@"url = %@", string);
    NSURL *url = [NSURL URLWithString:string];
    
  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
 
    NSString *str = [NSString stringWithFormat:@"sku_id=%@&sku_num=%i", self.skuID, i];//设置参数

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
     
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 150, 240, 300, 40)];
        view.backgroundColor = [UIColor blackColor];
        view.layer.cornerRadius = 8;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        label.text = @"库存不足赶快下单";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:24];
        [view addSubview:label];
        [self.view addSubview:view];
        
        
        [UIView animateWithDuration:2 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];

        
   
    }
  
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//  //  NSLog(@"phoneNumber = %@\n", _numberTextField.text);
//    NSDictionary *parameters = @{@"sku_id": self.skuID,
//                                 @"sku_num":[NSNumber numberWithInt:i]};
//    NSLog(@"paraneters = %@", parameters);
//    __block BOOL flag = YES;
//    [manager POST:@"http://youni.huyi.so/rest/v1/carts/sku_num_enough" parameters:parameters
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              
//              NSLog(@"JSON: %@", responseObject);
//              
//              
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"i = %d", i);
////NSLog(@"Error: %@", error);
//              flag = NO;
//              NSDictionary *dic = error.userInfo;
//              NSData *data =  [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
//              NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//              NSLog(@"dic = %@", str);
//              
//          }];
//    if (flag == NO) {
//        i--;
//    }
//    
//    [self downLoadWithURLString:urlString andSelector:@selector(fetchedNumberData:)];
    allprice = price * i;
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%i", allprice];
    allpay = allprice + yunfeifee -youhuifee;
    self.allPaymentLabel.text = [NSString stringWithFormat:@"¥%i", allpay];
    
    buyNumber = [NSNumber numberWithInt:i];
    self.numberLabel.text = [buyNumber stringValue];

    NSLog(@"+++++++");
}


- (IBAction)youhuiClicked:(id)sender {
    
 NSLog(@"我要获得优惠券");
//    AddYouhuiquanViewController *youhuiVC = [[AddYouhuiquanViewController alloc] initWithNibName:@"AddYouhuiquanViewController" bundle:nil];
//    
//    
//    [self.navigationController pushViewController:youhuiVC animated:YES];
//    

}

- (IBAction)buyClicked:(id)sender {
    NSLog(@"addressID = %@", selectedAddModel.addressID);
    
    if (selectedAddModel.addressID == nil) {
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
    NSLog(@"应付金额：%i", allpay);
    NSLog(@"购买");
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/buynow_create", Root_URL];
    NSLog(@"urlstring = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    

   NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];

    NSString* dict = [NSString stringWithFormat:@"addr_id=%@&channel=%@&payment=%@&post_fee=%@&discount_fee=%@&total_fee=%@&uuid=%@&item_id=%@&sku_id=%@&num=%@",selectedAddModel.addressID ,zhifufangshi, [NSNumber numberWithInt:allprice],[NSNumber numberWithInt:yunfeifee],[NSNumber numberWithInt:yunfeifee],[NSNumber numberWithInt:allpay],buyModel.uuID, buyModel.itemID, buyModel.skuID, buyNumber];
    
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", dict);
   // NSLog(@"string ------>>>%@", bodyData);
    NSLog(@"data = ---->>>>%@", data);
    [postRequest setHTTPBody:data];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    LiJiGMViewController * __weak weakSelf = self;
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
                }
                //[weakSelf showAlertMessage:result];
            }];
        });
      
      
     
    }];

    
    
    
    
}

- (void)selectAddress:(AddressView *)view{
    NSLog(@"我选择这个地址");
    view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
    NSUInteger number = addressArray.count;
    for (int i = 0; i<number; i++) {
        if(owner[i] == view)
        {
            view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
            
            selectedAddModel = [addressArray objectAtIndex:i];
            NSLog(@"选择的地址ID为：%@", selectedAddModel.addressID);
        }
        else
        {
            owner[i].headImage.image = [UIImage imageNamed:@"icon-radio.png"];
        }
    }
    
}
- (void)modifyAddress:(AddressView *)view{
    
    NSLog(@"我要修改此地址");
    NSUInteger number = addressArray.count;
    for (int i = 0; i<number; i++) {
        if(owner[i] == view)
        {
            view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
            
            selectedAddModel = [addressArray objectAtIndex:i];
            NSLog(@"修改的地址ID为：%@", selectedAddModel.addressID);
            
            [self modifyaddressWithModel:(AddressModel *)selectedAddModel];
        }
        else
        {
            owner[i].headImage.image = [UIImage imageNamed:@"icon-radio.png"];
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

- (void)setInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"确认订单";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 8, 18, 31);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClicked:(UIButton *)button{
    NSLog(@"fanhui");
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
- (IBAction)zhifuSelected:(id)sender {
    
    
    UIButton *button = (UIButton *)sender;
    
    
    if (button.tag == 80) {
        
        
        zhifufangshi = @"wx";
        NSLog(@"zhifufangshi = %@", zhifufangshi);
        for (int i = 60; i<64; i++) {
            UIImageView *imageView = (UIImageView *)[self.myZhifuView viewWithTag:i];
            if (i == button.tag - 20) {
                imageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"icon-radio.png"];
            }
        }
        
        
        
        
        
    }else if (button.tag == 81){
       // NSLog(@"zhifubao");
        zhifufangshi = @"alipay";
        NSLog(@"zhifufangshi = %@", zhifufangshi);

        for (int i = 60; i<64; i++) {
            UIImageView *imageView = (UIImageView *)[self.myZhifuView viewWithTag:i];
            if (i == button.tag - 20) {
                imageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"icon-radio.png"];
            }
        }
        
    }else if (button.tag == 82){
      //  NSLog(@"yinglian");
        
        for (int i = 60; i<64; i++) {
            UIImageView *imageView = (UIImageView *)[self.myZhifuView viewWithTag:i];
            if (i == button.tag - 20) {
                imageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"icon-radio.png"];
            }
        }
        
    }else if (button.tag == 83){
     //   NSLog(@"baidu");
        for (int i = 60; i<64; i++) {
            UIImageView *imageView = (UIImageView *)[self.myZhifuView viewWithTag:i];
            if (i == button.tag - 20) {
                imageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"icon-radio.png"];
            }
        }
        
        
    }
}
@end
