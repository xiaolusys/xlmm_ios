//
//  JMSearchHistoryModel.h
//  XLMM
//
//  Created by zhang on 17/1/10.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSearchHistoryModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *searchID;
@property (nonatomic, copy) NSString *result_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *user_id;


@property (nonatomic, assign) CGFloat cellWidth;




@end



//{
//    count = 1;
//    next = "<null>";
//    previous = "<null>";
//    results =     (
//                   {
//                       content = g;
//                       id = 7;
//                       "result_count" = 130;
//                       status = normal;
//                       target = ModelProduct;
//                       "user_id" = 733615;
//                   }
//                   );
//}
