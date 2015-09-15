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



#define kSimpleCellIdentifier @"simpleCell"


@interface PersonCenterViewController3 ()

@end

@implementation PersonCenterViewController3{
    NSMutableArray *dataArray;
    BOOL _isFirst;
    NSDictionary *diciontary;
    UIAlertView *alterView;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    //[self downloadData];
    
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





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"全部订单";
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
    
    [self createInfo];
    [self downloadData];
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
        [dataArray addObject:model];
    }
    NSLog(@"dataArray = %@", dataArray);
//    [activityView stopAnimating];
//    [activityView removeFromSuperview];
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

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"全部订单";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 12, 12, 22);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
}



- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----CollectionViewDelegate-----

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 140);
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
    cell.timeLabel.text = string;
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURLString]];
    cell.bianhaoLabel.text = model.dingdanbianhao;
    cell.zhuangtaiLabel.text = model.dingdanZhuangtai;
    cell.jineLabel.text = [NSString stringWithFormat:@"¥%@",  model.dingdanJine];
    
    
    return cell;
    
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
