//
//  ImageUtils.h
//  XLMM
//
//  Created by wulei on 5/3/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#ifndef ImageUtils_h
#define ImageUtils_h
#import "UIImageView+WebCache.h"

@interface ImageUtils : NSObject
+ (void)loadImage:(UIImageView *)img url:(NSString *)url;
@end

#endif /* ImageUtils_h */
