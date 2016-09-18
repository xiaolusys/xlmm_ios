//
//  JMVisitorModel.h
//  XLMM
//
//  Created by zhang on 16/9/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMVisitorModel : NSObject

/**
 *  时间
 */
@property (nonatomic, copy) NSString *created;
/**
 *  访客ID
 */
@property (nonatomic, copy) NSString *mama_id;
@property (nonatomic, copy) NSString *modified;
@property (nonatomic, copy) NSString *uni_key;
/**
 *  访客来源
 */
@property (nonatomic, copy) NSString *visitor_description;
/**
 *  访客头像
 */
@property (nonatomic, copy) NSString *visitor_img;
/**
 *  访客名称
 */
@property (nonatomic, copy) NSString *visitor_nick;



@end
