//
//  JifenViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/8.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "JifenViewController.h"
#import "MMClass.h"
#import "JiFenCollectionCell.h"
#import "JifenReusableView.h"
#import "JiFenModel.h"
#import "JMEmptyView.h"


@interface JifenViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSNumber *integralValue;

@property (nonatomic, strong) JMEmptyView *empty;

@end

@implementation JifenViewController{
    UIView *emptyView;
}

static NSString * const reuseIdentifier = @"jifenCell";
static NSString * const headViewIdentifier = @"headViewIdentifier";
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JiFen"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"Jifen"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    [self.collectionView registerClass:[JifenReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewIdentifier];
    [self.collectionView registerClass:[JiFenCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.title = @"我的积分";
    [self createNavigationBarWithTitle:@"我的积分" selecotr:@selector(btnClicked:)];
    
    self.collectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [self emptyView];
    [self downlaodData];
   // [self.view addSubview:[[UIView alloc] init]];
   self.integralValue =  [self numberOfJifen];
    NSLog(@"self.integralValue = %@", self.integralValue);
    
    
    // Do any additional setup after loading the view.
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, SCREENHEIGHT - 220) Title:@"您暂时没有积分记录哦~" DescTitle:@"快去下单赚取积分吧～" BackImage:@"emptyJifenIcon" InfoStr:@"快去抢购"];
    [self.view addSubview:self.empty];
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    self.empty.hidden = YES;
}


- (NSNumber *)numberOfJifen{
    
    //  http://192.168.1.31:9000/rest/v1/integral
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/integral", Root_URL];
    NSLog(@"urlStr = %@", urlStr);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    if (data == nil) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    if ([[dic objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"无积分");
        self.empty.hidden = NO;
        return [NSNumber numberWithInt:0];
    }
    
    NSDictionary *result = [[dic objectForKey:@"results"] objectAtIndex:0];
    NSNumber *number = [result objectForKey:@"integral_value"];
    NSLog(@"integral_value = %@", number);
    
    return number;
    
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//   http://192.168.1.79:8000/rest/v1/integrallog

- (void)downlaodData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kIntegrallogURL]];
        [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (JiFenModel *)fillModelWithData:(NSDictionary *)dic{
    JiFenModel *model = [JiFenModel new];
    model.ID = [dic objectForKey:@"id"];
    model.integral_user = [dic objectForKey:@"integral_user"];
    model.mobile = [dic objectForKey:@"mobile"];
    model.log_status = [dic objectForKey:@"log_status"];
    model.log_type = [dic objectForKey:@"log_type"];
    model.log_value = [dic objectForKey:@"log_value"];
    model.in_out = [dic objectForKey:@"in_out"];
    model.created = [dic objectForKey:@"created"];
    model.modified = [dic objectForKey:@"modified"];
    
    NSDictionary *order = [dic objectForKey:@"order_info"];
    
    model.order = order;
    
    return model;

}

- (void)fetchedWaipayData:(NSData *)data{
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"您的积分列表为空");
        self.empty.hidden = NO;
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    
    NSLog(@"array = %@", array);
    for (NSDictionary *dic in array) {
       // if ([[dic objectForKey:@"log_status"] integerValue] == 0) {
        JiFenModel *model = [self fillModelWithData:dic];
        
            [self.dataArray addObject:model];
       
       // }
        
       
    }
    

    NSLog(@"array = %@", self.dataArray);
    
    [self.collectionView reloadData];
    
    
    
         NSString * urlString = [json objectForKey:@"next"];
    NSLog(@"urlString = %@", urlString);
    if ([urlString isKindOfClass:[NSNull class]] || urlString == nil || [urlString isEqual:@""]) {
        NSLog(@"下一页为空");
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
            
            
        });
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

//    return 0;
    if (self.dataArray.count == 0) {
        self.empty.hidden = NO;
    }
    else{
        self.empty.hidden = YES;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JiFenCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
   

    [cell fillCellWithData:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    JifenReusableView * headerView = (JifenReusableView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewIdentifier forIndexPath:indexPath];
    headerView.jifenValueLabel.text = [NSString stringWithFormat:@"%@", self.integralValue];
    headerView.jifenValueLabel.textColor = [UIColor buttonEmptyBorderColor];
    headerView.jifenValueLabel.font = [UIFont systemFontOfSize:40];
    return headerView;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 100);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREENWIDTH, 120);
    
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
