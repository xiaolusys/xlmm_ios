//
//  JMGoodsListController.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderGoodsModel;
@interface JMGoodsListController : UIViewController

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,strong) JMOrderGoodsModel *goodsModel;

@property (nonatomic, strong) NSMutableArray *goodsListArr;

@end
