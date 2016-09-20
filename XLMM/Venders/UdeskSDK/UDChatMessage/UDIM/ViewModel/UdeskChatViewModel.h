//
//  UdeskChatViewModel.h
//  UdeskSDK
//
//  Created by xuchen on 16/1/19.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdeskMessageTextView.h"

@class UdeskMessage;
@class UdeskAgent;

@protocol UdeskChatViewModelDelegate <NSObject>

/**
 *  通知viewController更新tableView；
 */
- (void)reloadChatTableView;
/**
 *  更新tableView某个cell
 *
 *  @param indexPath cell位置
 */
- (void)didUpdateCellModelWithIndexPath:(NSIndexPath *)indexPath;
/**
 *  接收到客服model
 *
 *  @param agent 客服
 */
- (void)didFetchAgentModel:(UdeskAgent *)agent;
/**
 *  点击了发送表单
 */
- (void)didSelectSendTicket;
/**
 *  点击了黑名单提示框确定
 */
- (void)didSelectBlacklistedAlertViewOkButton;
/**
 *  接受客服状态
 *
 *  @param agent 客服model
 */
- (void)didReceiveAgentPresence:(UdeskAgent *)agent;
/**
 *  评价成功
 */
- (void)didSurveyCompletion:(NSString *)message;

@end

@interface UdeskChatViewModel : NSObject

/** 是否需要显示下拉加载 */
@property (nonatomic, assign         ) BOOL                       isShowRefresh;
/** 消息数据 */
@property (nonatomic, strong,readonly) NSMutableArray             *messageArray;
/** ViewModel代理 */
@property (nonatomic, weak           ) id <UdeskChatViewModelDelegate> delegate;


/**
 *  加载更多DB消息
 */
- (void)pullMoreDateBaseMessage;
/**
 *  重发失败的消息
 *
 *  @param message    失败的消息
 *  @param completion 发送回调
 */
- (void)resendFailedMessage:(void(^)(UdeskMessage *failedMessage,BOOL sendStatus))completion;
/**
 *  获取消息数量
 */
- (NSInteger)numberOfItems;
/**
 *  获取消息model
 *
 *  @param row 下标
 */
- (id)objectAtIndexPath:(NSInteger)row;
/**
 *  点击底部功能栏坐相应操作
 */
- (void)clickInputViewShowAlertView;
/**
 *  发送文本消息
 *
 *  @param text       文本
 *  @param completion 发送状态&发送消息体
 */
- (void)sendTextMessage:(NSString *)text
             completion:(void(^)(UdeskMessage *message,BOOL sendStatus))completion;

/**
 *  发送图片消息
 *
 *  @param image      图片
 *  @param completion 发送状态&发送消息体
 */
- (void)sendImageMessage:(UIImage *)image
              completion:(void(^)(UdeskMessage *message,BOOL sendStatus))completion;

/**
 *  发送语音消息
 *
 *  @param audioPath     语音文件地址
 *  @param audioDuration 语音时长
 *  @param comletion     发送状态&发送消息体
 */
- (void)sendAudioMessage:(NSString *)audioPath
           audioDuration:(NSString *)audioDuration
              completion:(void(^)(UdeskMessage *message,BOOL sendStatus))comletion;

/**
 *  添加需要重新发送消息
 *
 *  @param message 发送失败的消息
 */
- (void)addResendMessageToArray:(UdeskMessage *)message;
/**
 *  移除发送失败的消息
 *
 *  @param message 发送失败的消息
 */
- (void)removeResendMessageInArray:(UdeskMessage *)message;

@end
