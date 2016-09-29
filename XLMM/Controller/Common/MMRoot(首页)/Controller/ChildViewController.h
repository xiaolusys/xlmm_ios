//
//  ChildViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMNavigationDelegate.h"

@interface ChildViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>{
}


@property (nonatomic, assign) id<MMNavigationDelegate>delegate;
@property (nonatomic, assign, getter=isChildClothing) BOOL childClothing;
@property (assign, nonatomic) BOOL isRoot;
@property (copy, nonatomic) NSString *nameTitle;
@property (copy, nonatomic) NSString *urlString;
@property (copy, nonatomic) NSString *orderUrlString;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topdistant;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *childCollectionView;
- (IBAction)btnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *jiageButton;
@property (weak, nonatomic) IBOutlet UIButton *tuijianButton;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *categoryUrlString;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger )type;
@end
