//
//  JMNewcomerTaskModel.h
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMNewcomerTaskModel : NSObject

@property (nonatomic, assign) BOOL show;

@property (nonatomic, assign) BOOL complete;

@property (nonatomic, copy) NSString *desc;

@end

/**
 *  show": true,
 "complete": true,
 "desc": "获得第一笔收益"
 */
