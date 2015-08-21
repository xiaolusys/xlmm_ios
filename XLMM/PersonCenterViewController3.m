//
//  PersonCenterViewController3.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController3.h"
#import "MMClass.h"
#import "XiangQingViewController.h"
#import "DingdanModel.h"
#import "UIImageView+WebCache.h"

#define kSimpleCellIdentifier @"simpleCell"


@interface PersonCenterViewController3 ()

@end

@implementation PersonCenterViewController3{
    NSMutableArray *dataArray;
    UIActivityIndicatorView *activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.quanbuCollectionView];
    // Do any additional setup after loading the view from its nib.
    self.title = @"全部订单";
    dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2-80);
    [activityView startAnimating];
    
    [self.quanbuCollectionView addSubview:activityView];
    

    
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
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    NSLog(@"array = %@", dicJson);
    NSArray *array = [dicJson objectForKey:@"results"];
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
    [activityView stopAnimating];
    [activityView removeFromSuperview];
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
