//
//  JMCompSugView.h
//  投诉建议
//
//  Created by zhang on 16/6/16.
//  Copyright © 2016年 cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCompSugView;
@protocol JMCompSugViewDelegate <NSObject>

@optional
- (void)composeShareBtn:(JMCompSugView *)shareBtn Button:(UIButton *)button didClickBtn:(NSInteger)index;

@end

@interface JMCompSugView : UIView

@property (nonatomic,weak) id<JMCompSugViewDelegate> delegate;

@end
