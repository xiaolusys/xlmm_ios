//
//  UIScrollView+UITouch.m
//  XLMM
//
//  Created by zhang on 17/2/6.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)


- (BOOL)vtm_isNeedDisplayWithFrame:(CGRect)frame preloading:(BOOL)preloading {
    CGRect visibleRect = (CGRect){CGPointMake(self.contentOffset.x, 0), self.frame.size};
    CGRect intersectRegion = CGRectIntersection(frame, visibleRect);
    BOOL isOnScreen =  !CGRectIsNull(intersectRegion) || !CGRectIsEmpty(intersectRegion);
    if (!preloading) {
        BOOL isNotBorder = 0 != (int)self.contentOffset.x%(int)self.frame.size.width;
        return isOnScreen && (isNotBorder ?: 0 != intersectRegion.size.width);
    }
    return isOnScreen;
}

- (BOOL)vtm_isItemNeedDisplayWithFrame:(CGRect)frame {
    frame.size.width *= 2;
    BOOL isOnScreen = [self vtm_isNeedDisplayWithFrame:frame preloading:YES];
    if (isOnScreen) {
        return YES;
    }
    
    frame.size.width *= 0.5;
    frame.origin.x -= frame.size.width;
    isOnScreen = [self vtm_isNeedDisplayWithFrame:frame preloading:YES];
    return isOnScreen;
}



@end
