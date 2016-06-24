//
//  JMGoodsShowController.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/31.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderGoodsModel;
@interface JMGoodsShowController : UIViewController

@property (nonatomic,strong) JMOrderGoodsModel *goodsModel;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *packNumArr;


@end
