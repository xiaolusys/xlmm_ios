//
//  SendMessageToWeibo.m
//  ShareDemo
//
//  Created by y on 15/12/4.
//  Copyright © 2015年 xxt. All rights reserved.
//

#import "SendMessageToWeibo.h"

static NSString *wbtoken = nil;
@implementation SendMessageToWeibo

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SendMessageToWeibo *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SendMessageToWeibo alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

+ (void)sendMessageWithText:(NSString*)messageText andPicture:(NSData*)imageData
{
    WBMessageObject *message = [WBMessageObject message];
    
    // 分享的文字
    message.text = messageText;
    
    // 分享的图片
    WBImageObject *image = [WBImageObject object];
    image.imageData = imageData;
    message.imageObject = image;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    
    // 回调地址
    authRequest.redirectURI = @"http://kids.appcarrier.com/index.php/user/login";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];

    [WeiboSDK sendRequest:request];
}

#pragma mark - delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            wbtoken = accessToken;
        }
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvFromWeiboMessageResponse:)]) {
                [_delegate managerDidRecvFromWeiboMessageResponse:response];
        }    }
}

@end
