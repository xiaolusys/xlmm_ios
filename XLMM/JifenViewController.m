//
//  JifenViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/8.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "JifenViewController.h"
#import "MMClass.h"
#import "JiFenModel.m"

@interface JifenViewController ()

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JifenViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.title = @"我的积分";
    
    
    [self downlaodData];
    [self.view addSubview:[[UIView alloc] init]];
    
    // Do any additional setup after loading the view.
}

//   http://192.168.1.79:8000/rest/v1/integrallog

- (void)downlaodData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kIntegrallogURL]];
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
        NSLog(@"您的积分列表为空");
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"array = %@", array);
    for (NSDictionary *dic in array) {
        
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
        
        NSString *order = [dic objectForKey:@"order"];
        NSData *data = [order dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *orderDic = [array objectAtIndex:0];
        NSLog(@"orders = %@", orderDic);
        model.order = orderDic;
        
        [mutableArray addObject:model];
    }
    self.dataArray = [[NSArray alloc] initWithArray:mutableArray];
    NSLog(@"array = %@", self.dataArray);

//    array = (
//             {
//                 "order_id" = 149;
//                 "order_status" = 2;
//                 "pic_link" = "http://i00.c.aliimg.com/img/ibank/2014/153/943/1449349351_72023587.310x310.jpg";
//                 "trade_id" = 234;
//             }
//             )
    
 
    
    
}
- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"我的积分";
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

    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
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
