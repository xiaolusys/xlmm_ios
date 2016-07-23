//
//  JMUpdataAppPopView.h
//  XLMM
//
//  Created by zhang on 16/7/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMUpdataAppPopView;

@protocol JMUpdataAppPopViewDelegate <NSObject>

@optional

- (void)composeUpdataAppButton:(JMUpdataAppPopView *)updataButton didClick:(NSInteger)index;

@end

@interface JMUpdataAppPopView : UIView

@property (nonatomic, weak) id<JMUpdataAppPopViewDelegate> delegate;

@property (nonatomic, copy) NSString *releaseNotes;

+ (instancetype)defaultUpdataPopView;

@end
