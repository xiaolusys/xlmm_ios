//
//  CSTableViewPlaceHolderDelegate.h
//  XLMM
//
//  Created by zhang on 17/2/27.
//  Copyright © 2017年 上海己美. All rights reserved.
//

@protocol CSTableViewPlaceHolderDelegate <NSObject>

@required
- (UIView *)createPlaceHolderView;

@optional
- (BOOL)enableScrollWhenPlaceHolderViewShowing;

@end
