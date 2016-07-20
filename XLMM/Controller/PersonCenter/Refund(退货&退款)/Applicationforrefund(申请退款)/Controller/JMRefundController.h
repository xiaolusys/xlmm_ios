//
//  JMRefundController.h
//  XLMM
//
//  Created by zhang on 16/6/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMRefundController;
@class JMOrderGoodsModel;
@protocol JMRefundControllerDelegate <NSObject>

- (void)Clickrefund:(JMRefundController *)click OrderGoods:(JMOrderGoodsModel *)goodsModel Refund:(NSDictionary *)refundDic;

- (void)Clickrefund:(JMRefundController *)click ContinuePay:(NSDictionary *)continueDic;

@end

@interface JMRefundController : UIViewController

@property (nonatomic,strong) NSDictionary *refundDic;

@property (nonatomic, strong) NSDictionary *continuePayDic;

@property (nonatomic, strong) JMOrderGoodsModel *ordergoodsModel;

@property (nonatomic,weak) id<JMRefundControllerDelegate>delegate;

@end
