//
//  JMContinuePayModel.h
//  XLMM
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMContinuePayModel : NSObject

@property (nonatomic, copy) NSString *continuePayID;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *payable;

@end


/**
 *    extras =     {
 channels =         (
 {
 id = "alipay_wap";
 msg = "";
 name = "\U652f\U4ed8\U5b9d";
 payable = 1;
 }
 );
 };

 */
