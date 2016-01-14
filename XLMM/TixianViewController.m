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

#define RGBCOLOR(a, b, c) [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1]

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClicked:)];
    
   
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
    self.fabuButton.layer.borderColor = RGBCOLOR(245, 166, 35).CGColor;
    
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
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
////  http://192.168.1.31:9000/rest/v1/cashout
//    
//    NSString *stringurl = [NSString stringWithFormat:@"%@/rest/v1/cashout", Root_URL];
//    NSLog(@"url = %@", stringurl);
//    NSDictionary *paramters = @{@"choice":type};
//    
////    [manager POST:stringurl parameters:paramters
////          success:^(AFHTTPRequestOperation *operation, id responseObject) {
////              NSLog(@"response = %@", responseObject);
////              
////          }
////          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////              
////              NSLog(@"Error: %@", error);
////              
////          }];

    TixianSucceedViewController *vc = [[TixianSucceedViewController alloc] initWithNibName:@"TixianSucceedViewController" bundle:nil];
    vc.tixianjine = tixianjine;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)fabuClicked:(id)sender {
    
    NSLog(@"发布产品");
    
    PublishNewPdtViewController *publish = [[PublishNewPdtViewController alloc] init];
    [self.navigationController pushViewController:publish animated:YES];
}
@end
