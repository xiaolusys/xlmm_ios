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
    // Do any additional setup after loading the view from its nib.
    //self.collectionArray = [[NSArray alloc] init];
    [self.collectionView registerClass:[ClothesCollectionCell class] forCellWithReuseIdentifier:@"SimpleCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 30)/2, (SCREENWIDTH - 30)/2 + 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 10, 10);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
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

    
    MMLOG(self.collectionArray);
    CollectionModel *model = (CollectionModel *)[self.collectionArray objectAtIndex:indexPath.row];
    MMLOG(model);
    MMLOG(model.headImageURLArray);
    MMLOG(model.contentImageURLArray);
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    detailVC.headImageUrlArray = model.headImageURLArray;
    detailVC.contentImageUrlArray = model.contentImageURLArray;
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
