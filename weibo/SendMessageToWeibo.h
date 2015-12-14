//
//  SendMessageToWeibo.h
//  ShareDemo
//
//  Created by y on 15/12/4.
//  Copyright © 2015年 xxt. All rights reserved.
//

#import "WeiboSDK.h"

@protocol SendMessageToWeiboDelegate <NSObject>

@optional
- (void)managerDidRecvFromWeiboMessageResponse:(WBBaseResponse *)response;
@end

@interface SendMessageToWeibo : NSObject<WeiboSDKDelegate>

@property (nonatomic, assign) id<SendMessageToWeiboDelegate> delegate;

+ (instancetype)sharedManager;
+ (void)sendMessageWithText:(NSString*)message andPicture:(NSData*)imageData;

@end
