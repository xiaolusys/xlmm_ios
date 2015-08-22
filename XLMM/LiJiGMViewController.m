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


@interface LiJiGMViewController (){
    NSMutableArray *addressArray;
}

@end

@implementation LiJiGMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    addressArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setInfo];
//    self.addressViewHeight.constant = 500;
//    self.couponViewHeight.constant = 200;
//    self.payViewHeight.constant = 300;
    [self.view addSubview:self.myScrollView];
    
    [self downLoadData];
    
    
    
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
        [addressArray addObject:model];
    
    }
    NSLog(@"addressArray = %@", addressArray);
    
    [self createAddressList];
    
}

- (void)createAddressList{
    
    NSLog(@"创建地址列表");
    
    
    NSLog(@"count = %ld", addressArray.count);
    
    
    self.addressViewHeight.constant = 100 * addressArray.count + 50;
    NSLog(@"height = %d",(int) self.addressViewHeight.constant);
    NSUInteger number = addressArray.count;
    for (int i = 0; i<number; i++) {
        NSLog(@"i = %d", i);
        AddressView *owner = [AddressView new];

        [[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:owner options:nil];
        owner.view.frame = CGRectMake(0, i*100 + 44, SCREENWIDTH, 100);
        NSLog(@"%@", owner);
        AddressModel *model = [addressArray objectAtIndex:i];
        
        NSString *nameStr = [NSString stringWithFormat:@"%@  %@", model.buyerName, model.phoneNumber];
        NSString *addStr = [NSString stringWithFormat:@"%@-%@-%@", model.provinceName, model.cityName, model.countyName];
        owner.nameLabel.text = nameStr;
        
        owner.addressLabel.text = addStr;
     

        [self.addressViewContaint addSubview:owner.view];
        
        
    }
}

- (void)setInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"确认订单";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:26];
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
