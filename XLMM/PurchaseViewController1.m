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

@interface PurchaseViewController1 (){
  
}

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *mutableCatrsArray;

@end

@implementation PurchaseViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self downloadAddressData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self createNavigationBarWithTitle:@"确认订单" selecotr:@selector(backButtonClicked:)];
    
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor colorWithR:217 G:140 B:13 alpha:1].CGColor;
    self.buyButton.layer.cornerRadius = 20;
    
    
    
    NSLog(@"cartsArray =  %@", self.cartsArray);
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.mutableCatrsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    
    
    [self downloadCartsData];
    
    
    
    
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
    
    self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dic objectForKey:@"total_fee"] floatValue]];
    self.postFeeLabel.text = [NSString stringWithFormat:@"¥%.0f", [[dic objectForKey:@"post_fee"] floatValue]];
    self.youhuijineLabel.text = [NSString stringWithFormat:@"¥%.0f", [[dic objectForKey:@"discount_fee"] floatValue]];
    self.allPayLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dic objectForKey:@"total_payment"] floatValue]];
    
    
    [self.mutableCatrsArray removeAllObjects];

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
        
        
        [self.mutableCatrsArray addObject:model];
    }

    NSLog(@"cartsDataArray = %@", self.mutableCatrsArray);
    
    [self createCartsListView];
    
    NSLog(@"****************");
}

- (void)createCartsListView{
    BuyCartsView * cartOwner = [BuyCartsView new];
    self.detailsViewHeight.constant = self.mutableCatrsArray.count * 80;
    
    for (int i = 0; i<self.mutableCatrsArray.count; i++) {
        
        BuyModel *model = [self.mutableCatrsArray objectAtIndex:i];
        [[NSBundle mainBundle] loadNibNamed:@"BuyCartsView" owner:cartOwner options:nil];
        
        cartOwner.view.frame = CGRectMake(0, i*80, SCREENWIDTH, 80);
        // cartOwner.view.backgroundColor = [UIColor redColor];
        
        cartOwner.nameLabel.text = model.name;
        cartOwner.sizeLabel.text = model.sizeName;
        cartOwner.numberLabel.text = [NSString stringWithFormat:@"x%@",[[NSNumber numberWithInteger:model.buyNumber ]stringValue]];
        
        cartOwner.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", [model.price floatValue]];
     
        cartOwner.myImageView.image = [UIImage imagewithURLString:model.imageURL];
        
        [self.detailsView addSubview:cartOwner.view];
        
    }
}

- (void)downloadAddressData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kAddress_List_URL]];
        [self performSelectorOnMainThread:@selector(fetchedAddressData:) withObject:data waitUntilDone:YES];
        
        
    });
}

- (void)fetchedAddressData:(NSData *)data{
    NSError *error;
    NSArray *addressArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (addressArray.count == 0) {
        return;
    }
    [self.dataArray removeAllObjects];
    NSLog(@"address list = %@", addressArray);
    NSDictionary *dic = [addressArray objectAtIndex:0];
    NSLog(@"dic = %@", dic);
    AddressModel *model = [AddressModel new];
    model.buyerName = [dic objectForKey:@"receiver_name"];
    model.phoneNumber = [dic objectForKey:@"receiver_mobile"];
    model.provinceName = [dic objectForKey:@"receiver_state"];
    model.cityName = [dic objectForKey:@"receiver_city"];
    model.countyName = [dic objectForKey:@"receiver_district"];
    model.streetName = [dic objectForKey:@"receiver_address"];
    model.isDefault = [[dic objectForKey:@"default"] boolValue];
    model.addressID = [dic objectForKey:@"id"];
    [self.dataArray addObject:model];
        
    NSLog(@"addressID = %@", model.addressID);
    //NSLog(@"addressData = %@", self.dataArray);
    
    [self createAddressView];
    
}
- (void)createAddressView{
    AddressModel *model = [self.dataArray firstObject];
    self.peopleLabel.text = [NSString stringWithFormat:@"%@ %@", model.buyerName, model.phoneNumber];
    self.addressLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",model.provinceName, model.cityName, model.countyName, model.streetName];
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
//    addVC.isAdd = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)modifyAddress:(id)sender {
     NSLog(@"修改地址");
    AddAdressViewController *addVC = [[AddAdressViewController alloc] init];
    addVC.isAdd = NO;
    addVC.addressModel = [self.dataArray firstObject];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)yhqClicked:(id)sender {
    NSLog(@"使用优惠券");
}

- (IBAction)zhifubaoClicked:(id)sender {
     NSLog(@"选择支付宝");
}

- (IBAction)weixinZhifuClicked:(id)sender {
     NSLog(@"选择微信支付");
}

- (IBAction)buyClicked:(id)sender {
     NSLog(@"购买商品");
}
@end
