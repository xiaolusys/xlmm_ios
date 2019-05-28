//
//  JMModifyAddressController.h
//  XLMM
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMInpotBoxBaseController.h"

@class JMAddressModel;
@interface JMModifyAddressController : JMInpotBoxBaseController

@property (nonatomic, strong) JMAddressModel *addressModel;
@property (nonatomic, assign) BOOL isAdd;                    // 判断是添加地址还是修改地址
//@property (nonatomic, assign) BOOL isBondedGoods;          // 判断是否为保税区商品(是:填写身份证,否:不用填写身份证)
@property (nonatomic, assign) NSInteger cartsPayInfoLevel;
@property (nonatomic, assign) NSInteger addressLevel;

@property (nonatomic, assign) BOOL orderEditAddress;         // 订单修改地址
@property (nonatomic, strong) NSMutableDictionary *orderDict;

@end
