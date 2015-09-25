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

@interface MMCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UICollectionView *collectionView;


@end

@implementation MMCollectionController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品集合";
    NSLog(@"%@", self.urlString);
    //self.view.backgroundColor = [UIColor redColor];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self downloadData];
    
    [self createCollectionView];
    [self createInfo];
}

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"商品集合";
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
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:@"simpleCell"];
    [self.view addSubview:[[UIView alloc] init]];
   
   // self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.collectionView];
}

- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlString]];
        [self performSelectorOnMainThread:@selector(fetchedCollectionData:)withObject:data waitUntilDone:YES];
        
    });
    
}
- (void)fetchedCollectionData:(NSData *)data{
    if (data == nil) {
        NSLog(@"urlstring = %@", _urlString);
        NSLog(@"集合页面数据下载失败");
    }
    NSError *error;
    [self.dataArray removeAllObjects];
    NSArray *collections = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"collections = %@", collections);
    for (NSDictionary *dic in collections) {
        CollectionModel *model = [CollectionModel new];
        
        model.agentPrice = [dic objectForKey:@"agent_price"];
        model.category = [dic objectForKey:@"category"];
        model.ID = [dic objectForKey:@"id"];
        model.isNewgood = [dic objectForKey:@"is_newgood"];
        model.isSaleopen = [dic objectForKey:@"is_saleopen"];
        model.isSaleout = [dic objectForKey:@"is_saleout"];
        model.memo = [dic objectForKey:@"memo"];
        model.name = [dic objectForKey:@"name"];
        model.outerId = [dic objectForKey:@"outer_id"];
        model.picPath = [dic objectForKey:@"pic_path"];
        model.remainNum = [dic objectForKey:@"remain_num"];
        model.saleTime = [dic objectForKey:@"sale_time"];
        model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
        model.url = [dic objectForKey:@"url"];
        model.wareBy = [dic objectForKey:@"ware_by"];
        model.productModel = [dic objectForKey:@"product_model"];
        
        [self.dataArray addObject:model];
        
    }
    NSLog(@"dataArray = %@", _dataArray);
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((SCREENWIDTH-4)/2, (SCREENWIDTH-4)/2 + 40);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    [cell fillDataWithCollectionModel:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld : %ld",(long)indexPath.section, (long)indexPath.row);
    
    
    //   http://m.xiaolu.so/rest/v1/products/15809
    
    CollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *ID = model.ID;
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details", Root_URL, ID];
    NSLog(@"urlString = %@", string);
    MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
    detailsVC.urlString = string;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    
    //NSString *urlString = [];

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
