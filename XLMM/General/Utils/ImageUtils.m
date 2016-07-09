//
//  ImageUtils.m
//  XLMM
//
//  Created by wulei on 5/3/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUtils.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"

@implementation ImageUtils
+ (void)loadImage:(UIImageView *)img url:(NSString *)url{

    [img sd_setImageWithURL:[NSURL URLWithString:[url JMUrlEncodedString]]];

}
@end