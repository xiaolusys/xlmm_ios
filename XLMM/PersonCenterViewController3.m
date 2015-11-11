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
    if (_isFirst) {
        //集成刷新控件
        
        [self setupRefresh];
        self.quanbuCollectionView.footerHidden=NO;
        self.quanbuCollectionView.headerHidden=NO;
        [self.quanbuCollectionView headerBeginRefreshing];
        _isFirst = NO;
    }
    
}

- (void)setupRefresh{
    
    
    
    [self.quanbuCollectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_quanbuCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    _quanbuCollectionView.headerPullToRefreshText = NSLocalizedString(@"下拉可以刷新", nil);
    _quanbuCollectionView.headerReleaseToRefreshText = NSLocalizedString (@"松开马上刷新",nil);
    _quanbuCollectionView.headerRefreshingText = NSLocalizedString(@"正在帮你刷新中", nil);
    
    _quanbuCollectionView.footerPullToRefreshText = NSLocalizedString(@"上拉可以加载更多数据", nil);
    _quanbuCollectionView.footerReleaseToRefreshText = NSLocalizedString(@"松开马上加载更多数据", nil);
    _quanbuCollectionView.footerRefreshingText = NSLocalizedString(@"正在帮你加载中", nil);
    
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self reload];
        sleep(1.5);
        [_quanbuCollectionView headerEndRefreshing];
        
    });
}


- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadMore];
        sleep(1.5);
        [_quanbuCollectionView footerEndRefreshing];
        
    });
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

    [self.quanbuCollectionView registerClass:[QuanbuCollectionCell class] forCellWithReuseIdentifier:kSimpleCellIdentifier];
    
    self.quanbuCollectionView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
    [self downloadData];
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData{
    
    NSLog(@"下载数据");
    
    [self downLoadWithURLString:kQuanbuDingdan_URL andSelector:@selector(fetchedDingdanData:)];
    
}

- (void)fetchedDingdanData:(NSData *)responsedata{
    NSError *error = nil;
    diciontary = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    NSLog(@"array = %@", diciontary);
    NSArray *array = [diciontary objectForKey:@"results"];
    if (array.count == 0) {
        NSLog(@"没有订单");
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
        model.dingdanJine = [dic objectForKey:@"total_fee"];
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
    return CGSizeMake(SCREENWIDTH, 117);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QuanbuCollectionCell *cell = (QuanbuCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSimpleCellIdentifier forIndexPath:indexPath];
    DingdanModel *model = [dataArray objectAtIndex:indexPath.row];
    
    NSMutableString *string = [[NSMutableString alloc] initWithString: model.dingdanTime];
    NSRange range = [string rangeOfString:@"T"];
    NSLog(@"%d", (int)range.location);
    [string deleteCharactersInRange:range];
    [string insertString:@"  " atIndex:range.location];
    cell.timeLabel.text = @"";
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURLString]];
    cell.myImageView.layer.masksToBounds = YES;
    cell.myImageView.layer.borderWidth = 1;
    cell.myImageView.layer.borderColor = [UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor;
    cell.myImageView.layer.cornerRadius = 5;
    cell.bianhaoLabel.text = model.dingdanbianhao;
    cell.zhuangtaiLabel.text = model.dingdanZhuangtai;
    if ([model.dingdanZhuangtai isEqualToString:@"待付款"]) {
        cell.zhuangtaiLabel.text = @"待支付";
    } else if ([model.dingdanZhuangtai isEqualToString:@"已付款"]){
        cell.zhuangtaiLabel.text = @"商品准备中";
    } else if ([model.dingdanZhuangtai isEqualToString:@"已发货"]){
        cell.zhuangtaiLabel.text = @"配送中";
    } else if ([model.dingdanZhuangtai isEqualToString:@"交易关闭"]){
        cell.zhuangtaiLabel.text = @"交易关闭";
    } else if ([model.dingdanZhuangtai isEqualToString:@"交易成功"]){
        cell.zhuangtaiLabel.text = @"已完成";
    } else if ([model.dingdanZhuangtai isEqualToString:@"创建订单"]){
        cell.zhuangtaiLabel.text = @"创建订单";

    }
    cell.jineLabel.text = [NSString stringWithFormat:@"¥%.1f",  [model.dingdanJine floatValue]];
    //cell.timeLabel
    if (model.ordersArray.count == 1) {
        cell.detailsView.hidden = NO;
        NSDictionary *details = [model.ordersArray objectAtIndex:0];
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%ld", (long)[[details objectForKey:@"num"] integerValue]];
        
        
        
    } else if (model.ordersArray.count == 0){
        cell.detailsView.hidden = NO;
        
    }
    else
    {
        cell.detailsView.hidden = YES;
        int number = 1102;
        
        for (int i = 1; i < model.ordersArray.count; i++) {
            NSDictionary *details = [model.ordersArray objectAtIndex:i];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:number++];
            imageView.hidden = NO;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.layer.borderWidth = 1;
            imageView.layer.borderColor = [UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[details objectForKey:@"pic_path"]]];
        }
   
        
        
        
        
        
    }
    for (int i = 0; i < dataArray.count; i++) {
        UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
        [btn removeFromSuperview];
    }
 
    
    if ([model.dingdanZhuangtai isEqualToString:@"已发货"]) {
        NSLog(@"已经发货");
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 5, 80, 25)];
        button.tag = indexPath.row +100;
        
        [button setTitle:@"确认收货" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(querenQianshou:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
        button.layer.cornerRadius = 12.5;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
        [cell.contentView addSubview:button];
    } else if ([model.dingdanZhuangtai isEqualToString:@"待付款"]){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 5, 80, 25)];
        button.tag = indexPath.row +100;
        
        [button setTitle:@"立即支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lijizhifu:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
        button.layer.cornerRadius = 12.5;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
        [cell.contentView addSubview:button];
    } else if ([model.dingdanZhuangtai isEqualToString:@"已付款"]){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 5, 80, 25)];
        button.tag = indexPath.row +100;
        
        [button setTitle:@"申请退款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shenqingtuikuan:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
        button.layer.cornerRadius = 12.5;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
        [cell.contentView addSubview:button];
    } else if ([model.dingdanZhuangtai isEqualToString:@"交易成功"]){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 5, 80, 25)];
        button.tag = indexPath.row +100;
        
        [button setTitle:@"退货退款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tuihuotuikuan:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
        button.layer.cornerRadius = 12.5;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
        [cell.contentView addSubview:button];
    } else if ([model.dingdanZhuangtai isEqualToString:@"交易关闭"]){
        
    } else {
        
    }
    return cell;
    
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
