//
//  JMCategoryContentCell.m
//  XLMM
//
//  Created by zhang on 16/9/24.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCategoryContentCell.h"

#define TabWidth SCREENWIDTH * 0.25
#define ColWidth SCREENWIDTH * 0.75

@implementation JMContentCollectionView



@end

@implementation JMCategoryContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initialize];
        
    }
    return self;
}
- (void)initialize {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.itemSize = CGSizeMake((ColWidth - 20) / 3, (ColWidth - 20) * 5 / 9);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.contentCollecionView = [[JMContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, ColWidth, SCREENHEIGHT - 64 - 50) collectionViewLayout:layout];
    self.contentCollecionView.backgroundColor = [UIColor whiteColor];
//    self.contentCollecionView.dataSource = self;
//    self.contentCollecionView.delegate = self;
    [self.contentCollecionView registerClass:[JMCategoryListCell class] forCellWithReuseIdentifier:ContentCollectionViewIndentifier];
    [self.contentCollecionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mainCollectionViewHeaderIdentifier];
    [self.contentView addSubview:self.contentCollecionView];
    
    
}
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate IndexPath:(NSIndexPath *)indexPath {
    
    self.contentCollecionView.dataSource = dataSourceDelegate;
    self.contentCollecionView.delegate = dataSourceDelegate;
    self.contentCollecionView.ContentCollectionIndexPath = indexPath;
    [self.contentCollecionView setContentOffset:self.contentCollecionView.contentOffset animated:NO];
    
    [self.contentCollecionView reloadData];
    
    
}

@end
