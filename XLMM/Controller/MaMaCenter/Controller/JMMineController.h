//
//  JMMineController.h
//  XLMM
//
//  Created by zhang on 16/9/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMMaMaCenterModel,JMMaMaExtraModel;
@interface JMMineController : UIViewController

/**
 *  妈妈中心数据源
 */
@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;
/**
 *  妈妈中心额外数据源
 */
@property (nonatomic, strong) JMMaMaExtraModel *extraModel;

@property (nonatomic, strong) NSDictionary *messageDic;

@property (nonatomic, strong) NSDictionary *webDict;


@end
