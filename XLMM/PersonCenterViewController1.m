//
//  PersonCenterViewController1.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController1.h"
#import "MMClass.h"
#import "XiangQingViewController.h"
#import "UIViewController+NavigationBar.h"

#define kSimpleCellIdentifier @"simpleCell"

#import "SingleOrderViewCell.h"
#import "MoreOrdersViewCell.h"
#import "NSString+URL.h"
#import "SVProgressHUD.h"




@interface PersonCenterViewController1 (){
    NSTimer *theTimer;
    NSString *shengyushijian;
    UILabel *shengyuTimeLabel[10];
    NSString *createdString;
    
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
    self.navigationController.navigationBarHidden = YES;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    } 
}

//待支付界面 。。。。

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"待支付订单" selecotr:@selector(btnClicked:)];
    
    self.labelArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:[[UIView alloc] init]];
    self.collectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [self.collectionView registerClass:[SingleOrderViewCell class] forCellWithReuseIdentifier:@"SingleOrderCell"];
    [self.collectionView registerClass:[MoreOrdersViewCell class] forCellWithReuseIdentifier:@"MoreOrdersCell"];
    [SVProgressHUD showWithStatus:@"加载中..."];
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
    [SVProgressHUD dismiss];
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    
    
    self.dataArray = [json objectForKey:@"results"];
    NSLog(@"dataArray = %@", self.dataArray);
  
    
    self.collectionView.contentSize = CGSizeMake(SCREENWIDTH, 120 * self.dataArray.count);
    [self.collectionView reloadData];
    
    [self createTimeLabels];
    
    
    
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"无待支付列表");
        
        [self displayDefaultView];
        return;
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:self.dataArray repeats:YES];
    
    
}
-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    UILabel *label = (UILabel *)[defaultView viewWithTag:300];
    label.text = @"亲,您暂时还没有待支付订单哦～快去看看吧!";
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}



-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)createTimeLabels{
    for (int i = 0; i<self.dataArray.count; i++) {
       
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 222, 0, 100, 35)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor textDarkGrayColor];
        [self.labelArray addObject:label];
    }
    NSLog(@"label = %@", self.labelArray);
}






- (void)panClicked:(UIGestureRecognizer *)gesture{
    NSLog(@"tap");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)gotoRootView:(UIButton *)button{
    NSLog(@"首页观光");
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return CGSizeMake(SCREENWIDTH, 118);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *diction = [self.dataArray objectAtIndex:indexPath.row];
    NSArray *orderArray = [diction objectForKey:@"orders"];
    
    if (orderArray.count == 1) {
        SingleOrderViewCell *cell = (SingleOrderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SingleOrderCell" forIndexPath:indexPath];
        
        NSDictionary *details = [orderArray objectAtIndex:0];
        
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
        cell.orderImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%@", [details objectForKey:@"num"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"payment"] floatValue]];
        NSString *string = [details objectForKey:@"status_display"];
        
            cell.statusLabel.text = @"待支付";
       
        
        
        for (int i = 0; i < self.dataArray.count; i++) {
            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:i + 10000];
            [label removeFromSuperview];
            [btn removeFromSuperview];
        }
        UILabel *label = [self.labelArray objectAtIndex:indexPath.row];
        label.tag = indexPath.row + 10000;
        label.frame = CGRectMake(SCREENWIDTH - 240, 10, 125, 16);
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor textDarkGrayColor];
        [cell.contentView addSubview:label];
       
        
        
        if ([string isEqualToString:@"待付款"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
            button.tag = indexPath.row +100;
            
            [button setTitle:@"立即支付" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(lijizhifu:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
            button.layer.cornerRadius = 12.5;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
            [cell.contentView addSubview:button];
            button.userInteractionEnabled = NO;
        }
  
        return cell;
       
    }
    else{
        MoreOrdersViewCell *cell = (MoreOrdersViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MoreOrdersCell" forIndexPath:indexPath];
      //  cell.paymentLabel.text = [[NSString stringWithFormat:@"¥%.1f", [[diction objectForKey:@"payment"]floatValue]];
        
        cell.paymentLabel.text = [NSString stringWithFormat:@"%.1f", [[diction objectForKey:@"payment"] floatValue]];
        for (int i = 1101; i <= 1106; i++) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            imageView.hidden = YES;
        }
        for (int i = 1101; i < orderArray.count + 1101; i++) {
            NSDictionary *details = [orderArray objectAtIndex:i - 1101];
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
        for (int i = 0; i < self.dataArray.count; i++) {
           // UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:i + 10000];
            [label removeFromSuperview];
            //[btn removeFromSuperview];
        }
        UILabel *label = [self.labelArray objectAtIndex:indexPath.row];
        label.tag = indexPath.row + 10000;
        label.frame = CGRectMake(SCREENWIDTH - 240, 10, 125, 16);
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor textDarkGrayColor];
        [cell.contentView addSubview:label];

        cell.statusLabel.text = @"待支付";
      //  NSString *string = [diction objectForKey:@"status_display"];
        
//        if ([string isEqualToString:@"待付款"]) {
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
//            
//            button.userInteractionEnabled = NO;
//            [cell.contentView addSubview:button];
//        }
        
     
        return cell;
    }
}

- (void)lijizhifu:(UIButton *)button{
    NSLog(@"立即支付");
    NSLog(@"tag = %lu", (unsigned long)button.tag);
    
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
    xiangqingVC.createString = createdString;
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
        
        
       // NSLog(@"string  = %@", string);
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;

        //  2015-09-06T16:35:25
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        //string = [NSMutableString stringWithString: @"2015/11/09 18:55:55"];
        NSDate *date = [formatter dateFromString:string];
        createdString = string;

       // NSLog(@"%@", date);
        
        NSDate *endDate = [NSDate dateWithTimeInterval:20*60 sinceDate:date];
      //  NSLog(@"endDate = %@",endDate);
        
      
        NSInteger unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitHour |
        NSCalendarUnitMinute |
        NSCalendarUnitSecond;
          NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:endDate options:0];

        shengyushijian = [NSString stringWithFormat:@"剩余时间%02ld:%02ld", (long)[d minute], (long)[d second]];
     //   NSLog(@"shengyu shijian = %@" , shengyushijian);
        if ([d minute] < 0 || [d second] < 0) {
            shengyushijian = @"剩余时间00:00";
        }
#pragma mark 设置倒计时
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
