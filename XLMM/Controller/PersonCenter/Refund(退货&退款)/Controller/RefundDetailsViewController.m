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
#import "XlmmMall.h"
#import "MMClass.h"
#import "JMReturnedGoodsController.h"
#import "JMTimeLineView.h"
#import "UIColor+RGBColor.h"


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
//    if (self.model.sid.length == 0 || [self.model.sid isEqualToString:@""]) {
//        self.topToRefundHeight.constant = 0;
//    }
    
    NSLog(@"return status=%ld good_status=%ld address=%@", (long)self.model.status, self.model.good_status, self.model.return_address);
    [self timeLine];
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
    if (self.model.has_good_return == 0) {
        self.createdLabel.text = @"申请退款";
    }else{
        self.createdLabel.text = @"申请退货";
        if(self.model.status == REFUND_STATUS_SELLER_AGREED){
            self.topToRefundHeight.constant = 0;
        }
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
//    FillWuliuController *wuliuVC = [[FillWuliuController alloc] initWithNibName:@"FillWuliuController" bundle:nil];
//    wuliuVC.model = self.model;
//    
    
    JMReturnedGoodsController *reGoodsVC = [[JMReturnedGoodsController alloc] init];
    reGoodsVC.model = self.model;
    
    
    
    [self.navigationController pushViewController:reGoodsVC animated:YES];
    
    
    
    
}

- (void)timeLine {
    NSInteger countNum = self.model.status;
    NSArray *desArr = [NSArray array];
    NSInteger count = 0;
    int i = 0;
    if (countNum == REFUND_STATUS_REFUND_CLOSE || countNum == REFUND_STATUS_SELLER_REJECTED || countNum == REFUND_STATUS_NO_REFUND) {
        NSString *str = self.model.status_display;
        if (self.model.has_good_return == 0) {
            //            self.createdLabel.text = @"申请退款";
            desArr = @[@"申请退款",str];
        }else{
            //            self.createdLabel.text = @"申请退货";
            desArr = @[@"申请退货",str];
        }
        
        count = desArr.count;
    }else {
        if (self.model.has_good_return == 0) {
//            self.createdLabel.text = @"申请退款";
            desArr = @[@"申请退款",@"同意申请",@"等待返款",@"退款成功"];
            countNum -= 3;
            for (i = 0; i < desArr.count; i++) {
                if (countNum == i) {
                    if (countNum >= 2) {
                        i-- ;
                    }
                    break ;
                }else {
                    continue ;
                }
            }
            count = i + 1;
        }else{
            desArr = @[@"申请退货",@"同意申请",@"填写快递单",@"仓库收货",@"等待返货",@"退货成功"];//退货待收
            countNum -= 3;
            for (i = 0; i < desArr.count; i++) {
                if (countNum == i) {
                    if (countNum >= 2) {
                        i++;
                    }
                    break ;
                }else {
                    continue ;
                }
            }
            count = i + 1;
            self.createdLabel.text = @"申请退货";
        }
    }
    

    JMTimeLineView *timeLineV = [[JMTimeLineView alloc] initWithTimeArray:nil andTimeDesArray:desArr andCurrentStatus:count andFrame:self.timeLineView.frame];
    timeLineV.backgroundColor = [UIColor lineGrayColor];
    [self.timeLineView addSubview:timeLineV];
    
    self.timeLineView.contentSize = CGSizeMake(70 * desArr.count, 60);
    self.timeLineView.showsHorizontalScrollIndicator = NO;


}



@end

/**
 
 //
 //
 //
 //    NSString *desStr = self.model.status_display;
 //    for (i = 0; i < desArr.count; i++) {
 //        if ([desStr isEqualToString:desArr[i]]) {
 //            break ;
 //        }else {
 //            continue ;
 //        }
 //    }
 //    count = i + 1;
 *  #define REFUND_STATUS_NO_REFUND  0
 #define REFUND_STATUS_BUYER_APPLY  3
 #define REFUND_STATUS_SELLER_AGREED  4
 #define REFUND_STATUS_BUYER_RETURNED_GOODS  5
 #define REFUND_STATUS_REFUND_CLOSE  1
 #define REFUND_STATUS_SELLER_REJECTED  2
 #define REFUND_STATUS_WAIT_RETURN_FEE  6
 #define REFUND_STATUS_REFUND_SUCCESS 7
 */






















