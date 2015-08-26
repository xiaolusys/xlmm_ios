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


@interface PurchaseViewController ()<BuyAddressDelegate>

@end

@implementation PurchaseViewController{
    NSMutableArray *dataArray;
    AddressView *owner[10];
    AddressModel *selectedAddModel;
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
    [self.view addSubview:self.myScrollView];
    self.screenWidth.constant = SCREENWIDTH;
    
    
    
    
    
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
    NSLog(@"增加新地址");
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
