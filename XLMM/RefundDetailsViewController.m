//
//  RefundDetailsViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/26.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "RefundDetailsViewController.h"
#import "TuihuoModel.h"
#import "UIViewController+NavigationBar.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"



@interface RefundDetailsViewController (){
    
}


@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *modifyTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *refundPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *detailsView;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdLabel;


@end

@implementation RefundDetailsViewController

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
    [self createNavigationBarWithTitle:@"退货款详情" selecotr:@selector(backClicked:)];
    [self setHeadInfo];
    [self setFootInfo];
    
}

- (void)setHeadInfo{
    self.bianhaoLabel.text = self.model.refund_no;
    if ([self.model.status_display isEqualToString:@"买家已经申请退款"]) {
        self.model.status_display = @"卖家处理中";
    }
    self.displayLabel.text = self.model.status_display;
    self.titleLabel.text = self.model.title;
    self.sizeLabel.text = self.model.sku_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", self.model.payment];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.model.refund_num];
    self.refundPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.model.refund_fee];
    
    
    self.reasonLabel.text = self.model.reason;
    if ([self.model.pic_path isKindOfClass:[NSString class]] ) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.model.pic_path URLEncodedString]]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
    self.circleView.layer.cornerRadius = 5;
    self.createdLabel.text = @"申请退款";
    self.statusLabel.text = self.model.status_display;
    self.createTimeLabel.text = self.model.created;
    self.modifyTimeLabel.text = self.model.created;

}

- (void)setFootInfo{
    //设置详情信息。。。。
    
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

@end
