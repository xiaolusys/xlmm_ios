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
#import "MJRefresh.h"
#import "NSString+URL.h"
#import "SVProgressHUD.h"
#import "LoadingAnimation.h"
#import "MMLoadingAnimation.h"
#import "UIViewController+NavigationBar.h"



@interface MMCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, assign)NSInteger count;
@end

@implementation MMCollectionController{
    NSTimer *theTimer;
    UILabel *titleLabel;
    NSString *offSheltTime;
    CGFloat ratio;
    BOOL _isFirst;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelID:(NSString *)modelID isChild:(BOOL)isChild{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@.json", Root_URL, modelID];
        self.urlString = string;
        _childClothing = isChild;
        [self downLoadWithURLString:string andSelector:@selector(fetchedCollectionData:)];

    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
   
}

- (void)dealloc{
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品集合";
    //self.view.backgroundColor = [UIColor redColor];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    ratio = 0.0;
    _isFirst = YES;
    [self createCollectionView];
    [self createInfo];
}

- (void)createInfo{
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image.png"]];
    imageView.frame = CGRectMake(-4, 14, 16, 16);
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
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 8, 5);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:@"simpleCell"];
    [self.view addSubview:[[UIView alloc] init]];
    self.collectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    [self.view addSubview:self.collectionView];
}

- (void)fetchedCollectionData:(NSData *)data{
    if (data == nil) {
      
    }
    NSError *error = nil;
    NSArray *collections = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   // NSLog(@"collections = %@", collections);
    if (error != nil) {
        NSLog(@"error = %@", error);
    }
    for (NSDictionary *dic in collections) {
    CollectionModel *model = [[CollectionModel alloc] initWithDiction:dic];
     [self.dataArray addObject:model];
    }
    
    CollectionModel *tempModel = (CollectionModel *)[self.dataArray objectAtIndex:0];
    offSheltTime = tempModel.offShelfTime;
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [self timerFireMethod:theTimer];
    
    [self.collectionView reloadData];
    
    //[self performSelector:@selector(reload) withObject:nil afterDelay:0.3];
    
    
    
}

- (void)reload{
    
    if (ratio > 1) {
        
    } else {
        [self.collectionView reloadData];
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
     CollectionModel *model = [self.dataArray objectAtIndex:0];
    NSString *saleTime = model.saleTime;
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
  //NSLog(@"comps = %@", comps);
    
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
    int nextday = day + 1;
    

    NSDate *todate;
    if ([offSheltTime class] == [NSNull class]) {
       // NSLog(@"默认下架时间");
        NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
        [endTime setYear:year];
        [endTime setMonth:month];
        [endTime setDay:nextday];
        [endTime setHour:14];
        [endTime setMinute:0];
        [endTime setSecond:0];
        
        todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
        
        //用来得到具体的时差
        
        
    } else{
     //   NSLog(@"特定下架时间");
        NSMutableString *string = [NSMutableString stringWithString:offSheltTime];
        NSRange range = [string rangeOfString:@"T"];
        [string replaceCharactersInRange:range withString:@" "];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        todate = [dateformatter dateFromString:string];
    }

    
    NSDate *date = [NSDate date];
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ([d hour] < 0 || [d minute] < 0) {
        titleLabel.text = @"已下架";
     //   NSLog(@"已下架");
    } else{
        NSString *string;
        if ((long)[d day] == 0) {
            string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
        }
        else{
            string = [NSString stringWithFormat:@"剩余%02ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
            
        }
      //  NSString * string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
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

//    CollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    
//    NSString *string = [[model.picPath URLEncodedString] imageMoreCompression];
//   // NSLog(@"imageUrl = %@", string);
//    UIImage *image = [UIImage imagewithURLString:string];
//    if (image != nil) {
//     //   NSLog(@"image = %@", image);
//        return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *image.size.height/image.size.width+ 60);
//    } else {
//        return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *8/6+ 60);
//
//    }
    
    
//    
//    if (ratio == 0) {
//        return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *8/6+ 60);
//        
//    } else {
//        return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *ratio+ 60);
//    }
//    
    
return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *8/6+ 60);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    
    
    CollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *string = model.picPath;
    
    NSMutableString *newString = [NSMutableString stringWithString:string];
   
    if (![model.watermark_op isEqualToString:@""]) {
        [newString appendString:[NSString stringWithFormat:@"?%@|", model.watermark_op]];
        
    } else{
        [newString appendString:@"?"];
    }
//    NSLog(@"%@",[[newString imageCompression] URLEncodedString]);
//    
//    NSLog(@"newString = %@", newString);
    cell.imageView.alpha = 0.0f;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[newString imageCompression] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            cell.imageView.alpha = 1.0;
        }];
        
        
    }] ;
    cell.nameLabel.text = model.name;

    
    if ([model.agentPrice integerValue] != [model.agentPrice floatValue]) {
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.agentPrice floatValue]];
    } else {
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.agentPrice];
    }
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.stdSalePrice floatValue]];
    cell.backView.layer.cornerRadius = 30;
    
    if ([model.isSaleopen boolValue]) {
        
        if ([model.isSaleout boolValue]) {
            cell.backView.hidden = NO;
        } else{
            cell.backView.hidden = YES;
        }
    } else{
        cell.backView.hidden = NO;
        if([model.isNewgood boolValue]){
            UILabel *label = [cell.backView viewWithTag:100];
            label.text = @"即将开售";
        }

    }
    return cell;

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //   http://m.xiaolu.so/rest/v1/products/15809
    
    CollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    
    MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil modelID:model.ID isChild:self.isChildClothing];
  
    [self.navigationController pushViewController:detailsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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
