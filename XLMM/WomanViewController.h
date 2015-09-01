//
//  WomanViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WomanViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
}

@property (assign, nonatomic) BOOL isRoot;

@property (weak, nonatomic) IBOutlet UICollectionView *womanCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topdistance;

- (IBAction)btnClicked:(UIButton *)sender;


@end
