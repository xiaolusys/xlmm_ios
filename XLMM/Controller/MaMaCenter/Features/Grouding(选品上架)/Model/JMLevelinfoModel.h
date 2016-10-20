//
//  JMLevelinfoModel.h
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLevelinfoModel : NSObject

/**
 *  当前Vip等级
 */
@property (nonatomic, copy) NSString *agencylevel;
@property (nonatomic, copy) NSString *agencylevel_desc;
/**
 *  下一个Vip等级
 */
@property (nonatomic, copy) NSString *next_agencylevel;
@property (nonatomic, copy) NSString *next_agencylevel_desc;




@end
