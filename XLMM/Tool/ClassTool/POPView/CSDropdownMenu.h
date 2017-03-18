//
//  CSDropdownMenu.h
//  XLMM
//
//  Created by zhang on 17/3/18.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSMenuSegmentStyle) {
    CSMenuSegmentStyleWithImage = 0,
    CSMenuSegmentStyleWithTitle = 1 << 0
};

@interface CSDropdownMenuIndexPath : NSObject

@property (nonatomic, assign) NSInteger cloumn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger item;

- (instancetype)initWithCloum:(NSInteger)cloum row:(NSInteger)row;
+ (instancetype)indexPathWithCloum:(NSInteger)cloum row:(NSInteger)row;
+ (instancetype)indexPathWithCloum:(NSInteger)cloum row:(NSInteger)row item:(NSInteger)item;

@end


@class CSDropdownMenu;
@protocol CSDropdownMenuDataSource <NSObject>

@optional
// 返回 菜单的 列数
- (NSInteger)numberOfColumnWithMenuView:(CSDropdownMenu *)menuView;
// 返回 菜单的 某个列的行数
- (NSInteger)menuView:(CSDropdownMenu *)menuView numberOfRowWithIndexPath:(CSDropdownMenuIndexPath *)indexPath;
// 返回 菜单的 某个列中某个行的 title
- (NSString *)menuView:(CSDropdownMenu *)menuView titleForRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;
// 返回 菜单的 某个列中某个行的 imageName
- (NSString *)menuView:(CSDropdownMenu *)menuView imageNameForRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;
// 返回 菜单的 某个列中某个行的 descTitle
- (NSString *)menuView:(CSDropdownMenu *)menuView detailTextForRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;

/**
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menuView:(CSDropdownMenu *)menuView numberOfItemsInRow:(NSInteger)row column:(NSInteger)column;
/**
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menuView:(CSDropdownMenu *)menuView titleForItemsInRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;
// 当有column列 row 行 item项 image
- (NSString *)menuView:(CSDropdownMenu *)menuView imageNameForItemsInRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;
//
- (NSString *)menuView:(CSDropdownMenu *)menuView detailTextForItemsInRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;

@end

@protocol CSDropdownMenuDelegate <NSObject>
/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)menuView:(CSDropdownMenu *)menuView didSelectRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;
/**
 *  return nil if you don't want to user select specified indexpath
 *  optional
 */
- (NSIndexPath *)menuView:(CSDropdownMenu *)menuView willSelectRowAtIndexPath:(CSDropdownMenuIndexPath *)indexPath;

@end



@interface CSDropdownMenu : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <CSDropdownMenuDataSource> dataSource;
@property (nonatomic, weak) id <CSDropdownMenuDelegate> delegate;

@property (nonatomic, assign) CSMenuSegmentStyle segmentType;






@end











































































