//
//  CSCustomerColView.m
//  XLMM
//
//  Created by zhang on 17/3/14.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSCustomerColView.h"
#import "JMRootGoodsModel.h"



@interface CSCustomerColView () <STCollectionViewDataSource,STCollectionViewDelegate>

@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, assign) NSMutableArray *dataArray;

@end


@implementation CSCustomerColView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)_layout {
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    STCollectionViewFlowLayout * layout = self.st_collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.stDelegate = self;
    self.stDataSource = self;
    [self registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"item"];

}



- (void)refreshWithCustomerColViewData:(id)data atIndex:(NSInteger)index {
    self.dataArray = (NSMutableArray *)[data objectForKey:@(index)];
    self.itemIndex = index;
    [self reloadData];
    
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(STCollectionViewFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section {
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 15) / 2, (SCREENWIDTH - 15) / 2 * 4 / 3);
}

- (NSInteger)stCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)stCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    JMRootGoodsModel *model = self.dataArray[indexPath.row];
    UILabel * title = [cell viewWithTag:888];
    if (nil == title) {
        title = [UILabel new];
        title.tag = 888;
        title.cs_size = CGSizeMake((SCREENWIDTH - 15) / 2, (SCREENWIDTH - 15) / 2);
        title.textColor = [UIColor redColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:14];
        [cell addSubview:title];
    }
    title.center = CGPointMake(cell.cs_w/2, cell.cs_h/2);
    title.text = [NSString stringWithFormat:@"col --> %ld -- Item %ld  \n  %@",self.itemIndex,indexPath.item,model.name];
    
    
    return cell;
}


@end


























































