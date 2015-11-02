//
//  MMCollectionController.m
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMCollectionController.h"
#import "CollectionModel.h"
#import "MMClass.h"
#import "PeopleCollectionCell.h"
#import "MMDetailsViewController.h"

@interface MMCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UICollectionView *collectionView;


@end

@implementation MMCollectionController{
    NSTimer *theTimer;
    UILabel *titleLabel;
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationController.navigationBarHidden = YES;
    [self downloadData];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([theTimer isValid]) {
        [theTimer invalidate];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品集合";
    NSLog(@"%@", self.urlString);
    //self.view.backgroundColor = [UIColor redColor];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self createCollectionView];
    [self createInfo];
    
    
}




- (void)createInfo{
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image.png"]];
    imageView.frame = CGRectMake(-4, 14, 22, 22);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:@"simpleCell"];
    [self.view addSubview:[[UIView alloc] init]];
    self.collectionView.backgroundColor = [UIColor colorWithR:245 G:245 B:245 alpha:1];

   // self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.collectionView];
}

- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlString]];
        [self performSelectorOnMainThread:@selector(fetchedCollectionData:)withObject:data waitUntilDone:YES];
        
    });
    
}
- (void)fetchedCollectionData:(NSData *)data{
    if (data == nil) {
        NSLog(@"urlstring = %@", _urlString);
        NSLog(@"集合页面数据下载失败");
    }
    NSError *error;
    
    [self.dataArray removeAllObjects];
    
    
    
    
//    NSLog(@"data = %@", data);
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"string = %@",string);
    
    NSArray *collections = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"error = %@", error);
    }
    
    NSLog(@"collections = %@", collections);
    for (NSDictionary *dic in collections) {
        CollectionModel *model = [CollectionModel new];
        
        model.agentPrice = [dic objectForKey:@"agent_price"];
        model.category = [dic objectForKey:@"category"];
        model.ID = [dic objectForKey:@"id"];
        model.isNewgood = [dic objectForKey:@"is_newgood"];
        model.isSaleopen = [dic objectForKey:@"is_saleopen"];
        model.isSaleout = [dic objectForKey:@"is_saleout"];
        model.memo = [dic objectForKey:@"memo"];
        model.name = [dic objectForKey:@"name"];
        model.outerId = [dic objectForKey:@"outer_id"];
        model.picPath = [dic objectForKey:@"pic_path"];
        model.remainNum = [dic objectForKey:@"remain_num"];
        model.saleTime = [dic objectForKey:@"sale_time"];
        model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
        model.url = [dic objectForKey:@"url"];
        model.wareBy = [dic objectForKey:@"ware_by"];
        model.productModel = [dic objectForKey:@"product_model"];
        
        [self.dataArray addObject:model];
        
    }
    
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [self timerFireMethod:theTimer];
    NSLog(@"dataArray = %@", _dataArray);
    [self.collectionView reloadData];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
     CollectionModel *model = [self.dataArray objectAtIndex:0];
    NSString *saleTime = model.saleTime;
  //  NSLog(@"saleTime = %@", saleTime);
    
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    NSDate *toDate = [formatter dateFromString:saleTime];
    
   
    
    
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   // NSDateComponents *comps =
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:toDate];
  //  NSLog(@"comps = %@", comps);
    
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
    int nextday = day + 1;
    
    // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:nextday];
    [endTime setHour:14];
    [endTime setMinute:0];
    [endTime setSecond:0];
 //   NSLog(@" end time = %@", endTime);
    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差
    
    NSDate *date = [NSDate date];
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ([d hour] < 0 || [d minute] < 0) {
        titleLabel.text = @"已下架";
     //   NSLog(@"已下架");
    } else{
        NSString * string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    //    NSLog(@"string = %@", string);
        titleLabel.text = string;
    }

    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((SCREENWIDTH-4)/2, (SCREENWIDTH-4)/2 + 60);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    [cell fillDataWithCollectionModel:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld : %ld",(long)indexPath.section, (long)indexPath.row);
    
    
    //   http://m.xiaolu.so/rest/v1/products/15809
    
    CollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *ID = model.ID;
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json", Root_URL, ID];
    NSLog(@"urlString = %@", string);
    MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
    detailsVC.urlString = string;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    
    //NSString *urlString = [];

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
