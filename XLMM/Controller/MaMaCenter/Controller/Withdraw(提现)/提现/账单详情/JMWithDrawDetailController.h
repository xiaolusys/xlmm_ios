//
//  JMWithDrawDetailController.h
//  XLMM
//
//  Created by zhang on 16/9/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JMWithDrawDetailController : UIViewController

/**
 *  判断查询来源  来自妈妈提现 -> YES   来自零钱提现 -> NO
 */
@property (nonatomic, assign) BOOL isActiveValue;


@property (nonatomic, strong) NSDictionary *drawDict;

@property (nonatomic, strong) NSDictionary *mamaWithDrawHistoryDict;




@end
