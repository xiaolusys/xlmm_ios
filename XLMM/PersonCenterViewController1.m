//
//  PersonCenterViewController1.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController1.h"
#import "ZhiFuCollectionCell.h"
#import "MMClass.h"

#define kSimpleCellIdentifier @"simpleCell"

@interface PersonCenterViewController1 (){
    NSTimer *theTimer;
    NSString *shengyushijian;
    UILabel *shengyuTimeLabel[10];
}

@property (nonatomic ,strong)NSArray *dataArray;

@end

@implementation PersonCenterViewController1


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待支付订单";
    
    [self createInfo];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerClass:[ZhiFuCollectionCell class] forCellWithReuseIdentifier:kSimpleCellIdentifier];
    //self.dataArray = [[NSMutableArray alloc] init];
    [self downlaodData];
    
}

- (void)downlaodData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kWaitpay_List_URL]];
        [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (void)fetchedWaipayData:(NSData *)data{
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"无待支付列表");
        return;
    }
    
    self.dataArray = [json objectForKey:@"results"];
    NSLog(@"dataArray = %@", self.dataArray);
    self.collectionView.contentSize = CGSizeMake(SCREENWIDTH, 120*self.dataArray.count);
    [self.collectionView reloadData];
    
    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:self.dataArray repeats:YES];
    
    
}
- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"待支付订单";
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
    
    NSLog(@"back to root");
    
}




#pragma mark ----CollectionViewDelegate-----

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 120);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZhiFuCollectionCell *cell = (ZhiFuCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSimpleCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell.myimageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"order_pic"]]];
    NSMutableString *string = [[NSMutableString alloc]initWithString:[dic objectForKey:@"created"]];
    NSRange range = [string rangeOfString:@"T"];
//    [string deleteCharactersInRange:range];
//    [string insertString:@" " atIndex:range.location];
    [string replaceCharactersInRange:range withString:@" "];
    range = [string rangeOfString:@"-"];
    [string replaceCharactersInRange:range withString:@"/"];
    range = [string rangeOfString:@"-"];
    [string replaceCharactersInRange:range withString:@"/"];
    cell.createLabel.text = string;
    
    int i = indexPath.row;
    shengyuTimeLabel[i] = [[UILabel alloc]initWithFrame:CGRectMake(256, 8, 60, 15)];
    shengyuTimeLabel[i].textAlignment = NSTextAlignmentLeft;
    shengyuTimeLabel[i].font = [UIFont systemFontOfSize:12];
    shengyuTimeLabel[i].textColor = [UIColor colorWithR:229 G:49 B:120 alpha:1];
    
    [cell.contentView addSubview:shengyuTimeLabel[i]];
    
    cell.timeLabel.text = shengyushijian;
    
    cell.statusLabel.text = [dic objectForKey:@"status_display"];
    cell.paymentLable.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"payment"]];
    cell.idLabel.text = [dic objectForKey:@"tid"];
    
    return cell;
    
}

//设计倒计时方法。。。。
- (void)timerFireMethod:(NSTimer*)thetimer
{
    NSArray  *array = thetimer.userInfo;
    
   // NSLog(@"array = %@", array);
    for (int i = 0; i<array.count; i++) {
        
        NSMutableString *string = [[NSMutableString alloc]initWithString:[[array objectAtIndex:i] objectForKey:@"created"]];
        NSRange range = [string rangeOfString:@"T"];
      
        [string replaceCharactersInRange:range withString:@" "];
        range = [string rangeOfString:@"-"];
        [string replaceCharactersInRange:range withString:@"/"];
        range = [string rangeOfString:@"-"];
        [string replaceCharactersInRange:range withString:@"/"];
        
      
        
      //  NSLog(@"string  = %@", string);
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;

        //  2015-09-06T16:35:25
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:string];
        
       // NSLog(@"%@", date);
        
        NSDate *endDate = [NSDate dateWithTimeInterval:20*60 sinceDate:date ];
      //  NSLog(@"endDate = %@",endDate);
        
      
        NSInteger unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitHour |
        NSCalendarUnitMinute |
        NSCalendarUnitSecond;
          NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:endDate options:0];

        shengyushijian = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
        NSLog(@"shengyu shijian = %@" , shengyushijian);
        if ([shengyushijian isEqualToString:@"00:00"]) {
            shengyushijian = @"00:00";
        }
        shengyuTimeLabel[i].text = shengyushijian;
    }

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
