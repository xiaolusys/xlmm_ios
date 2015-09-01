//
//  TodayViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/31.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TodayViewController.h"
#import "MMClass.h"
#import "Head1View.h"
#import "Head2View.h"
#import "PosterCollectionCell.h"
#import "PeopleCollectionCell.h"
#import "PromoteModel.h"
#import "PosterModel.h"
#import "ChildViewController.h"
#import "WomanViewController.h"


@interface TodayViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    
    UIView *ladyPoster;
    UIView *childPoster;
    
    NSMutableArray *childDataArray;
    NSMutableArray *ladyDataArray;
    NSMutableArray *posterDataArray;
    
    UIView *frontView;
    NSInteger childListNumber;
    NSInteger ladyListNumber;
 
    NSDictionary *jsonDic;
    
    NSString *myTimeLabelString;
    
    BOOL step1;
    BOOL step2;
    
    
    NSTimer *theTimer;

    UILabel *childTimeLabel;
    UILabel *ladyTimeLabel;
    
    
}

@property (nonatomic, retain) UICollectionView *myCollectionView;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    childDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    ladyDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    posterDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    step1 = NO;
    step2 = NO;
  
    
  //  myTimeLabelString = @"剩余1天23小时23分59秒";
    
    [self createCollectionView];
    
    [self downloadData];
    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kIsLogin];
    
    [userDefaults setInteger:0 forKey:NumberOfCart];
    [userDefaults synchronize];

    
    
    
}


//设计倒计时方法。。。。
- (void)timerFireMethod:(NSTimer*)theTimer
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
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
    
    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ((long)[d day] == 0) {
        myTimeLabelString = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    }
    else{
        myTimeLabelString = [NSString stringWithFormat:@"剩余%02ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
    
    }
    childTimeLabel.text = myTimeLabelString;
    ladyTimeLabel.text = myTimeLabelString;
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    [self.myCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:@"simpleCell"];
    [self.myCollectionView registerClass:[PosterCollectionCell class] forCellWithReuseIdentifier:@"posterView"];
    
    
    [self.myCollectionView registerClass:[Head1View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1View"];
    [self.myCollectionView registerClass:[Head2View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View"];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.myCollectionView];
}





- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kTODAY_PROMOTE_URL]];
        [self performSelectorOnMainThread:@selector(fetchedPromoteData:)withObject:data waitUntilDone:YES];
        
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kTODAY_POSTERS_URL]];
        [self performSelectorOnMainThread:@selector(fetchedPosterData:)withObject:data waitUntilDone:YES];
        
    });
    
}





#pragma mark --今题推荐数据解析


- (void)fetchedPosterData:(NSData *)data{
    NSError *error;
    NSLog(@"data = %@", data);
    if (data == nil) {
        [frontView removeFromSuperview];
        
        return;
    }
    jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"poster data : %@", jsonDic);
    
    NSDictionary *childDic = [[jsonDic objectForKey:@"chd_posters"] lastObject];
    NSLog(@"%@", childDic);
    PosterModel *childModel = [PosterModel new];
    childModel.imageURL = [childDic objectForKey:@"pic_link"];
    childModel.firstName = [[childDic objectForKey:@"subject"] objectAtIndex:0];
    childModel.secondName = [[childDic objectForKey:@"subject"] objectAtIndex:1];
    
    NSDictionary *ladyDic = [[jsonDic objectForKey:@"wem_posters"] lastObject];
    NSLog(@"%@", ladyDic);
    PosterModel *ladyModel = [PosterModel new];
    ladyModel.imageURL = [ladyDic objectForKey:@"pic_link"];
    ladyModel.firstName = [[ladyDic objectForKey:@"subject"] objectAtIndex:0];
    ladyModel.secondName = [[ladyDic objectForKey:@"subject"] objectAtIndex:1];
    [posterDataArray addObject:ladyModel];
    [posterDataArray addObject:childModel];

    NSLog(@"%@", posterDataArray);
    step1 = YES;
    if (step1 && step2) {
        
        
        [self.myCollectionView reloadData];

    }
    
    
}
- (void)fetchedPromoteData:(NSData *)data{
    NSError *error;
    // NSLog(@"data = %@", data);
    if (data == nil) {
        [frontView removeFromSuperview];
        return;
    }
    NSDictionary * promoteDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //  NSLog(@"promote data = %@", promoteDic);
    NSArray *ladyArray = [promoteDic objectForKey:@"female_list"];
    ladyListNumber = ladyArray.count;
    NSLog(@"%ld", (long)ladyArray.count);
    for (NSDictionary *ladyInfo in ladyArray) {
        PromoteModel *model = [PromoteModel new];
        model.picPath = [ladyInfo objectForKey:@"pic_path"];
        model.name = [ladyInfo objectForKey:@"name"];
        model.Url = [ladyInfo objectForKey:@"url"];
        model.agentPrice = [ladyInfo objectForKey:@"agent_price"];
        model.stdSalePrice = [ladyInfo objectForKey:@"std_sale_price"];
        model.outerID = [ladyInfo objectForKey:@"outer_id"];
        model.isNewgood = [ladyInfo objectForKey:@"is_newgood"];
        model.isSaleopen = [ladyInfo objectForKey:@"is_saleopen"];
        model.isSaleout = [ladyInfo objectForKey:@"is_saleout"];
        model.ID = [ladyInfo objectForKey:@"id"];
        model.category = [ladyInfo objectForKey:@"category"];
        model.remainNum = [ladyInfo objectForKey:@"remain_num"];
        model.saleTime = [ladyInfo objectForKey:@"sale_time"];
        model.wareBy = [ladyInfo objectForKey:@"ware_by"];
        if ([[ladyInfo objectForKey:@"product_model"] class] == [NSNull class]) {
            NSLog(@"没有集合页");
            model.productModel = nil;
        } else{
            model.productModel = [ladyInfo objectForKey:@"product_model"];
            NSLog(@"*************");
        }
        
        
        [ladyDataArray addObject:model];
        
    }
    NSLog(@"ladyDataArray = %@", ladyDataArray);
    
    
    
    
    
    NSArray *childArray = [promoteDic objectForKey:@"child_list"];
     childListNumber = childArray.count;
    NSLog(@"%ld", (long)childArray.count);
    
    for (NSDictionary *childInfo in childArray) {
        PromoteModel *model = [PromoteModel new];
        model.picPath = [childInfo objectForKey:@"pic_path"];
        model.name = [childInfo objectForKey:@"name"];
        model.Url = [childInfo objectForKey:@"url"];
        model.agentPrice = [childInfo objectForKey:@"agent_price"];
        model.stdSalePrice = [childInfo objectForKey:@"std_sale_price"];
        model.outerID = [childInfo objectForKey:@"outer_id"];
        model.isNewgood = [childInfo objectForKey:@"is_newgood"];
        model.isSaleopen = [childInfo objectForKey:@"is_saleopen"];
        model.isSaleout = [childInfo objectForKey:@"is_saleout"];
        model.ID = [childInfo objectForKey:@"id"];
        model.category = [childInfo objectForKey:@"category"];
        model.remainNum = [childInfo objectForKey:@"remain_num"];
        model.saleTime = [childInfo objectForKey:@"sale_time"];
        model.wareBy = [childInfo objectForKey:@"ware_by"];
        if ([[childInfo objectForKey:@"product_model"] class] == [NSNull class]) {
            NSLog(@"没有集合页");
            model.productModel = nil;
        } else{
            model.productModel = [childInfo objectForKey:@"product_model"];
            NSLog(@"*************");
        }
        
        
        [childDataArray addObject:model];
        
    }
    NSLog(@"childDataArray = %@", childDataArray);
    
    step2 = YES;
    
    if (step1 && step2) {
        
        [self.myCollectionView reloadData];

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


#pragma mark --UICollectionViewDelegate--

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    } else if (section == 1){
        return childDataArray.count;
        
       // return childDataArray.count;
    } else if (section == 2){
        return ladyDataArray.count;
        
        
        //return ladyDataArray.count;
    }
    return 0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, SCREENWIDTH*253/618+24);
        
    }
    return CGSizeMake((SCREENWIDTH-4)/2, (SCREENWIDTH-4)/2 + 40);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREENWIDTH, 30);
        
    } else if (section == 1){
        return CGSizeMake(SCREENWIDTH, 40);
    }
    else if (section == 2){
        return CGSizeMake(SCREENWIDTH, 40);
    }
    return CGSizeZero;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       
      
            PosterCollectionCell *cell = (PosterCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"posterView" forIndexPath:indexPath];
        
        if (posterDataArray.count != 0) {
            
        
            PosterModel *model = [posterDataArray objectAtIndex:indexPath.row];
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
            cell.titleLabel.text = model.firstName;
            cell.subjectLabel.text = model.secondName;
        }
            return cell;
       
       
        
    }
    else if (indexPath.section == 1)
    {
        PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
        PromoteModel *model = [childDataArray objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.agentPrice];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
        cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.stdSalePrice];
        BOOL issaleOut = [model.isSaleout boolValue];
        if (issaleOut) {
            
        }else{
            cell.backView.hidden = YES;
            cell.frontView.hidden = YES;
        }
        
        return cell;
        
        
    }
    
    else{
    
        PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
        
        PromoteModel *model = [ladyDataArray objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.agentPrice];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
        cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.stdSalePrice];
        BOOL issaleOut = [model.isSaleout boolValue];
        if (issaleOut) {
            
        }else{
            cell.backView.hidden = YES;
            cell.frontView.hidden = YES;
        }
        return cell;
        
    
    }
   
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;
    if (indexPath.section == 0) {
           headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1View" forIndexPath:indexPath];
        return headerView;
    } else if (indexPath.section == 1){
        
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
        headerView.nameLabel.text = @"潮童专区";
        headerView.headView.layer.cornerRadius = 4;
        headerView.timeLabel.text = myTimeLabelString;
        childTimeLabel = headerView.timeLabel;
        
        return headerView;
    } else if (indexPath.section == 2){
        Head2View * headerView = (Head2View *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
        headerView.nameLabel.text = @"时尚女装";
        headerView.headView.layer.cornerRadius = 4;
        headerView.timeLabel.text = myTimeLabelString;
        childTimeLabel = headerView.timeLabel;

        return headerView;
    }
    
    
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
   
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld : %ld",(long)indexPath.section, (long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WomanViewController *womanVC = [[WomanViewController alloc] initWithNibName:@"WomanViewController" bundle:nil];
          //  womanVC.
           // womanVC.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
            womanVC.isRoot = YES;
            [self.navigationController pushViewController:womanVC animated:YES];
            
        } else{
            ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:@"ChildViewController" bundle:nil];
            childVC.isRoot = YES;
            [self.navigationController pushViewController:childVC animated:YES];
            
        }
        
    } else if (indexPath.section == 1){
        
    } else if (indexPath.section == 2){
        
    }
}



@end
