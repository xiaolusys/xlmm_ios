//
//  JMDevice.m
//  XLMM
//
//  Created by zhang on 16/10/4.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMDevice.h"
#import "sys/utsname.h"
#import "MMClass.h"

@implementation JMDevice

+ (JMDevice *)defaultDecice {
    static dispatch_once_t onceToken;
    static JMDevice *defaultDevice = nil;
    dispatch_once(&onceToken, ^{
        defaultDevice = [[JMDevice alloc] init];
    });
    return defaultDevice;
}

- (NSString *)getUserAgent {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* phoneVersion = SSystemVersion;
    NSString *appCurVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];            // 当前应用版本
    NSString* phoneModel = [[JMDevice defaultDecice] getDeviceName];
    NSString *userAgent =  [NSString stringWithFormat:@"iOS/%@ XLMM/%@ Mobile/(%@)",phoneVersion,appCurVersion,phoneModel];
    
    return userAgent;
    
}


- (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([machineString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([machineString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([machineString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([machineString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([machineString isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([machineString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([machineString isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([machineString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([machineString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([machineString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([machineString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([machineString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s Plus";
    if ([machineString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s";
    if ([machineString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([machineString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([machineString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([machineString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([machineString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([machineString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machineString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([machineString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([machineString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([machineString isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([machineString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([machineString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([machineString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([machineString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([machineString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([machineString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([machineString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([machineString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([machineString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([machineString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([machineString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([machineString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
    if ([machineString isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([machineString isEqualToString:@"i386"])         return @"Simulator";
    if ([machineString isEqualToString:@"x86_64"])       return @"Simulator";
    return machineString;
 
}

@end