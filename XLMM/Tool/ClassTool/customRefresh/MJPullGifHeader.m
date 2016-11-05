//
//  MJPullGifHeader.m
//  XLMM
//
//  Created by younishijie on 15/12/29.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MJPullGifHeader.h"

@implementation MJPullGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<45; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"圈圈加载00%02d.png", i]];
        [idleImages addObject:image];
    }
    [self setImages:@[[UIImage imageNamed:@"xiala.png"]] forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）

    [self setImages:@[[UIImage imageNamed:@"songshou.png"]] forState:MJRefreshStatePulling];
//    self.stateLabel.font = [UIFont systemFontOfSize:10];
    self.stateLabel.hidden = YES;
  //  self.stateLabel.textAlignment = NSTextAlignmentLeft;
    // 设置正在刷新状态的动画图片
    
    [self setImages:idleImages duration:1.0 forState:MJRefreshStateRefreshing];
}


@end
