//
//  EmptyCartViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "EmptyCartViewController.h"
#import "MMClass.h"
#import "CartModel.h"

@interface EmptyCartViewController (){
    NSMutableArray *dataArray;
}

@end

@implementation EmptyCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    item.title = @"";
    //  您的购物车空空如也，以下宝贝可重新加入哦~ ~ ~
    self.navigationItem.leftBarButtonItem = item;
    [self downloadData];
    
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
   
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.myCollectionView];
}
- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_History_URL]];
        NSLog(@"%@", kCart_History_URL);
        [self performSelectorOnMainThread:@selector(fetchedHistoryData:)withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedHistoryData:(NSData *)data{
    NSLog(@"data = %@", data);
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (NSDictionary *dic in array) {
        CartModel *model = [CartModel new];
        model.status = [dic objectForKey:@"status"];
        model.sku_id = [dic objectForKey:@"sku_id"];
        model.title = [dic objectForKey:@"title"];
        model.price = [dic objectForKey:@"price"];
        model.buyer_nick = [dic objectForKey:@"buyer_nick"];
        model.num = [dic objectForKey:@"num"];
        model.remain_time = [dic objectForKey:@"remain_time"];
        model.std_sale_price = [dic objectForKey:@"std_sale_price"];
        model.total_fee = [dic objectForKey:@"total_fee"];
        model.item_id = [dic objectForKey:@"item_id"];
        model.pic_path = [dic objectForKey:@"pic_path"];
        model.sku_name = [dic objectForKey:@"sku_name"];
        model.is_sale_out = [dic objectForKey:@"is_sale_out"];
        model.ID = [dic objectForKey:@"id"];
        model.buyer_id = [dic objectForKey:@"buyer_id"];
        [dataArray addObject:model];
    }
    NSLog(@"dataArray = %@", dataArray);
    [self.myCollectionView reloadData];
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
   
    return nil;
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

- (IBAction)gotoHomePage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
