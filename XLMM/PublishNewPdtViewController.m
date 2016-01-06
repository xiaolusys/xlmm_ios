//
//  PublishNewPdtViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PublishNewPdtViewController.h"
#import "UIViewController+NavigationBar.m"
#import "PicCollectionViewCell.h"
#import "PicHeaderCollectionReusableView.h"
#import "PicFooterCollectionReusableView.h"

#define CELLWIDTH 80

@interface PublishNewPdtViewController ()

@property (nonatomic, strong)UICollectionView *picCollectionView;



@end

@implementation PublishNewPdtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    [self createNavigationBarWithTitle:@"发布产品" selecotr:@selector(backClickAction)];
    [self createCollectionView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat rightSize = ([UIScreen mainScreen].bounds.size.width - 3 * CELLWIDTH - 3) * 0.5;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, rightSize, 10, rightSize);
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.minimumLineSpacing = 1.5;
    
    
    self.picCollectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    self.picCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.picCollectionView];
    
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    
    [self.picCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picCollectionCell"];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picHeader"];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"picFooter"];
}

#pragma mark --collection的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELLWIDTH, CELLWIDTH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        //返回页眉
        PicHeaderCollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picHeader" forIndexPath:indexPath];
        headerV.backgroundColor = [UIColor lightGrayColor];
        
//        //给header添加点击事件
//        NSString *key = self.allKey[indexPath.section];
//        headerV.headerLabel.text = self.headerDic[key];
        return headerV;
        
    }else{
        PicFooterCollectionReusableView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picFooter" forIndexPath:indexPath];
        footerV.backgroundColor = [UIColor orangeColor];
        return footerV;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 58);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 54);
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
