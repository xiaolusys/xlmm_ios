//
//  AddYouhuiquanViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddYouhuiquanViewController.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"

@interface AddYouhuiquanViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation AddYouhuiquanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
   // [self createInfo];

    [self createNavigationBarWithTitle:@"获取优惠券" selecotr:@selector(backBtnClicked:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"优惠券";
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
    self.navigationItem.backBarButtonItem = leftItem;
    
  
    
}



- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




//            - {prefix}/method: post 创建用户优惠券
//            ->arg: coupon_type 优惠券类型
//            -->C150_10:满150减10
//            -->C259_20:满259减20
//            :return
//            {'res':'limit'} ->: 创建受限
//            {'res':'success'} ->: 创建成功
//            {'res':'not_release'} ->: 暂未发放

- (void)getYHQWithType:(NSString *)type{
    NSString *urlstring = [NSString stringWithFormat:@"%@/rest/v1/usercoupons", Root_URL];
    NSLog(@"url = %@", urlstring);
    //  NSURL *url = [NSURL URLWithString:urlstring];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"coupon_type": type};
    
    [manager POST:urlstring parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  NSLog(@"是字典");
                  NSDictionary *dic = (NSDictionary *)responseObject;
                  NSString *result = [dic objectForKey:@"res"];
                  if ([result isEqualToString:@"limit"]) {
                      NSLog(@"创建受限");
                      self.alertView.message = @"创建受限";
                      [self.alertView show];
                      
                  } else if ([result isEqualToString:@"success"]){
                      NSLog(@"创建成功");
                      self.alertView.message = @"创建成功";
                      [self.alertView show];
                      
                  } else if ([result isEqualToString:@"not_release"]){
                      NSLog(@"暂未发放");
                      self.alertView.message = @"暂未发放";
                      [self.alertView show];
                  }
                  
                  
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];
}



- (IBAction)btn1Clicked:(id)sender {
    NSLog(@"领取优惠券11");
    
    
                NSLog(@"获取优惠券");
    [self getYHQWithType:@"C150_10"];
    
    
    
    
    

    
}

- (IBAction)btn2Clicked:(id)sender {
    NSLog(@"领取优惠券22");
    
    NSLog(@"获取优惠券");
    
    [self getYHQWithType:@"C150_20"];

}
@end
