//
//  CollectionViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CollectionViewController.h"
#import "ClothesCollectionCell.h"
#import "PeopleModel.h"
#import "MMClass.h"
#import "DetailViewController.h"

@interface CollectionViewController ()



@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"剩余2天1小时18分";
    

  
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 18, 31);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhui2.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 29, 33);
    [rightButton setBackgroundImage:LOADIMAGE(@"icon-gerenzhongxin.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    // Do any additional setup after loading the view from its nib.
    //self.collectionArray = [[NSArray alloc] init];
    [self.collectionView registerClass:[ClothesCollectionCell class] forCellWithReuseIdentifier:@"SimpleCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 30)/2, (SCREENWIDTH - 30)/2 + 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 10, 10);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
}

- (void)login:(UIButton *)button{
    NSLog(@"登录");
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SimpleCell";
    ClothesCollectionCell *cell = (ClothesCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell fillData:[self.collectionArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionModel *model = (CollectionModel *)[self.collectionArray objectAtIndex:indexPath.row];
    NSString *urlstring = [NSString stringWithFormat:@"%@/details", model.urlStirng];
    MMLOG(urlstring);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedDetailsData:) withObject:data waitUntilDone:YES];
        
    });
}

- (void)fetchedDetailsData:(NSData *)responseData{
    NSError *error = nil;
    NSDictionary *detailsInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    // MMLOG(detailsInfo);
    //商品详情 json 数据解析
    DetailsModel *model = [[DetailsModel alloc] init];
    model.name = [detailsInfo objectForKey:@"name"];
    model.productID = [detailsInfo objectForKey:@"outer_id"];
    model.isSaleOpen = [[detailsInfo objectForKey:@"is_saleopen"] boolValue];
    model.isSaleOut = [[detailsInfo objectForKey:@"is_saleout"] boolValue];
    model.isNewGood = [[detailsInfo objectForKey:@"is_newgood"] boolValue];
    model.remainNumber = [[detailsInfo objectForKey:@"remain_num"] integerValue];
    model.price = [NSString stringWithFormat:@"￥%@",[detailsInfo objectForKey:@"agent_price"]];
    model.oldPrice= [NSString stringWithFormat:@"￥%@", [detailsInfo objectForKey:@"std_sale_price"]];
    NSArray *goodsArray = [detailsInfo objectForKey:@"normal_skus"];
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in goodsArray) {
        NSString *size = [dic objectForKey:@"name"];
        [arrayData addObject:size];
    }
    model.sizeArray = arrayData;
    MMLOG(model.sizeArray);
    NSDictionary *dic2 = [detailsInfo objectForKey:@"details"];
    model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
    model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
    
    DetailViewController *detailsVC = [[DetailViewController alloc] init];
    detailsVC.detailsModel = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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
