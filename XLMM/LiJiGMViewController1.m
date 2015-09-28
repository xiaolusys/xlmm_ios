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

@interface LiJiGMViewController1 ()

@end

@implementation LiJiGMViewController1{
    AddressModel *addressModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.zhifuHeight.constant = 80;
    self.containterWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [self downloadAddressData];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)downloadAddressData{
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/address.json", Root_URL];
    NSLog(@"url = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
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
}

- (IBAction)plusClicked:(id)sender {
    NSLog(@"++++");
}

- (IBAction)selectYouhuiClicked:(id)sender {
    NSLog(@"选择优惠券");
}

- (IBAction)zhifubaoClicked:(id)sender {
    NSLog(@"支付宝支付");
}

- (IBAction)weixinClicked:(id)sender {
    NSLog(@"微信支付");
    
}

- (IBAction)buyClicked:(id)sender {
    NSLog(@"购买！！");
}
@end
