//
//  CSVTMagicController.m
//  XLMM
//
//  Created by zhang on 17/3/15.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSVTMagicController.h"
#import "VTMagic.h"
#import "CSTableViewController.h"
#import "CSCollectionController.h"


@interface CSVTMagicController () <VTMagicViewDelegate, VTMagicViewDataSource>

@property (nonatomic, strong) VTMagicController *magicController;

@end

@implementation CSVTMagicController
#pragma mark ==== 视图生命周期 ====
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"VTMagin测试" selecotr:@selector(backClick)];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
//    [_magicController.magicView reloadData];
    [self.magicController.magicView reloadDataToPage:self.currentIndex];
    
    
    
}

- (NSMutableArray *)getItemUrls {
    NSArray *urlBefroe = @[@"/rest/v2/modelproducts?cid=153", @"/rest/v2/modelproducts?cid=8", @"/rest/v2/modelproducts?cid=7",
                           @"/rest/v2/modelproducts?cid=3",@"/rest/v2/modelproducts?cid=5", @"/rest/v2/modelproducts?cid=8"];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < urlBefroe.count; i++) {
        NSString *url = [NSString stringWithFormat:@"%@%@", Root_URL, urlBefroe[i]];
        [mutArr addObject:url];
    }
    return mutArr;
}
#pragma mark ==== 懒加载 ==== 
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.itemScale = 1.2;
        _magicController.magicView.headerHeight = 45;
        _magicController.magicView.navigationHeight = 45;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.headerView.backgroundColor = RGBCOLOR(243, 40, 47);
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.headerHidden = NO;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return @[@"第0个控制器",@"第1个控制器",@"第2个控制器",@"第3个控制器",@"第4个控制器",@"第5个控制器"];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    // 默认会自动完成赋值
    //    MenuInfo *menuInfo = _menuList[itemIndex];
    //    [menuItem setTitle:menuInfo.title forState:UIControlStateNormal];
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
//    if (pageIndex == 0) {
//        static NSString *recomId = @"recom.identifier";
//        CSTableViewController *tableViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
//        if (!tableViewController) {
//            tableViewController = [[CSTableViewController alloc] init];
//        }
//        tableViewController.currentIndex = pageIndex;
//        return tableViewController;
//    }
    static NSString *gridId = @"grid.identifier";
    CSCollectionController *collectionController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!collectionController) {
        collectionController = [[CSCollectionController alloc] init];
    }
    collectionController.urlString = [self getItemUrls][pageIndex];
    return collectionController;
    return nil;
}


#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}





- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end





















































