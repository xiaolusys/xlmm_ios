//
//  JMMainTableView.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMainTableView.h"

@implementation JMMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
