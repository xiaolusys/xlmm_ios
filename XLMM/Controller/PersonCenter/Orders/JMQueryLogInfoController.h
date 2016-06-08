//
//  JMQueryLogInfoController.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderGoodsModel;
@interface JMQueryLogInfoController : UIViewController

@property (nonatomic,strong) JMOrderGoodsModel *goodsModel;
@property (nonatomic,strong) NSDictionary *goodsListDic;

@property (copy, nonatomic) NSString *logName;
@property (copy, nonatomic) NSString *packetId;
@property (copy, nonatomic) NSString *companyCode;

@end
