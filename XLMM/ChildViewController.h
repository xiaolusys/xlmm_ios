//
//  ChildViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WomanViewController.h"

@interface ChildViewController : UIViewController<
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate>{
}

@property (assign, nonatomic) BOOL isRoot;



@property (weak, nonatomic) IBOutlet UICollectionView *childCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topdistance;

- (IBAction)btnClicked:(UIButton *)sender;



@end
