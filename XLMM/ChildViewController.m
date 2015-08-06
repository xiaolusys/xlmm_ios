//
//  ChildViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ChildViewController.h"
#import "LogInViewController.h"
#import "PeopleCollectionCell.h"
#import "PeopleModel.h"
#import "DetailViewController.h"
#import "PurchaseViewController.h"

#import "MMClass.h"

#define ksampleCell @"sampleCell"

@interface ChildViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = @"潮童专区";
    navLabel.textColor = [UIColor orangeColor];
    navLabel.font = [UIFont boldSystemFontOfSize:24];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setBackgroundImage:LOADIMAGE(@"goodsthumb.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
        
  [self.childCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksampleCell];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 30)/2, (SCREENWIDTH - 30)/2 + 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 10, 10);
    [self.childCollectionView setCollectionViewLayout:flowLayout];
    
    [self downloadData];
    
}

- (void)downloadData{
    
    dispatch_sync(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCHILD_LIST_URL]];
        
        
        if (data == nil) {
            return ;
        }
        
        [self performSelectorOnMainThread:@selector(mmParseData:) withObject:data waitUntilDone:YES];
    });
}

- (void)mmParseData:(NSData *)responseData{
    NSError *error;
    
    _dataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

    NSArray *array = [json objectForKey:@"results"];
    
      for (NSDictionary *dic in array) {
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [dic objectForKey:@"pic_path"];
        model.name = [dic objectForKey:@"name"];
        model.price = [dic objectForKey:@"agent_price"];
        model.oldPrice = [dic objectForKey:@"std_sale_price"];
          
          NSDictionary *dic2 = [dic objectForKey:@"product_model"];
          if ([dic2 class] == [NSNull class]) {
              model.productModel = nil;
          } else{
              model.productModel = dic2;
              model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
              model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
          }
          
          
          
          
        [_dataArray addObject:model];
    }
}

#pragma mark  -----CollectionViewDelete----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksampleCell forIndexPath:indexPath];
   [cell fillData:[_dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_dataArray.count == 0) {
        return;
    }
    PeopleModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (model.productModel == nil) {
        NSLog(@"没有集合页面");
        
        PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] init];
        [self.navigationController pushViewController:purchaseVC animated:YES];
    } else{
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.headImageUrlArray = model.headImageURLArray;
        detailVC.contentImageUrlArray = model.contentImageURLArray;
        [self.navigationController pushViewController:detailVC animated:YES];

    }
   
    
    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark ----btnClicked:----

- (void)login:(UIButton *)button{
    NSLog(@"登录");
    LogInViewController *loginVC = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        NSLog(@"推荐排序");
    } else if (sender.tag == 2){
        NSLog(@"价格排序");
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

@end
