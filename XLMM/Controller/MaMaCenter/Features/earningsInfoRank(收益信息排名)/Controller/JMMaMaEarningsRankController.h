//
//  JMMaMaEarningsRankController.h
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMMaMaEarningsRankController : UIViewController

@property (nonatomic, copy) NSString *selfInfoUrl;

@property (nonatomic, copy) NSString *rankInfoUrl;

@property (nonatomic, assign) BOOL isTeamEarningsRank;

@property (nonatomic, strong) NSMutableArray *urlArray;

@property (nonatomic, assign) NSInteger selectIndex;

@end
