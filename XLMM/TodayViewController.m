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
#import "PosterCell.h"
//#import "GoodsCell.h"
#import "PeopleCollectionCell.h"
#import "PromoteModel.h"


@interface TodayViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    
    UIView *ladyPoster;
    UIView *childPoster;
    
    NSMutableArray *childDataArray;
    NSMutableArray *ladyDataArray;
    UIView *frontView;
    NSInteger childListNumber;
    NSInteger ladyListNumber;
    UILabel *childTimeLabel;
    UILabel *ladyTimeLabel;
    NSDictionary *jsonDic;
    
    
    
}

@property (nonatomic, retain) UICollectionView *myCollectionView;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    childDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    ladyDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:@"simpleCell"];
 //   [self.myCollectionView registerClass:[PosterCell class] forCellWithReuseIdentifier:@"postersCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"PosterCell" bundle:nil] forCellWithReuseIdentifier:@"mmpostersCell"];
    
    //[self.myCollectionView registerClass:[PosterCell class] forCellWithReuseIdentifier:@"mmpostersCell"];
    
    [self.myCollectionView registerClass:[Head1View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1View"];
    [self.myCollectionView registerClass:[Head2View class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View"];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.myCollectionView];
    
    
    [self downloadData];
    
    
    
}

#if 1

- (void)downloadData{
    [self downloadPosterData];
    [self downloadPromoteData];
    
}

- (void)downloadPromoteData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kTODAY_PROMOTE_URL]];
        [self performSelectorOnMainThread:@selector(fetchedPromoteData:)withObject:data waitUntilDone:YES];
        
    });
}


#pragma mark --今题推荐数据解析
- (void)fetchedPromoteData:(NSData *)data{
    NSError *error;
    // NSLog(@"data = %@", data);
    if (data == nil) {
        [frontView removeFromSuperview];
        [self createPosterView];
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
    
    
    
    
    [self createPromoteView];
    
}

- (void)createPromoteView{
    
    
 
    
    [self.myCollectionView reloadData];
    [self createChildHeadView];
    [self createLadyHeadView];
    [frontView removeFromSuperview];
    
}
#pragma mark --设置标题
- (void)createChildHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor colorWithRed:84/255.0 green:199/255.0 blue:189/255.0 alpha:1];
    UIView *frontView1 = [[UIView alloc] initWithFrame:CGRectMake(8, 18, 16, 16)];
    frontView1.layer.cornerRadius = 4;
    frontView1.backgroundColor = [UIColor whiteColor];
    [view addSubview:frontView1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"潮童专区";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    [view addSubview:label];
    UIImageView *timeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-shengyu2.png"]];
    timeview.frame = CGRectMake(SCREENWIDTH - 170, 14, 24, 24);
    [view addSubview:timeview];
    childTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH -140, 14, 140, 24)];
    childTimeLabel.text = @"敬请期待";
    childTimeLabel.textAlignment = NSTextAlignmentLeft;
    childTimeLabel.textColor = [UIColor whiteColor];
    childTimeLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:childTimeLabel];
    
    
    [self.myCollectionView addSubview:view];
    
    
    
}
- (void)createLadyHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40 + ((SCREENWIDTH - 10)/2+50)*childListNumber/2, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor colorWithRed:84/255.0 green:199/255.0 blue:189/255.0 alpha:1];
    UIView *frontView1 = [[UIView alloc] initWithFrame:CGRectMake(8, 18, 16, 16)];
    frontView1.layer.cornerRadius = 4;
    frontView1.backgroundColor = [UIColor whiteColor];
    [view addSubview:frontView1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"时尚女装";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    [view addSubview:label];
    UIImageView *timeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-shengyu2.png"]];
    timeview.frame = CGRectMake(SCREENWIDTH - 170, 14, 24, 24);
    [view addSubview:timeview];
    
    ladyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH -140, 14, 140, 24)];
    ladyTimeLabel.text = @"敬请期待";
    ladyTimeLabel.textAlignment = NSTextAlignmentLeft;
    ladyTimeLabel.textColor = [UIColor whiteColor];
    ladyTimeLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:ladyTimeLabel];
    
    [self.myCollectionView addSubview:view];
}

- (void)downloadPosterData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kTODAY_POSTERS_URL]];
        [self performSelectorOnMainThread:@selector(fetchedPosterData:)withObject:data waitUntilDone:YES];
        
    });
    
    
}

- (void)fetchedPosterData:(NSData *)data{
    NSError *error;
    NSLog(@"data = %@", data);
    if (data == nil) {
        [frontView removeFromSuperview];
        [self createPosterView];
        return;
    }
     jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"poster data : %@", jsonDic);
    
    [self createPosterView];
    [self fillPosterDate];
    
}

- (void)fillPosterDate{
    
    
    NSArray *ladyPosterArray = [jsonDic objectForKey:@"wem_posters"];
    NSDictionary *ladyDic = [ladyPosterArray objectAtIndex:0];
    
    UIImageView * ladyImage = (UIImageView *)[ladyPoster viewWithTag:10];
    [ladyImage sd_setImageWithURL:[NSURL URLWithString:[ladyDic objectForKey:@"pic_link"]]];
    //ladyImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ladyDic objectForKey:@"pic_link"]]]];
    UILabel *ladyLabel1 = (UILabel *)[ladyPoster viewWithTag:20];
    ladyLabel1.text = [[ladyDic objectForKey:@"subject"] objectAtIndex:0];
    UILabel *ladyLabel2 = (UILabel *)[ladyPoster viewWithTag:30];
    ladyLabel2.text = [[ladyDic objectForKey:@"subject"]objectAtIndex:1];
    UIButton *ladyButton = (UIButton *)[ladyPoster viewWithTag:40];
    
    [ladyButton addTarget:self action:@selector(ladyPosterClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *childPosterArray = [jsonDic objectForKey:@"chd_posters"];
    NSDictionary *childDic = [childPosterArray objectAtIndex:0];
    
    UIImageView * childImage = (UIImageView *)[childPoster viewWithTag:10];
    
    [childImage sd_setImageWithURL:[NSURL URLWithString:[childDic objectForKey:@"pic_link"]]];
    //childImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[childDic objectForKey:@"pic_link"]]]];
    UILabel *childLabel1 = (UILabel *)[childPoster viewWithTag:20];
    childLabel1.text = [[childDic objectForKey:@"subject"] objectAtIndex:0];
    UILabel *childLabel2 = (UILabel *)[childPoster viewWithTag:30];
    childLabel2.text = [[childDic objectForKey:@"subject"]objectAtIndex:1];
    UIButton *childButton = (UIButton *)[childPoster viewWithTag:40];
    
    [childButton addTarget:self action:@selector(childPosterClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)ladyPosterClicked:(UIButton *)button{
    NSLog(@"ladyPoster");
}

- (void)childPosterClicked:(UIButton *)button{
    NSLog(@"childPoster");
}



- (void)createPosterView{
  //  CGFloat margin = 36;
    

    
}

#endif

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
        return 10;
        
       // return childDataArray.count;
    } else if (section == 2){
        return 10;
        
        
        //return ladyDataArray.count;
    }
    return 0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, 180);
        
    }
    return CGSizeMake((SCREENWIDTH-5)/2, 240);
    
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
        return CGSizeMake(SCREENWIDTH, 50);
    }
    else if (section == 2){
        return CGSizeMake(SCREENWIDTH, 50);
    }
    return CGSizeZero;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        PosterCell *cell = (PosterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"mmpostersCell" forIndexPath:indexPath];
        return cell;
    }
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView;
    if (indexPath.section == 0) {
           headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1View" forIndexPath:indexPath];
        return headerView;
    }
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2View" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"");
    
}



@end
