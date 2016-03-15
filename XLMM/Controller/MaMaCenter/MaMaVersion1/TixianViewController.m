//
//  TixianViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "TixianSucceedViewController.h"
#import "PublishNewPdtViewController.h"
#import "TixianHistoryViewController.h"



@interface TixianViewController ()

@end

@implementation TixianViewController{
    BOOL ishongbao1Opened;
    BOOL ishongbao2Opened;
    NSString *type;
    float zhanghuyue;
    float tixianjine;
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

//- (void)cancelTixian:(UIButton *)button{
//    NSLog(@"取消");
//    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cancal_cashout", Root_URL];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    //  http://192.168.1.31:9000/rest/v1/cashout
//    
//    NSLog(@"url = %@", string);
//    NSDictionary *paramters = @{@"id":@68};
//    NSLog(@"paramters = %@", paramters);
//    [manager POST:string parameters:paramters
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"response = %@", responseObject);
//              if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
//                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                  [alertView show];
//              } else if ([[responseObject objectForKey:@"code"] integerValue] == 0){
//                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                  [alertView show];
//              }
//     
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              
//              NSLog(@"Error: %@", error);
//              
//          }];
//
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm", Root_URL];
 
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (data == nil) {
        self.name = @"小鹿妈妈";
        self.cantixianjine = 0.00;
        
        
    } else {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *dic = array[0];
        MMLOG(dic);
        self.cantixianjine = [[dic objectForKey:@"coulde_cashout"] floatValue];
        self.name = [dic objectForKey:@"weikefu"];
    }
    
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hongbaoClicked:)];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hongbaoClicked:)];
    self.hongbaoImage1.userInteractionEnabled = YES;
    self.hongbaoImage2.userInteractionEnabled = YES;
    [self.hongbaoImage1 addGestureRecognizer:tap0];
    [self.hongbaoImage2 addGestureRecognizer:tap];
    ishongbao1Opened = NO;
    ishongbao2Opened = NO;
    self.tixianButton.layer.borderWidth = 1;
    self.tixianButton.layer.cornerRadius = 20;
    
    [self disableTijiaoButton];
    
    self.fabuButton.layer.cornerRadius = 15;
    self.fabuButton.layer.borderWidth = 1;
    self.fabuButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    zhanghuyue = self.cantixianjine;
    
    self.yueLabel.text = [NSString stringWithFormat:@"%.2f", zhanghuyue];
    self.nameLabel.text = [NSString stringWithFormat:@"小鹿妈妈：%@", self.name];
    if (zhanghuyue < 100) {
        self.unableTixianView.hidden = NO;
    } else {
        
        self.unableTixianView.hidden = YES;
        
        if (zhanghuyue >= 200) {
            
        } else {
            self.hongbaoImage2.image = [UIImage imageNamed:@"hongbaounused200.png"];
            self.hongbaoImage2.userInteractionEnabled = NO;
            
            
        }
    }
     
    
    [self createRightButonItem];

}

- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    label.textColor = [UIColor textDarkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    [rightBtn addSubview:label];
    label.text = @"提现历史";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{
    NSLog(@"历史提现");
    TixianHistoryViewController *historyVC = [[TixianHistoryViewController alloc] init];
    
    [self.navigationController pushViewController:historyVC animated:YES];
    
    
}

- (void)hongbaoClicked:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (imageView.tag == 100) {
       
        ishongbao1Opened = !ishongbao1Opened;
        if (ishongbao1Opened) {
            type = @"c1";
            [self enableTijiaoButton];
            [self showHongBaoImage:self.hongbaoImage1 andImageNamed:@"hongbaoopen100.png"];
            tixianjine = 100;
            if (ishongbao2Opened) {
                ishongbao2Opened = !ishongbao2Opened;
                [self hiddenHongBaoImage:self.hongbaoImage2 atIndex:1];
            }
        } else {
            type = nil;
            [self disableTijiaoButton];
            [self hiddenHongBaoImage:self.hongbaoImage1 atIndex:0];
        }
    } else if(imageView.tag == 200){
        ishongbao2Opened = !ishongbao2Opened;
        if (ishongbao2Opened) {
            type = @"c2";
            [self enableTijiaoButton];
            [self showHongBaoImage:self.hongbaoImage2 andImageNamed:@"hongbaoopen200.png"];
            tixianjine = 200;
            if (ishongbao1Opened) {
                ishongbao1Opened = !ishongbao1Opened;
                [self hiddenHongBaoImage:self.hongbaoImage1 atIndex:0];
            }
        } else {
            type = nil;
            [self disableTijiaoButton];
            [self hiddenHongBaoImage:self.hongbaoImage2 atIndex:1];
        }
    }
}

- (void)enableTijiaoButton{
    self.tixianButton.enabled = YES;
    self.tixianButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.tixianButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.tixianButton.enabled = NO;
    self.tixianButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.tixianButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

- (void)showHongBaoImage:(UIImageView *)imageView andImageNamed:(NSString *)name{
   imageView.image = [UIImage imageNamed:name];
    
}

- (void)hiddenHongBaoImage:(UIImageView *)imageView atIndex:(int)index{
    if (index == 0) {
        imageView.image = [UIImage imageNamed:@"hongbaoclose100.png"];

    } else if (index == 1) {
        imageView.image = [UIImage imageNamed:@"hongbaoclose200.png"];

    }
}

- (void)backClicked:(UIButton *)button{
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

- (IBAction)tixianClicked:(id)sender {
    NSLog(@"提现");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//  http://192.168.1.31:9000/rest/v1/cashout
    
    NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout", Root_URL];
    NSLog(@"url = %@", stringurl);
    NSDictionary *paramters = @{@"choice":type};
    NSLog(@"paramters = %@", paramters);
    [manager POST:stringurl parameters:paramters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"response = %@", responseObject);
              
           
              NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
              if (code == 0) {
                  TixianSucceedViewController *vc = [[TixianSucceedViewController alloc] initWithNibName:@"TixianSucceedViewController" bundle:nil];
                  vc.tixianjine = tixianjine;
                  [self.navigationController pushViewController:vc animated:YES];
              } else if (code == 1){
                  [self alterMessage:@"参数错误"];
                  
              } else if (code == 2){
                  [self alterMessage:@"不足提现金额"];
              } else if (code == 3){
                  [self alterMessage:@"有待审核记录不予再次提现"];
              }
              
          
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

  
    
}


- (void)alterMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    
}

- (IBAction)fabuClicked:(id)sender {
    
 //   NSLog(@"发布产品");
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}


@end
