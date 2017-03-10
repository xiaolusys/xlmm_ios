//
//  JMSystemPermissionsManager.h
//  XLMM
//
//  Created by zhang on 17/3/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KSystemPermissions) {
    
    KAVMediaTypeVideo = 0,  // 相机
    KALAssetsLibrary,       //相册
    KCLLocationManager,     //地理位置信息
    KAVAudioSession,        //音频
    KABAddressBook          //手机通讯录
};


@interface JMSystemPermissionsManager : NSObject

+ (instancetype)sharedManager ;

/**
 *  根据场景选择合适的提示系统权限类型
 *
 *  @param systemPermissions 系统权限类型
 *
 *  @return 是否具有权限
 */
- (BOOL)requestAuthorization:(KSystemPermissions)systemPermissions;



@end
