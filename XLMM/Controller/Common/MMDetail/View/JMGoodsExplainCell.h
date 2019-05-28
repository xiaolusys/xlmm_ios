//
//  JMGoodsExplainCell.h
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JMGoodsExplainCellIdentifier;

typedef void(^storeUpBlock)(UIButton *button);

@interface JMGoodsExplainCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *detailContentDic;
@property (nonatomic, strong) NSDictionary *customInfoDic;
@property (nonatomic, assign) NSInteger promptIndex;

@property (nonatomic, copy) storeUpBlock block;

@end
