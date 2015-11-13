//
//  ShenQingTuikuanController.m
//  XLMM
//
//  Created by younishijie on 15/11/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ShenQingTuikuanController.h"
#import "UIViewController+NavigationBar.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIColor+RGBColor.h"
#import "AFNetworking.h"
#import "MMClass.h"




@interface ShenQingTuikuanController ()


@end



@implementation ShenQingTuikuanController{
    int number;
    int maxNumber;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavigationBarWithTitle:@"申请退款" selecotr:@selector(backClicked:)];
    
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[self.dingdanModel.urlString URLEncodedString]]];
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 0.5;
    self.myImageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
    number = [self.dingdanModel.numberString intValue];
    maxNumber = [self.dingdanModel.numberString intValue];
    
    
    self.nameLabel.text = self.dingdanModel.nameString;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",[self.dingdanModel.priceString floatValue]];
    self.sizeNameLabel.text = self.dingdanModel.sizeString;
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", self.dingdanModel.numberString];
    
    self.refundPriceLabel.text = [NSString stringWithFormat:@"¥%.02f", [self.dingdanModel.priceString floatValue]];
    self.refundNumLabel.text = [NSString stringWithFormat:@"%i", maxNumber];
    
    
    
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

- (IBAction)reduceButtonClicked:(id)sender {
    NSLog(@"减一件");
    if (number-- <= 1) {
        number++;
        return;
    }
    
    //   http://192.168.1.31:9000/rest/v1/refunds
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSString *string = [responseObject objectForKey:@"apply_fee"];
              self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", [string floatValue]];
              self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];
    
    
}
- (IBAction)addBtnClicked:(id)sender {
    NSLog(@"加一件                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ");
    if (number++ > maxNumber - 1) {
        number--;
        return;
    }
    
    //   http://192.168.1.31:9000/rest/v1/refunds
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSString *string = [responseObject objectForKey:@"apply_fee"];
              self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", [string floatValue]];
              self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

}
@end
