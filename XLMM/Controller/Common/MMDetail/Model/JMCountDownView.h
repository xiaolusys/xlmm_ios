//
//  JMCountDownView.h
//  XLMM
//
//  Created by 崔人帅 on 16/8/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^countDownBlock)(int second);

@protocol JMCountDownViewDelegate <NSObject>

-(void)countDownStart:(NSString *)countDownTimeArr;

-(void)countDownEnd:(NSString *)countDownTimeArr;

@end

@interface JMCountDownView : NSObject

+ (instancetype)shareCountDown;

@property (nonatomic, assign) int ennTime;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, weak) id<JMCountDownViewDelegate> delegate;

@property (nonatomic, copy) countDownBlock timeBlock;


- (instancetype)initWithCountDownTime:(int)endTime;

+ (instancetype)countDownWithCurrentTime:(int)endTime;
//+ (void)endTimer;

@end
