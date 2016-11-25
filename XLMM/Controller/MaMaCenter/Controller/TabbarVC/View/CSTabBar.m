//
//  CSTabBar.m
//  CSPageViewController
//
//  Created by zhang on 16/10/28.
//  Copyright © 2016年 cui. All rights reserved.
//

#import "CSTabBar.h"
#import "CSTabBarButton.h"

@interface CSTabBar ()

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *tabBarButtons;




@end

@implementation CSTabBar

- (NSMutableArray *)tabBarButtons {
    
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // 遍历模型数组，创建对应tabBarButton
    for (UITabBarItem *item in _items) {
        
        CSTabBarButton *btn = [CSTabBarButton buttonWithType:UIButtonTypeCustom];
        
        // 给按钮赋值模型，按钮的内容由模型对应决定
        btn.item = item;
        
        btn.tag = self.tabBarButtons.count;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
        if (btn.tag == 0) { // 选中第0个
            [self buttonClick:btn];
            
        }
        
        [self addSubview:btn];
        
        // 把按钮添加到按钮数组
        [self.tabBarButtons addObject:btn];
    }
}
/**
 *  监听按钮被点击 --- 点击tabBarButton调用
 */
- (void)buttonClick:(UIButton *)button {
    //按钮的状态
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectedButton:)]) {
        [self.delegate tabBar:self didSelectedButton:button.tag];
    }
    
    
    
    
}






// self.items UITabBarItem模型，有多少个子控制器就有多少个UITabBarItem模型
// 调整子控件的位置
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //调整加号按钮的位置
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (self.items.count);
    CGFloat btnH = self.bounds.size.height;
    
    
    
    
    
    
    int i = 0;
    // 设置tabBarButton的frame
    for (UIView *tabBarButton in self.tabBarButtons) {
        btnX = i * btnW;
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }

}








@end






























