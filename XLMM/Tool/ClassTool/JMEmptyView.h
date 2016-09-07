//
//  JMEmptyView.h
//  XLMM
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backToRootBlock)(NSInteger index);

@interface JMEmptyView : UIView

@property (nonatomic, copy) backToRootBlock block;

@property (nonatomic, copy) NSString *imageStr;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle BackImage:(NSString *)imageStr InfoStr:(NSString *)infoStr;


@end
