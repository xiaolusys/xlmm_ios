//
//  XiangQingViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/21.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "XiangQingViewController.h"
#import "DingdanModel.h"
#import "MMClass.h"
#import "XiangQingView.h"
#import "PerDingdanModel.h"
#import "DingDanXiangQingModel.h"
#import "UIImageView+WebCache.h"

@interface XiangQingViewController ()




@end

@implementation XiangQingViewController{
    NSMutableArray *dataArray;
    UIActivityIndicatorView *activityView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createInfo];
    
    [self.view addSubview:self.xiangqingScrollView];
    self.screenWidth.constant = SCREENWIDTH;
    self.myViewHeight.constant = 0;
    
    
    
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2-80);
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    
    [self downloadData];
}

- (void)downloadData{
    
    NSLog(@"下载数据");
    
    NSString *urlString = [NSString stringWithFormat:@"%@/details", _dingdanModel.dingdanURL];
    NSLog(@"detailsURL = %@", urlString);
    
    
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDingdanData:)];
    
}

- (void)fetchedDingdanData:(NSData *)responsedata{
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    NSLog(@"JSON = %@", dicJson);
    
    [activityView removeFromSuperview];


    self.zhuangtaiLabel.text = [dicJson objectForKey:@"status_display"];
    self.bianhaoLabel.text = [dicJson objectForKey:@"tid"];
    
    NSMutableString *string = [NSMutableString stringWithString:[dicJson objectForKey:@"created"]];
    NSRange range = [string rangeOfString:@"T"];
    [string deleteCharactersInRange:range];
    [string insertString:@"  " atIndex:range.location];
    
    self.timeLabel.text = string;
    self.jineLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"payment"]];
    
    self.nameLabel.text = [dicJson objectForKey:@"receiver_name"];
    self.phoneLabel.text = [dicJson objectForKey:@"receiver_mobile"];
    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@",
                           [dicJson objectForKey:@"receiver_state"],
                           [dicJson objectForKey:@"receiver_city"],
                           [dicJson objectForKey:@"receiver_district"]];
    self.addressLabel.text = addressStr;
    
    self.allPriceLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"total_fee"]];
    self.yunfeiLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"post_fee"]];
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥-%@", [dicJson objectForKey:@"discount_fee"]];
    self.yingfuLabel.text = [NSString stringWithFormat:@"￥%@", [dicJson objectForKey:@"payment"]];
    
    NSArray *orderArray = [dicJson objectForKey:@"orders"];
    for (NSDictionary *dic in orderArray) {
        PerDingdanModel *model = [PerDingdanModel new];
        model.urlString = [dic objectForKey:@"pic_path"];
        model.sizeString = [dic objectForKey:@"sku_name"];
        model.numberString = [dic objectForKey:@"num"];
        model.priceString = [dic objectForKey:@"total_fee"];
        model.nameString = [dic objectForKey:@"title"];
        [dataArray addObject:model];
        
    }
       NSLog(@"dataArray = %@", dataArray);
    
    [self createXiangQing];
    
    
    
 
    NSLog(@"finished!");
    
}

- (void)createXiangQing{
    NSUInteger number = dataArray.count;
    self.myViewHeight.constant = number * 120;
    XiangQingView *owner = [XiangQingView new];
    PerDingdanModel *model = nil;
    for (int i = 0; i<number ; i++) {
        
        
        [[NSBundle mainBundle] loadNibNamed:@"XiangQingView" owner:owner options:nil];
        owner.myView.frame = CGRectMake(0, 0 + 120 * i, SCREENWIDTH, 120);
        
        model = [dataArray objectAtIndex:i];
        [owner.frontView sd_setImageWithURL:[NSURL URLWithString:model.urlString]];
        owner.nameLabel.text = model.nameString;
        owner.sizeLabel.text = model.sizeString;
        owner.numberLabel.text = [NSString stringWithFormat:@"%@", model.numberString];
        owner.priceLabel.text =[NSString stringWithFormat:@"¥%@", model.priceString];
        
        
        [self.myXiangQingView addSubview:owner.myView];
        
    }

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

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"订单详情";
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
