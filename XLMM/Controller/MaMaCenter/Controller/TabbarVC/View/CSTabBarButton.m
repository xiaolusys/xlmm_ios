//
//  CSTabBarButton.m
//  CSPageViewController
//
//  Created by zhang on 16/10/28.
//  Copyright © 2016年 cui. All rights reserved.
//

#import "CSTabBarButton.h"

//图标的比例
#define TabBarButtonImageRatio 0.7


@implementation CSTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        // 设置字体颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return self;
}
// 重写setHighlighted，取消高亮做的事情
- (void)setHighlighted:(BOOL)highlighted {
    
}
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    // KVO：时刻监听一个对象的属性有没有改变
    // 给谁添加观察者
    // Observer:按钮
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
    
}
/**
 *  监听到某个对象的属性改变了,就会调用
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self setTitle:_item.title forState:UIControlStateNormal];
    
    [self setImage:_item.image forState:UIControlStateNormal];
    
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    
    // 设置badgeValue
//    self.badgeButton.badgeValue = _item.badgeValue;
    
    
}

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"title" context:nil];
    [_item removeObserver:self forKeyPath:@"image" context:nil];
    [_item removeObserver:self forKeyPath:@"badgeValue" context:nil];
    [_item removeObserver:self forKeyPath:@"selectedImage" context:nil];
    
}





// 修改按钮内部子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.imageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * TabBarButtonImageRatio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH - 3;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    // 3.badgeView
//    self.badgeButton.x = self.width - self.badgeButton.width - 10;
//    self.badgeButton.y = 0;
    
//    kWeakSelf
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.top.equalTo(weakSelf).offset(3);
//        make.width.height.mas_equalTo(@(28));
//    }];
//    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(5);
//    }];
    
    
    
    
    
    
}



@end












































