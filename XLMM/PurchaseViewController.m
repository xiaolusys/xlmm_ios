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

#import "UIImage+ImageWithUrl.h"

@interface PurchaseViewController ()<BuyAddressDelegate>{

}

@end

@implementation PurchaseViewController{
    NSMutableArray *dataArray;
    NSMutableArray *cartsDataArray;
    AddressView *owner[10];
    AddressModel *selectedAddModel;
    BuyCartsView *cartOwner;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self downloadAddressData];
    NSLog(@"selectAddressModel = %@", selectedAddModel.addressID);
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单";
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    cartsDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:self.myScrollView];
    self.screenWidth.constant = SCREENWIDTH;
    
    NSLog(@"%@", self.cartsArray);
    [self downloadCartsData];

    
    
}

- (void)downloadCartsData{
    
    
    NSMutableString *paramstring = [[NSMutableString alloc] initWithCapacity:0];
    for (ShoppingCartModel *model in self.cartsArray) {
        NSString *str = [NSString stringWithFormat:@"%@,",model.cartID];
        [paramstring appendString:str];
    }
    NSRange rang =  {paramstring.length -1, 1};
    [paramstring deleteCharactersInRange:rang];
    NSLog(@"paramString = %@", paramstring);
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://youni.huyi.so/rest/v1/carts/carts_payinfo?cart_ids=%@", paramstring];
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
    
    NSLog(@"****************");
}
- (void)createCartsView{
    self.cartsViewHeight.constant = cartsDataArray.count * 140 + 160;
    self.myCartsView.backgroundColor = [UIColor orangeColor];
    
    [self createCartsHeaderView];
    [self createCartsListView];
    [self createCartsFooterView];
    
}

- (void)createCartsHeaderView{
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 200, 40)];
    headLabel.text = @"商品支付详情";
    headLabel.font = [UIFont systemFontOfSize:24];
    headLabel.textAlignment = NSTextAlignmentLeft;
    [self.myCartsView addSubview:headLabel];
}

- (void)createCartsListView{
   cartOwner = [BuyCartsView new];
    

    for (int i = 0; i<cartsDataArray.count; i++) {
        
        BuyModel *model = [cartsDataArray objectAtIndex:i];
        [[NSBundle mainBundle] loadNibNamed:@"BuyCartsView" owner:cartOwner options:nil];
    
    cartOwner.view.frame = CGRectMake(0, 60 + i*140, SCREENWIDTH, 140);
   // cartOwner.view.backgroundColor = [UIColor redColor];
        
        cartOwner.nameLabel.text = model.name;
        cartOwner.sizeLabel.text = model.sizeName;
        cartOwner.numberLabel.text = [[NSNumber numberWithInteger:model.buyNumber ]stringValue ];
        cartOwner.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
        cartOwner.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.oldPrice];
        cartOwner.myImageView.image = [UIImage imagewithURLString:model.imageURL];
                                       
        
//        [upmpButton.layer setMasksToBounds:YES];
//        [upmpButton.layer setCornerRadius:8.0];
//        [upmpButton.layer setBorderWidth:1.0];
//        [upmpButton.layer setBorderColor:[UIColor grayColor].CGColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 85, 36, 36)];
        view.backgroundColor = [UIColor whiteColor];
        [view.layer setMasksToBounds:YES];
        [view.layer setBorderWidth:1];
        [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cartOwner.view addSubview:view];
        
    [self.myCartsView addSubview:cartOwner.view];
    
    }
}

- (void)createCartsFooterView{
    
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
        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//        [dic setObject:[dicInfo objectForKey:@"id"] forKey:@"id"];
//        [dic setObject:[dicInfo objectForKey:@"url"] forKey:@"url"];
//        [dic setObject:[dicInfo objectForKey:@"receiver_name"] forKey:@"receiver_name"];
//        [dic setObject:[dicInfo objectForKey:@"receiver_state"] forKey:@"receiver_state"];
//        [dic setObject:[dicInfo objectForKey:@"receiver_city"] forKey:@"receiver_city"];
//        [dic setObject:[dicInfo objectForKey:@"receiver_district"] forKey:@"receiver_district"];
//        [dic setObject:[dicInfo objectForKey:@"receiver_address"] forKey:@"receiver_address"];
//        [dic setObject:[dicInfo objectForKey:@"receiver_mobile"] forKey:@"receiver_mobile"];
////        [dic setObject:[dicInfo objectForKey:@""] forKey:@""];
////        [dic setObject:[dicInfo objectForKey:@""] forKey:@""];
////        [dic setObject:[dicInfo objectForKey:@""] forKey:@""];
////        [dic setObject:[dicInfo objectForKey:@""] forKey:@""];
//
//        
//        
//        NSLog(@"addressInfo = %@", dic);
//        [dataArray addObject:dic];
    }
    NSLog(@"addressData = %@", dataArray);
    
//    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *addressPath = [documentDirectory stringByAppendingPathComponent:@"address.plist"];
//    NSLog(@"path = %@", documentDirectory);
//    if ([dataArray writeToFile:addressPath atomically:YES]) {
//        NSLog(@"写入文件成功");
//    }else{
//        NSLog(@"写入文件失败");
//    }
    [self createAddressView];
    
    
    
}
- (void)createAddressView{
   // NSArray *addArray = [NSArray arrayWithContentsOfFile:path];
    if (dataArray.count == 0) {
        return;
    }
    
    NSLog(@"addArray = %@", dataArray);
    NSUInteger addNumber = dataArray.count;
    NSLog(@"addNumber = %lu", addNumber);

  //  self.addressView.backgroundColor = [UIColor orangeColor];
    self.addressViewHeight.constant = addNumber * 100 + 60;
    
    
    [self createAddressHeightView];
    [self createAddressListView];
}

- (void)createAddressHeightView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 16, 200, 30)];
    label.text = @"新增收货地址";
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentLeft;
    [self.addressView addSubview:label];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia2.png"]];
    imageview.frame = CGRectMake(SCREENWIDTH - 30, 24, 23, 23);
    [self.addressView addSubview:imageview];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, SCREENWIDTH - 16, 50)];
    [button addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 58, SCREENWIDTH, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.addressView addSubview:view];
    [self.addressView addSubview:button];
}


- (void)addClicked:(UIButton *)button{
    NSLog(@"增加收货地址");
    AddAdressViewController *addVC = [[AddAdressViewController alloc] initWithNibName:NSStringFromClass([AddAdressViewController class]) bundle:nil];
    addVC.isAdd = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    

    
    
}
- (void)createAddressListView{
    for (int i = 0; i<dataArray.count; i++) {
        owner[i] = [AddressView new];
        AddressView *myowner = owner[i];
        [[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:myowner options:nil];
        AddressModel *model = [dataArray objectAtIndex:i];
        NSString *nameString = [NSString stringWithFormat:@"%@  %@", model.buyerName, model.phoneNumber];
        NSString *addString = [NSString stringWithFormat:@"%@-%@-%@", model.provinceName, model.cityName, model.countyName];
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
    NSUInteger number = dataArray.count;
    for (int i = 0; i<number; i++) {
        if(owner[i] == view)
        {
            view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
            
            selectedAddModel = [dataArray objectAtIndex:i];
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
    NSUInteger number = dataArray.count;
    for (int i = 0; i<number; i++) {
        if(owner[i] == view)
        {
            view.headImage.image = [UIImage imageNamed:@"icon-radio-select.png"];
            
            selectedAddModel = [dataArray objectAtIndex:i];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
