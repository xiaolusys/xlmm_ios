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


#import "MJRefresh.h"
#import "SingleOrderViewCell.h"
#import "MoreOrdersViewCell.h"
#import "NSString+URL.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "DingdanModel.h"
#import "MJExtension.h"

#define kSimpleCellIdentifier @"simpleCell"

@interface PersonCenterViewController1 (){
    NSTimer *theTimer;
    NSString *shengyushijian;
    UILabel *shengyuTimeLabel[10];
    NSString *createdString;
    NSDictionary *diciontary;
    
}

@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *labelArray;
@property (nonatomic,strong) UIButton *topButton;

@end

@implementation PersonCenterViewController1


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self downlaodData];

  
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    [SVProgressHUD dismiss];
}

//待支付界面 。。。。

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"待支付订单" selecotr:@selector(btnClicked:)];
    
    self.labelArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:[[UIView alloc] init]];
    self.collectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    [self createButton];
    [self.collectionView registerClass:[SingleOrderViewCell class] forCellWithReuseIdentifier:@"SingleOrderCell"];
    [self.collectionView registerClass:[MoreOrdersViewCell class] forCellWithReuseIdentifier:@"MoreOrdersCell"];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    footer.hidden = YES;
    
    self.collectionView.mj_footer = footer;
    
}

- (void)loadMore
{
    NSLog(@"loadmore");
    NSString *urlString = [diciontary objectForKey:@"next"];
    if ([urlString class] == [NSNull class]) {
        NSLog(@"no more");

        [self.collectionView.mj_footer endRefreshingWithNoMoreData];

        return;
    }
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.collectionView.mj_footer endRefreshing];
        if (!responseObject) return;
        
        [self fetchedWaipayData:responseObject ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        NSLog(@"%@获取数据失败",urlString);
    }];
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)downlaodData{
    [SVProgressHUD showWithStatus:@"加载中..."];

    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:kWaitpay_List_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];

        if (!responseObject) return;
        
        [self fetchedWaipayData:responseObject ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];

    
}

- (void)fetchedWaipayData:(NSDictionary *)data{
        if (data == nil) {
        return;
    }
    
    diciontary = data;
    // NSLog(@"json = %@", json);
    
    
    self.dataArray = [diciontary objectForKey:@"results"];
    //NSLog(@"dataArray = %@", self.dataArray);
  
    
    self.collectionView.contentSize = CGSizeMake(SCREENWIDTH, 120 * self.dataArray.count);
    [self.collectionView reloadData];
    
    [self createTimeLabels];
    
    
    
    if ([[diciontary objectForKey:@"count"] integerValue] == 0) {
       // NSLog(@"无待支付列表");
        
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
//    NSLog(@"label = %@", self.labelArray);
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
        
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] JMUrlEncodedString]]];
        cell.orderImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%@", [details objectForKey:@"num"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.2f", [[details objectForKey:@"payment"] floatValue]];
        NSString *string = [diction objectForKey:@"status_display"];
        cell.statusLabel.text = string;
       
        
        
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
       
        return cell;
       
    }
    else{
        MoreOrdersViewCell *cell = (MoreOrdersViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MoreOrdersCell" forIndexPath:indexPath];
      //  cell.paymentLabel.text = [[NSString stringWithFormat:@"¥%.1f", [[diction objectForKey:@"payment"]floatValue]];
        
        cell.paymentLabel.text = [NSString stringWithFormat:@"%.2f", [[diction objectForKey:@"payment"] floatValue]];
        for (int i = 1101; i <= 1106; i++) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            imageView.hidden = YES;
        }
        for (int i = 1101; i < orderArray.count + 1101; i++) {
            NSDictionary *details = [orderArray objectAtIndex:i - 1101];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
          //  NSLog(@"imageView = %@", imageView);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] JMUrlEncodedString]]];
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


        NSString *string = [diction objectForKey:@"status_display"];
        cell.statusLabel.text = string;
        
     
        return cell;
    }
}

- (void)lijizhifu:(UIButton *)button{
  //  NSLog(@"立即支付");
   // NSLog(@"tag = %lu", (unsigned long)button.tag);
    
}
#pragma mark ---- 待支付订单跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  //  NSLog(@"%ld : %ld", (long)indexPath.section, (long)indexPath.row);
    XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *ID = [dic objectForKey:@"id"];
   // NSLog(@"id = %@", ID);
    DingdanModel *dingdanModel = [DingdanModel mj_objectWithKeyValues:dic];
    xiangqingVC.dingdanModel = dingdanModel;
    xiangqingVC.goodsArr = dic[@"orders"];
    //      http://m.xiaolu.so/rest/v1/trades/86412/details    //@"%@/rest/v2/trades/%@"
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@", Root_URL, ID];
  //  NSLog(@"urlString = %@", urlString);
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
        label.hidden = YES;
    }

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
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.topButton.hidden = YES;
}

//- (void)hiddenBackTopBtn {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.topButton.hidden = YES;
//    }];
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.dataArray.count == 0) {
            self.topButton.hidden = YES;
        }else {
            self.topButton.hidden = NO;
        }
    }];
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenBackTopBtn) userInfo:nil repeats:NO];
//}
@end
