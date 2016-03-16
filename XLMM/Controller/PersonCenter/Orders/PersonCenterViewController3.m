//
//  PersonCenterViewController3.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//


//全部订单

#import "PersonCenterViewController3.h"
#import "MMClass.h"
#import "XiangQingViewController.h"
#import "DingdanModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "UIViewController+NavigationBar.h"
#import "SingleOrderViewCell.h"
#import "MoreOrdersViewCell.h"
#import "NSString+URL.h"
#import "MJPullGifHeader.h"
#import "SVProgressHUD.h"




#define kSimpleCellIdentifier @"simpleCell"


//全部订单界面

@interface PersonCenterViewController3 ()

@end

@implementation PersonCenterViewController3{
    NSMutableArray *dataArray;
    BOOL _isFirst;
    NSDictionary *diciontary;
    UIAlertView *alterView;
    NSArray *ordersArray;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    
}



- (void)reload
{
    NSLog(@"reload");
  
    
}

- (void)loadMore
{
    NSLog(@"loadmore");
    NSString *urlString = [diciontary objectForKey:@"next"];
    if ([urlString class] == [NSNull class]) {
        NSLog(@"no more");
//        if ([self.quanbuCollectionView.mj_header isRefreshing]) {
//            [self.quanbuCollectionView.mj_header endRefreshing];
//            
//        }
      
        [alterView show];
        return;
    }
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDingdanData:)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"全部订单";
    
    [self createNavigationBarWithTitle:@"全部订单" selecotr:@selector(backBtnClicked:)];
    _isFirst = YES;
    dataArray = [[NSMutableArray alloc] initWithCapacity:5];

    
    alterView = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"没有更多订单"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil
                 , nil];
    
    [self.view addSubview:[[UIView alloc] init]];
    [self.view addSubview:self.quanbuCollectionView];

    
    [self.quanbuCollectionView registerClass:[SingleOrderViewCell class] forCellWithReuseIdentifier:@"SingleOrderCell"];
    [self.quanbuCollectionView registerClass:[MoreOrdersViewCell class] forCellWithReuseIdentifier:@"MoreOrdersCell"];
    
    
    
    
    self.quanbuCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self downloadData];
    
//    
//    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.quanbuCollectionView.mj_header = header;
//    [self.quanbuCollectionView.mj_header beginRefreshing];
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
            [self loadMore];
            [self.quanbuCollectionView.mj_footer endRefreshing];
        });
    }];
    footer.hidden = YES;
    
    self.quanbuCollectionView.mj_footer = footer;
    
    
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData{
    
    NSLog(@"下载数据");
    
    [self downLoadWithURLString:kQuanbuDingdan_URL andSelector:@selector(fetchedDingdanData:)];
    
}

-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    UILabel *label = (UILabel *)[defaultView viewWithTag:300];
    label.text = @"亲,您暂时还没有订单哦～快去看看吧!";
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}

-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)fetchedDingdanData:(NSData *)responsedata{
//    if ([self.quanbuCollectionView.mj_header isRefreshing]) {
//        [self.quanbuCollectionView.mj_header endRefreshing];
//
//    }
    [SVProgressHUD dismiss];
    NSError *error = nil;
    diciontary = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    NSLog(@"array = %@", diciontary);
    NSArray *array = [diciontary objectForKey:@"results"];
    if (array.count == 0) {
        NSLog(@"没有订单");
        [self displayDefaultView];
        return;
    }
    for (NSDictionary *dic in array) {
        NSLog(@"dic = %@" , dic);
        DingdanModel *model = [DingdanModel new];
        model.dingdanID = [dic objectForKey:@"id"];
        model.dingdanURL = [dic objectForKey:@"url"];
        model.dingdanbianhao = [dic objectForKey:@"tid"];
        model.imageURLString = [dic objectForKey:@"order_pic"];
        model.dingdanTime = [dic objectForKey:@"created"];
        model.dingdanZhuangtai = [dic objectForKey:@"status_display"];
        model.dingdanJine = [dic objectForKey:@"payment"];
        model.ordersArray = [dic objectForKey:@"orders"];
        
        
        [dataArray addObject:model];
    }
    NSLog(@"dataArray = %@", dataArray);

    [self.quanbuCollectionView reloadData];
    
    
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


#pragma mark -----CollectionViewDelegate-----

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 118);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   // QuanbuCollectionCell *cell = (QuanbuCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSimpleCellIdentifier forIndexPath:indexPath];
    DingdanModel *model = [dataArray objectAtIndex:indexPath.row];
    
    if (model.ordersArray.count == 1) {
        SingleOrderViewCell *cell = (SingleOrderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SingleOrderCell" forIndexPath:indexPath];
        
        NSDictionary *details = [model.ordersArray objectAtIndex:0];
        
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
        cell.orderImageView.contentMode = UIViewContentModeScaleAspectFill;
       // cell.orderImageView.clipsToBounds = YES;
//        [self.prp_imageViewsetContentMode:UIViewContentModeScaleAspectFill];
//        
//        self.prp_imageView.clipsToBounds = YES;
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%@", [details objectForKey:@"num"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"payment"] floatValue]];
        NSString *string = [details objectForKey:@"status_display"];
        
        if ([string isEqualToString:@"待付款"]) {
            cell.statusLabel.text = @"待支付";
        } else if ([string isEqualToString:@"已付款"]){
            cell.statusLabel.text = @"商品准备中";
        } else if ([string isEqualToString:@"已发货"]){
            cell.statusLabel.text = @"配送中";
        } else if ([string isEqualToString:@"交易关闭"]){
            cell.statusLabel.text = @"交易关闭";
        } else if ([string isEqualToString:@"交易成功"]){
            cell.statusLabel.text = @"已完成";
        } else if ([string isEqualToString:@"订单创建"]){
            cell.statusLabel.text = @"订单创建";
    
        } else if ([string isEqualToString:@"确认签收"]){
            cell.statusLabel.text = @"已签收";
        } else if ([string isEqualToString:@"退款关闭"]){
            cell.statusLabel.text = @"退款关闭";
        }
        
        
//        for (int i = 0; i < dataArray.count; i++) {
//            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
//            [btn removeFromSuperview];
//        }
//    
//    
//        if ([string isEqualToString:@"已发货"]) {
//            NSLog(@"已经发货");
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//    
//            [button setTitle:@"确认收货" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(querenQianshou:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        } else if ([string isEqualToString:@"待付款"]){
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//    
//            [button setTitle:@"立即支付" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(lijizhifu:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        } else if ([string isEqualToString:@"已付款"]){
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//    
//            [button setTitle:@"申请退款" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(shenqingtuikuan:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        } else if ([string isEqualToString:@"交易成功"]){
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//    
//            [button setTitle:@"退货退款" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        }
        return cell;
        
    } else {
        MoreOrdersViewCell *cell = (MoreOrdersViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MoreOrdersCell" forIndexPath:indexPath];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.dingdanJine floatValue]];
        for (int i = 1101; i <= 1106; i++) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            imageView.hidden = YES;
        }
        for (int i = 1101; i < model.ordersArray.count + 1101; i++) {
            NSDictionary *details = [model.ordersArray objectAtIndex:i - 1101];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            NSLog(@"imageView = %@", imageView);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
            imageView.hidden = NO;
            
        }
        if ([model.dingdanZhuangtai isEqualToString:@"待付款"]) {
            cell.statusLabel.text = @"待支付";
        } else if ([model.dingdanZhuangtai isEqualToString:@"已付款"]){
            cell.statusLabel.text = @"商品准备中";
        } else if ([model.dingdanZhuangtai isEqualToString:@"已发货"]){
            cell.statusLabel.text = @"配送中";
        } else if ([model.dingdanZhuangtai isEqualToString:@"交易关闭"]){
            cell.statusLabel.text = @"交易关闭";
        } else if ([model.dingdanZhuangtai isEqualToString:@"交易成功"]){
            cell.statusLabel.text = @"已完成";
        } else if ([model.dingdanZhuangtai isEqualToString:@"订单创建"]){
            cell.statusLabel.text = @"订单创建";
            
        } else if ([model.dingdanZhuangtai isEqualToString:@"退款关闭"]){
            cell.statusLabel.text = @"退款关闭";
        } else if ([model.dingdanZhuangtai isEqualToString:@"确认签收"]){
            cell.statusLabel.text = @"已签收";
        }
        
//        
//        for (int i = 0; i < dataArray.count; i++) {
//            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
//            [btn removeFromSuperview];
//        }
//        
//        
//        if ([model.dingdanZhuangtai isEqualToString:@"已发货"]) {
//            NSLog(@"已经发货");
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//            
//            [button setTitle:@"确认收货" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(querenQianshou:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        } else if ([model.dingdanZhuangtai isEqualToString:@"待付款"]){
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//            
//            [button setTitle:@"立即支付" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(lijizhifu:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        } else if ([model.dingdanZhuangtai isEqualToString:@"已付款"]){
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//            
//            [button setTitle:@"申请退款" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(shenqingtuikuan:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        } else if ([model.dingdanZhuangtai isEqualToString:@"交易成功"]){
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//            button.tag = indexPath.row +100;
//            
//            [button setTitle:@"退货退款" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//            button.layer.cornerRadius = 12.5;
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//            [cell.contentView addSubview:button];
//        }
        return cell;
        
    }

    
}

- (void)lijizhifu:(UIButton *)button{
    NSLog(@"立即支付");
    
}

- (void)shenqingtuikuan:(UIButton *)button{
    NSLog(@"申请退款");
    
}

- (void)tuihuotuikuan:(UIButton *)button{
    NSLog(@"退货退款");
    
}

- (void)querenQianshou:(UIButton *)button{
    NSLog(@"确认收货");

    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
    XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
    //http://m.xiaolu.so/rest/v1/trades/86412/details
    
       xiangqingVC.dingdanModel = [dataArray objectAtIndex:indexPath.row];
    xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, xiangqingVC.dingdanModel.dingdanID];
    NSLog(@"url = %@", xiangqingVC.urlString);

    
    [self.navigationController pushViewController:xiangqingVC animated:YES];
    
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