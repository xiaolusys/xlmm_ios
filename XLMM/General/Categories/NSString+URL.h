//
//  NSString+URL.h
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSString *)JMUrlEncodedString;

- (NSString *)JMURLDecodedString;

- (NSString *)imageCompression;

- (NSString *)imageMoreCompression;

- (NSString *)ImageNoCompression;

- (NSString *)imageOrderCompression;

- (NSString *)imageShareCompression;

- (NSString *)imagePostersCompression;

- (NSString *)imageShareNinePicture;

- (NSString *)imageNormalCompression;
@end
