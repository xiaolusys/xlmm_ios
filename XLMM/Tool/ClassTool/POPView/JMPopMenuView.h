//
//  JMPopMenuView.h
//  XLMM
//
//  Created by zhang on 16/8/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemsClickBlock)(NSString *str, NSInteger tag);
typedef void(^BackViewTapBlock)();

@interface JMPopMenuView : UIView

@property (nonatomic,copy) ItemsClickBlock itemsClickBlock;
@property (nonatomic,copy) BackViewTapBlock backViewTapBlock;
// 最大显示行数
@property (nonatomic,assign) NSInteger maxValueForItemCount;

+ (JMPopMenuView *)createMenuWithFrame:(CGRect)frame target:(UIViewController *)target dataArray:(NSArray *)dataArray itemsClickBlock:(void(^)(NSString *str, NSInteger tag))itemsClickBlock backViewTap:(void(^)())backViewTapBlock;

// 根据坐标原点显示菜单
+ (void)showMenuPoint:(CGPoint)point;
// 隐藏菜单
+ (void)hidden;
// 清除菜单
+ (void)clearMenu;

@end


@interface JMMenuCell : UITableViewCell

@property (nonatomic, copy) NSString *itemString;

@end

@interface JMMenuModel : NSObject

@property (nonatomic,copy) NSString *itemName;

@end









//+ (void)configCustomPopMenuWithFrame:(CGRect)frame ImageArr:(NSArray *)imageArr TitleArr:(NSArray *)titleArr AnchorPoint:(CGPoint)anchorPoint selectedRowIndex:(void(^)(NSInteger index))indexBlock Animation:(BOOL)animation ShowTime:(NSTimeInterval)show hideTime:(NSTimeInterval)hide;
//
//+ (void)hideView;
