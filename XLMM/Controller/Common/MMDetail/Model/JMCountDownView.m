//
//  JMCountDownView.m
//  XLMM
//
//  Created by 崔人帅 on 16/8/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCountDownView.h"

@implementation JMCountDownView

+ (instancetype)shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JMCountDownView alloc] init];
    });
    return instance;
}


- (instancetype)initWithCountDownTime:(int)endTime {
    if (self == [super init]) {
        self.ennTime = endTime;
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
+ (instancetype)countDownWithCurrentTime:(int)endTime {
    return [[self shareCountDown] initWithCountDownTime:endTime];
}
- (void)currentDownTime:(int)time {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 设置时间格式
////    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
////    [dateFormatter setTimeZone:timeZone]; //设置时区 ＋8:00
//    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
//    NSDate *someDayDate = [dateFormatter dateFromString:currentTime];
//    NSDate *date = [dateFormatter dateFromString:self.ennTime]; // 结束时间
//    NSTimeInterval time = [date timeIntervalSinceDate:someDayDate];  //结束时间距离当前时间的秒数
//    NSLog(@"结束时间距离当前时间的秒数: %lld 秒",(long long int)time);
    
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
                if (self.timeBlock) {
                    self.timeBlock(-1);
                }
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面显示
//                NSString *startTime = [self TimeformatFromSeconds:timeout];
//                [self.delegate countDownStart:djsArr];
                if (self.timeBlock) {
                    self.timeBlock(timeout);
                }
                
            });
//            timeout -- ;
        }
    });
    dispatch_resume(self.timer);

    

}

-(NSString *)TimeformatFromSeconds:(NSInteger)seconds {
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld天%02ld时%02ld分%02ld秒",seconds/(3600*24),(seconds/(3600))%24,(seconds%3600)/60,seconds%60];
    return timeString;
//    NSString *str_day = [NSString stringWithFormat:@"%02ld",seconds/(3600*24)];
//    NSString *str_hour = [NSString stringWithFormat:@"%02ld",(seconds/(3600))%24];
//    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
//    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
//    NSArray *format_time = [NSArray arrayWithObjects:str_day,str_hour,str_minute,str_second, nil];
//    return format_time;
    
}
@end











































