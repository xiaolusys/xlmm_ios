//
//  NSString+URL.h
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSString *)URLEncodedString;

- (NSString *)imageCompression;

- (NSString *)imageMoreCompression;

- (NSString *)ImageNoCompression;

- (NSString *)imageShareCompression;

- (NSString *)imagePostersCompression;

- (NSString *)imageShareNinePicture;
@end