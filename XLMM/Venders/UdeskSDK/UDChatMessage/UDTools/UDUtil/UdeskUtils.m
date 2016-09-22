//
//  UdeskUtils.m
//  UdeskSDK
//
//  Created by xuchen on 16/1/18.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import "UdeskUtils.h"
#import "UdeskLanguageTool.h"

@implementation UdeskUtils

NSString* getUDBundlePath( NSString * filename)
{
    
    NSBundle * libBundle = UDBUNDLE ;
    
    if ( libBundle && filename ){
        
        NSString * s=[[libBundle resourcePath] stringByAppendingPathComponent : filename];
        
        return s;
        
    }
    
    return nil ;
}

NSString * getUDLocalizedString( NSString * key) {
    
    return [[UdeskLanguageTool sharedInstance] getStringForKey:key withTable:@"UdeskLocalizable"];
}

@end
