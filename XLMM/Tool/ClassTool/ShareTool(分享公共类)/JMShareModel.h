//
//  JMShareModel.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMShareModel : NSObject

@property (nonatomic,copy) NSString *active_at;

@property (nonatomic,copy) NSString *created;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *shareID;

@property (nonatomic,copy) NSString *share_img;

@property (nonatomic,copy) NSString *share_link;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *share_type;

@property (nonatomic, strong) NSDictionary *profit;

+ (instancetype)modelWithModel:(JMShareModel *)model;

- (instancetype)initWithModel:(JMShareModel *)model;

@end
