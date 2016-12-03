//
//  JMStoreupController.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMStoreupController.h"
#import "JMHotGoodsController.h"
#import "JMOutStockGoodsController.h"

@interface JMStoreupController ()

@end

@implementation JMStoreupController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isHideNavitaionLeftBar) {
        [self createNavigationBarWithTitle:@"我的收藏" selecotr:nil];
    }else {
        [self createNavigationBarWithTitle:@"我的收藏" selecotr:@selector(btnClicked:)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}

- (NSArray *)classArr {
    return @[@"JMHotGoodsController",@"JMOutStockGoodsController"];
}
- (NSArray *)titleArr {
    return @[@"热销商品",@"未上架"];
}


- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
















































