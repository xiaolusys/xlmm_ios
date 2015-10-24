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
#import "XiangQingViewController.h"
#import "UIViewController+NavigationBar.h"

#define kSimpleCellIdentifier @"simpleCell"


@interface PersonCenterViewController1 (){
    NSTimer *theTimer;
    NSString *shengyushijian;
    UILabel *shengyuTimeLabel[10];
}

@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *labelArray;

@end

@implementation PersonCenterViewController1


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self downlaodData];

  
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
    [self createNavigationBarWithTitle:@"待支付订单" selecotr:@selector(btnClicked:)];
    
    self.labelArray = [[NSMutableArray alloc] init];
   // [self createInfo];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerClass:[ZhiFuCollectionCell class] forCellWithReuseIdentifier:kSimpleCellIdentifier];
    //self.dataArray = [[NSMutableArray alloc] init];
    [self.view addSubview:[[UIView alloc] init]];
    
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    
    self.dataArray = [json objectForKey:@"results"];
    NSLog(@"dataArray = %@", self.dataArray);
    
    self.collectionView.contentSize = CGSizeMake(SCREENWIDTH, 120*self.dataArray.count);
    [self.collectionView reloadData];
    
    [self createTimeLabels];
    
    
    
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"无待支付列表");
        
        [self creatrDefaultView];
        return;
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:self.dataArray repeats:YES];
    
    
}
- (void)createTimeLabels{
    for (int i = 0; i<self.dataArray.count; i++) {
       
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(256, 8, 60, 15)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithR:229 G:49 B:120 alpha:1];
        [self.labelArray addObject:label];
    }
    NSLog(@"label = %@", self.labelArray);
}

- (void)creatrDefaultView{
    
    
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 328/2, 382/2);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    CGRect rect = imageView.frame;
    rect.origin.y = 100;
    imageView.frame = rect;
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"您的待支付还是空的";
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.center = self.view.center;
    
    CGRect labelrect = label1.frame;
    labelrect.origin.y = 300;
    label1.frame = labelrect;
    
    
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label2.font = [UIFont systemFontOfSize:18];
    label2.text = @"去首页逛逛吧~~";
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = self.view.center;
    
    CGRect labelFram = label2.frame;
    labelFram.origin.y = 330;
    label2.frame = labelFram;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, SCREENHEIGHT - 50, SCREENWIDTH - 16, 44)];
    
    [button setTitle:@"去首页逛逛" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithR:249 G:172 B:20 alpha:1] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(gotoRootView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:2];
    button.layer.cornerRadius = 8;
    [button.layer setBorderColor:[UIColor colorWithR:249 G:172 B:20 alpha:1].CGColor];
    imageView.userInteractionEnabled = NO;
    label1.userInteractionEnabled = NO;
    label2.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panClicked:)];
    [self.view addGestureRecognizer:tap];
    
    
    [self.view addSubview:label2];
    
}

- (void)panClicked:(UIGestureRecognizer *)gesture{
    NSLog(@"tap");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (void)gotoRootView:(UIButton *)button{
    NSLog(@"首页观光");
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
    
    
    for (int i = 0; i<self.labelArray.count; i++) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:i +100];
        NSLog(@"label = %@", label);
        [label removeFromSuperview];
        
    }
    
    
     UILabel *label = (UILabel *)[self.labelArray objectAtIndex:indexPath.row];
    NSLog(@"label = %@ and index.row = %ld", label, (long)indexPath.row);
    label.tag = indexPath.row +100;
    
    [cell.contentView addSubview:label];
    
    
    
    cell.statusLabel.text = [dic objectForKey:@"status_display"];
    cell.paymentLable.text = [NSString stringWithFormat:@"¥%.1f",[[dic objectForKey:@"payment"] floatValue]];
    cell.idLabel.text = [dic objectForKey:@"tid"];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld : %ld", (long)indexPath.section, (long)indexPath.row);
    XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *ID = [dic objectForKey:@"id"];
    NSLog(@"id = %@", ID);
    
       //      http://m.xiaolu.so/rest/v1/trades/86412/details
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, ID];
    NSLog(@"urlString = %@", urlString);
    xiangqingVC.urlString = urlString;
    [self.navigationController pushViewController:xiangqingVC animated:YES];
    
    
    
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
     //   NSLog(@"shengyu shijian = %@" , shengyushijian);
        if ([d minute] < 0 || [d second] < 0) {
            shengyushijian = @"00:00";
        }
        UILabel *label = (UILabel *)[self.labelArray objectAtIndex:i];
        label.text = shengyushijian;
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
