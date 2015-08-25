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


@interface LiJiGMViewController ()<BuyAddressDelegate>{
    NSMutableArray *addressArray;
    AddressView *owner[8];
    AddressModel *selectedAddModel;
    
}

@end

@implementation LiJiGMViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self downLoadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressViewWidth.constant = SCREENWIDTH;
    // Do any additional setup after loading the view from its nib.
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setInfo];
//    self.addressViewHeight.constant = 500;
//    self.couponViewHeight.constant = 200;
//    self.payViewHeight.constant = 300;
    [self.view addSubview:self.myScrollView];
    
   // [self downLoadData];
    
    
    
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
        

        [self.addressViewContaint addSubview:myowner.view];
        
        
    }
}



- (IBAction)addAddress:(id)sender {
    
    NSLog(@"增加收货地址");
    AddAdressViewController *addVC = [[AddAdressViewController alloc] initWithNibName:NSStringFromClass([AddAdressViewController class]) bundle:nil];
    addVC.isAdd = YES;
    [self.navigationController pushViewController:addVC animated:YES];
    
    
    
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
    label.font = [UIFont fontWithName:@"LiHei Pro" size:28];
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
@end
