//
//  JMShareModel.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareModel.h"

@implementation JMShareModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"shareID":@"id"};
}


+ (instancetype)modelWithModel:(JMShareModel *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(JMShareModel *)model {
    if (self == [super init]) {
        self.active_at = model.active_at;
        self.created = model.created;
        self.desc = model.desc;
        self.shareID = model.shareID;
        self.share_img = model.share_img;
        self.share_link = model.share_link;
        self.status = model.status;
        self.title = model.title;
        self.url = model.url;
        self.share_type = model.share_type;
        self.profit = model.profit;
    }
    return self;
}
/**  
 *
 @property (nonatomic,copy) NSString *active_at;
 
 @property (nonatomic,copy) NSString *created;
 
 @property (nonatomic,copy) NSString *desc;
 
 @property (nonatomic,copy) NSString *shareID;
 
 @property (nonatomic,copy) NSString *share_img;
 
 @property (nonatomic,copy) NSString *share_link;
 
 @property (nonatomic,copy) NSString *status;
 
 @property (nonatomic,copy) NSString *title;
 
 @property (nonatomic,copy) NSString *url;
 */


@end
