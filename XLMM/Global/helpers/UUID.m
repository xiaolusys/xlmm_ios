//
//  UUID.m
//  XLMM
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "UUID.h"
#import "SSKeychain.h"

@implementation UUID
+ (NSString *)gen_uuid {
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
    CFRelease(uuid_string_ref);
    return uuid;
}
@end
