//
//  ChildViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController<
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate>{
}

@property (assign, nonatomic) BOOL isRoot;
@property (copy, nonatomic) NSString *urlString;
@property (copy, nonatomic) NSString *orderUrlString;



@property (weak, nonatomic) IBOutlet UICollectionView *childCollectionView;


- (IBAction)btnClicked:(UIButton *)sender;



@end
