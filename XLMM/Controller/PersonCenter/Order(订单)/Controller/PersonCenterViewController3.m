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
#import "AFNetworking.h"
#import "Masonry.h"



#define kSimpleCellIdentifier @"simpleCell"


//全部订单界面

@interface PersonCenterViewController3 ()

@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong) DingdanModel *goodsModel;

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
//    self.navigationController.navigationBarHidden = NO;
    
    
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
      [self.quanbuCollectionView.mj_footer endRefreshingWithNoMoreData];
//        [alterView show];
        return;
    }
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.quanbuCollectionView.mj_footer endRefreshing];
        if (!responseObject) return;
        
        [self fetchedDingdanData:responseObject ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.quanbuCollectionView.mj_footer endRefreshing];
        NSLog(@"%@获取数据失败",urlString);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
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
    

    [self downloadData];
    
    
    
    
//    
//    MJPullGifHeader *header = [MJPullGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.quanbuCollectionView.mj_header = header;
//    [self.quanbuCollectionView.mj_header beginRefreshing];
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];

    }];
    footer.hidden = YES;
    
    self.quanbuCollectionView.mj_footer = footer;
    [self createButton];
    
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData{
    
    NSLog(@"下载数据 %@", kQuanbuDingdan_URL);
    [SVProgressHUD showWithStatus:@"加载中..."];
//    [self downLoadWithURLString:kQuanbuDingdan_URL andSelector:@selector(fetchedDingdanData:)];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:kQuanbuDingdan_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        if (!responseObject) return;
        
        [self fetchedDingdanData:responseObject ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
  
    
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

- (void)fetchedDingdanData:(NSDictionary *)responsedata{
//    if ([self.quanbuCollectionView.mj_header isRefreshing]) {
//        [self.quanbuCollectionView.mj_header endRefreshing];
//
//    }
    if(responsedata == nil)
        return;

//    NSError *error = nil;
//    diciontary = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    diciontary = responsedata;
//    NSLog(@"array = %@", diciontary);
    NSArray *array = [diciontary objectForKey:@"results"];
    if (array.count == 0) {
        NSLog(@"没有订单");
        [self displayDefaultView];
        return;
    }
    for (NSDictionary *dic in array) {
        DingdanModel *model = [DingdanModel new];
        model.dingdanID = [dic objectForKey:@"id"];
        model.dingdanURL = [dic objectForKey:@"url"];
        model.dingdanbianhao = [dic objectForKey:@"tid"];
        model.imageURLString = [dic objectForKey:@"order_pic"];
        model.dingdanTime = [dic objectForKey:@"created"];
        model.status_display = [dic objectForKey:@"status_display"]; //status_display
        model.dingdanJine = [dic objectForKey:@"payment"];
        model.ordersArray = [dic objectForKey:@"orders"];
        model.status = [dic objectForKey:@"status"];
        
        
        
        [dataArray addObject:model];
        self.goodsModel = model;
    }
//    NSLog(@"dataArray = %@", dataArray);

    [self.quanbuCollectionView reloadData];
    
    
}

//- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        if (data == nil) {
//            return ;
//        }
//        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
//        
//    });
//}


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
    NSLog(@"model.ordersArray.count  %lu", (unsigned long)model.ordersArray.count );
    if (model.ordersArray.count == 1) {
        SingleOrderViewCell *cell = (SingleOrderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SingleOrderCell" forIndexPath:indexPath];
        
        NSDictionary *details = [model.ordersArray objectAtIndex:0];
//        NSLog(@"detail %@", details);
        
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
        cell.orderImageView.contentMode = UIViewContentModeScaleAspectFill;
       // cell.orderImageView.clipsToBounds = YES;
//        [self.prp_imageViewsetContentMode:UIViewContentModeScaleAspectFill];
//        
//        self.prp_imageView.clipsToBounds = YES;
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%@", [details objectForKey:@"num"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.2f", [[details objectForKey:@"payment"] floatValue]];
        cell.statusLabel.text = model.status_display;

        return cell;
        
    } else {
        MoreOrdersViewCell *cell = (MoreOrdersViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MoreOrdersCell" forIndexPath:indexPath];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.dingdanJine floatValue]];
        for (int i = 1101; i <= 1106; i++) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            imageView.hidden = YES;
        }
        for (int i = 1101; i < model.ordersArray.count + 1101; i++) {
            NSDictionary *details = [model.ordersArray objectAtIndex:i - 1101];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
//            NSLog(@"imageView = %@", imageView);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
            imageView.hidden = NO;
            
        }

        cell.statusLabel.text = model.status_display;

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
    NSLog(@"allorders didSelectItemAtIndexPath %@", indexPath);
    XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
    //http://m.xiaolu.so/rest/v1/trades/86412/details
    
    self.goodsModel = [dataArray objectAtIndex:indexPath.row];
    xiangqingVC.goodsArr = self.goodsModel.ordersArray;
    xiangqingVC.dingdanModel = self.goodsModel;
    xiangqingVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@", Root_URL, xiangqingVC.dingdanModel.dingdanID];
    NSLog(@"url = %@", xiangqingVC.urlString);

    
    [self.navigationController pushViewController:xiangqingVC animated:YES];
    
}


#pragma mark -- 添加返回顶部按钮
- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    [self.quanbuCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.topButton.hidden = YES;
}
#pragma mark -- 添加滚动的协议方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.5 animations:^{
        if (dataArray.count == 0) {
            self.topButton.hidden = YES;
        }else {
            self.topButton.hidden = NO;
        }
    }];
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenBackTopBtn) userInfo:nil repeats:NO];
//}
//- (void)hiddenBackTopBtn {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.topButton.hidden = YES;
//    }];
//}

@end



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


//
//        for (int i = 0; i < dataArray.count; i++) {
//            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
//            [btn removeFromSuperview];
//        }
//
//
//        if ([model.status_display isEqualToString:@"已发货"]) {
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
//        } else if ([model.status_display isEqualToString:@"待付款"]){
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
//        } else if ([model.status_display isEqualToString:@"已付款"]){
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
//        } else if ([model.status_display isEqualToString:@"交易成功"]){
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