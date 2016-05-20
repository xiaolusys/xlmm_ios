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
#import "FillWuliuController.h"

#import "MMClass.h"


@interface RefundDetailsViewController (){
    UIView *backView;
    
    
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
    [self createNavigationBarWithTitle:@"退货(款)详情" selecotr:@selector(backClicked:)];
    [self setHeadInfo];
    [self setFootInfo];
    self.addressInfoButton.layer.cornerRadius = 13;
    self.addressInfoButton.layer.borderWidth = 0.5;
    self.addressInfoButton.layer.borderColor = [UIColor buttonEmptyBorderColor
                                                ].CGColor;
    self.headViewWidth.constant = SCREENWIDTH;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.hidden = YES;
    
    [self.view addSubview:backView];
    
    //没有订单号显示填写退货地址
    if (self.model.sid.length == 0 || [self.model.sid isEqualToString:@""]) {
        self.topToRefundHeight.constant = 0;
    }
    
    NSLog(@"%@", self.model.return_address);
    
}

- (void)setHeadInfo{
    self.bianhaoLabel.text = self.model.refund_no;

    self.displayLabel.text = self.model.status_display;
    self.titleLabel.text = self.model.title;
    self.sizeLabel.text = self.model.sku_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", self.model.payment];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.model.refund_num];
    self.refundPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.model.refund_fee];
    
    
    self.reasonLabel.text = self.model.reason;
    if ([self.model.pic_path isKindOfClass:[NSString class]] ) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.model.pic_path URLEncodedString]]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.circleView.layer.cornerRadius = 5;
    if (self.model.good_status == 0) {
        self.createdLabel.text = @"申请退款";
        self.topToRefundHeight.constant = 0;
    }else{
          self.createdLabel.text = @"申请退货";
    }
  
    self.statusLabel.text = self.model.status_display;
    self.createTimeLabel.text = [self stringReplaced:self.model.created];
    self.modifyTimeLabel.text = [self stringReplaced:self.model.modified];

}

- (NSString *)stringReplaced:(NSString *)string{
    NSMutableString *mutable = [string mutableCopy];
    NSRange range = {10, 1};
    if (mutable.length >= 11) {
        [mutable replaceCharactersInRange:range withString:@" "];
        
    }
    return mutable;
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

- (IBAction)addressInfoClicked:(id)sender {
    NSLog(@"退货地址信息");
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RefundAddressInfoView" owner:nil options:nil];
    UIView *infoView = views[0];
    infoView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIView *bgView = [infoView viewWithTag:100];
    bgView.layer.cornerRadius = 10;
    
    self.navigationController.navigationBarHidden = YES;
    backView.hidden = NO;
    backView.alpha = 0.6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeInfoView:)];
    [infoView addGestureRecognizer:tap];    
    
    UILabel *addressLabel = [infoView viewWithTag:500];
    UIButton *kefuButton = [infoView viewWithTag:800];
    [kefuButton addTarget:self action:@selector(lianxikefu:) forControlEvents:UIControlEventTouchUpInside];
    
    addressLabel.text = self.model.return_address;
    
    [self.view addSubview:infoView];
    
}

- (void)lianxikefu:(UIButton *)button{
//    NSLog(@"客服");
}
- (void)removeInfoView:(UIGestureRecognizer *)recognizer{
//    NSLog(@"move");
    backView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [recognizer.view removeFromSuperview];
    
}

- (IBAction)wuliuInfoClicked:(id)sender {
//    NSLog(@"填写物流信息");
    FillWuliuController *wuliuVC = [[FillWuliuController alloc] initWithNibName:@"FillWuliuController" bundle:nil];
    wuliuVC.model = self.model;
    
    [self.navigationController pushViewController:wuliuVC animated:YES];
    
}
@end
