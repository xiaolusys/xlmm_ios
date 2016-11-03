//
//  JMMakeMoneyController.h
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^currentBlock)(UILabel *currentLabel);

@class JMMaMaCenterModel;
@interface JMMakeMoneyController : UIViewController

@property (nonatomic, strong) NSDictionary *makeMoneyDic;

@property (nonatomic, strong) NSMutableArray *activeArray;

@property (nonatomic, strong) NSDictionary *messageDic;

@property (nonatomic, strong) JMMaMaCenterModel *centerModel;

@property (nonatomic, strong) NSArray *mamaResults;

@property (nonatomic, copy) NSString *currentTurnsNum;

@property (nonatomic, copy) currentBlock block;

@end
