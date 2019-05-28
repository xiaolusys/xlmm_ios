//
//  JMGoodsCountTime.m
//  XLMM
//
//  Created by zhang on 16/11/17.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsCountTime.h"

@implementation JMGoodsCountTime

+ (instancetype)shareCountTime{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JMGoodsCountTime alloc] init];
    });
    return instance;
}


- (instancetype)initWithEndTime:(int)endTime {
    if (self == [super init]) {
        [self currentDownTime:endTime];
    }
    return self;
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)initCountDownWithCurrentTime:(int)endTime {
    return [[self shareCountTime] initWithEndTime:endTime];
}
- (void)currentDownTime:(int)time {
    __block int timeout  = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);//每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        timeout -- ;
        if (timeout <= 0) { //倒计时结束,关闭
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面显示
                //                NSString *endTime = @"商品已下架";
                //                [self.delegate countDownEnd:djsArr];
                if (self.countBlock) {
                    self.countBlock(-1);
                }
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面显示
                //                NSString *startTime = [self TimeformatFromSeconds:timeout];
                //                [self.delegate countDownStart:djsArr];
                if (self.countBlock) {
                    self.countBlock(timeout);
                }
                
            });
            //            timeout -- ;
        }
    });
    dispatch_resume(self.timer);
    
    
}


@end





























