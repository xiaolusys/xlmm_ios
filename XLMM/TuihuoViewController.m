//
//  TuihuoViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TuihuoViewController.h"
#import "MMClass.h"
#import "TuihuoModel.h"
#import "TuihuoCollectionCell.h"
#import "OrderModel.h"
#import "TuihuoXiangqingViewController.h"

@interface TuihuoViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation TuihuoViewController{
    NSInteger downloadCount;
    NSInteger count;
}

static NSString * const reuseIdentifier = @"tuihuoCell";




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    downloadCount = 0;
    [self downlaodData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"我的退货(款)";
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TuihuoCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self createInfo];

}

- (void)downlaodData{
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"url = %@", kQuanbuDingdan_URL);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kQuanbuDingdan_URL]];
        [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (void)fetchedWaipayData:(NSData *)data{
    NSLog(@"11");
    
    if (data == nil) {
        return;
    }
    [self.dataArray removeAllObjects];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"您的积分列表为空");
        return;
    }
    
    //NSLog(@"count = %@", [json objectForKey:@"count"]);
    
        NSArray *array = [json objectForKey:@"results"];
    count = array.count;
    
        NSLog(@"array = %@", array);
    
    for (int i = 0; i<count; i++) {
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          //  NSLog(@"url = %@", kQuanbuDingdan_URL);
            
            
            NSString * string = [[array objectAtIndex:i] objectForKey:@"orders"];
            
            
            NSLog(@"url = %@", string);
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
            [self performSelectorOnMainThread:@selector(fetchedtradeData:) withObject:data waitUntilDone:YES];
            
            
        });
        
        
        
    }
    
    

}

- (void)fetchedtradeData:(NSData *)data{
    
    if (data == nil) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
   // NSLog(@"json = %@", json);
    
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *dic in array) {
        
        if ([[dic objectForKey:@"refund_status"] integerValue] != 0) {
            NSLog(@"加入退货列表");
            OrderModel *model = [OrderModel new];
            model.ID = [dic objectForKey:@"id"];
             model.oID = [dic objectForKey:@"oid"];
             model.item_id = [dic objectForKey:@"item_id"];
             model.title = [dic objectForKey:@"title"];
             model.sku_id = [dic objectForKey:@"sku_id"];
             model.num = [dic objectForKey:@"num"];
             model.outer_id = [dic objectForKey:@"outer_id"];
             model.total_fee = [dic objectForKey:@"total_fee"];
             model.payment = [dic objectForKey:@"payment"];
             model.sku_name = [dic objectForKey:@"sku_name"];
             model.pic_path = [dic objectForKey:@"pic_path"];
             model.status = [dic objectForKey:@"status"];
             model.status_display = [dic objectForKey:@"status_display"];
             model.refund_status = [dic objectForKey:@"refund_status"];
             model.refund_status_display = [dic objectForKey:@"refund_status_display"];
//             model.ID = [dic objectForKey:@""];
//             model.ID = [dic objectForKey:@""];
            [self.dataArray addObject:model];
            
        }
       
    }
    NSLog(@"data = %@", self.dataArray);

    downloadCount ++;
    NSLog(@"%ld,   %ld", (long)downloadCount, (long)count);
    if (downloadCount == count) {
        [self.collectionView reloadData];

        NSLog(@"刷新数据");
    }
    
}


- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"我的退货(款)";
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
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TuihuoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
   // TuihuoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    //cell.myImageView.image = [UIImage imagewithURLString:model.]
    
    OrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.myImageView.image = [UIImage imagewithURLString:model.pic_path];
    cell.infoLabel.text = model.refund_status_display;
    cell.bianhao.text = [NSString stringWithFormat:@"%@", model.oID];
    cell.zhuangtai.text = model.status_display;
    cell.jine.text = [NSString stringWithFormat:@"¥%@", model.payment];
    
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0, 10, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 100);
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSInteger status = [model.refund_status integerValue];
    NSInteger orderid = [model.ID integerValue];
    
    NSLog(@"status = %ld", (long)status);
    
    TuihuoXiangqingViewController *xiangqingVC = [[TuihuoXiangqingViewController alloc] init];
    xiangqingVC.status = status;
    xiangqingVC.orderID = orderid;
    NSLog(@"status = %ld & id = %ld", (long)xiangqingVC.status, (long)xiangqingVC.orderID);
    
    [self.navigationController pushViewController:xiangqingVC animated:YES];
    


}

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
