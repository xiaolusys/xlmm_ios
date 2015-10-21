//
//  MMSizeChartView.h
//  CustomSizeView2
//
//  Created by younishijie on 15/10/21.
//  Copyright © 2015年 上海己美网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSizeChartView : UIView


@property (nonatomic, copy) NSArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array;

@end
