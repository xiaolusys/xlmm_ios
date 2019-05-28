//
//  JMAutoLoopPageView.h
//  XLMM
//
//  Created by zhang on 16/9/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,JMAtuoLoopScrollViewStyle) {
    JMAutoLoopScrollStyleHorizontal = 0,             // 水平滚动
    JMAutoLoopScrollStyleVertical = 1 << 0,          // 垂直滚动
};

typedef NS_ENUM(NSInteger,JMAtuoLoopScrollViewDirectionStyle) {
    JMAutoLoopScrollStyleAscending,                 // 递增滚动
    JMAutoLoopScrollStyleDescending,                // 递减滚动
};

@class JMAutoLoopPageView;

@protocol JMAutoLoopPageViewDataSource <NSObject>

@optional
/**
 *  定义item个数
 *  @return item个数
 */
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView;
/**
 *  自定义cell
 *
 *  @param cell     注册的cell
 *  @param index
 *  @param pageView 配置cell
 */
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView;
/**
 *  返回自定义cell的标识符
 *
 *  @param index    index 对用的indentifier,不实现则使用默认indentifier
 *
 *  @return         cell标识符
 */
- (NSString *)cellIndentifierWithIndex:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView;


@end

@protocol JMAutoLoopPageViewDelegate <NSObject>

@optional
/**
 *  滚动的index
 *
 *  @param pageView
 *  @param index    index
 */
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidScrollToIndex:(NSUInteger)index;
/**
 *  选择的index
 *
 *  @param pageView
 *  @param index    index
 */
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidSelectedIndex:(NSUInteger)index;

@end



@interface JMAutoLoopPageView : UIView

/**
 *  设置代理
 */
@property (nonatomic, weak) id<JMAutoLoopPageViewDataSource> dataSource;
@property (nonatomic, weak) id<JMAutoLoopPageViewDelegate> delegate;

/**
 *  滚动方向 --> 左右 | 上下
 */
@property (nonatomic, assign) JMAtuoLoopScrollViewStyle scrollStyle;
/**
 *  自然滚动方向 --> 正向 | 反向
 */
@property (nonatomic, assign) JMAtuoLoopScrollViewDirectionStyle scrollDirectionStyle;

/**
 *  是否分页,默认YES
 */
@property (nonatomic, assign) BOOL pageEnable;
/**
 *  只有一个cell时是否能滚动,默认YES
 */
@property (nonatomic, assign) BOOL scrollForSingleCount;
/**
 *  当前页面
 */
@property (nonatomic, assign, readonly) NSUInteger currentIndex;
/**
 *  是否自动滚动,默认为NO
 */
@property (nonatomic, assign) BOOL atuoLoopScroll;
/**
 *  设置自定滚动时间间隔,默认5秒
 */
@property (nonatomic, assign) CGFloat autoScrollInterVal;
/**
 *  是否用户操作滚动,默认YES
 */
@property (nonatomic, assign) BOOL scrollUserEnable;
/**
 *  是否无限滚动
 */
@property (nonatomic, assign) BOOL scrollFuture;
// 是否添加pageControl
@property (nonatomic, assign) BOOL isCreatePageControl;



/**
 *  通过class，identifier注册cell（UICollectionViewCell）
 *
 *  @param cellClass  clas
 *  @param identifier identifier
 */
- (void)registerCellWithClass:(Class)cellClass identifier:(NSString *)identifier;

/**
 *  通过class注册cell，使用默认的identifier（UICollectionViewCell）
 *
 *  @param cellClass clas
 */
- (void)registerCellWithClass:(Class)cellClass;

/**
 *  通过nib，identifier注册cell（UICollectionViewCell）
 *
 *  @param cellNib    nib
 *  @param identifier identifier
 */
- (void)registerCellWithNib:(UINib *)cellNib identifier:(NSString *)identifier;

/**
 *  通过nib注册cell，使用默认的identifier（UICollectionViewCell）
 *
 *  @param cellNib nib
 */
- (void)registerCellWithNib:(UINib *)cellNib;

/**
 *  重新加载数据
 */
- (void)reloadData;

/**
 *  滚到index
 *
 *  @param index    index
 *  @param animated 直接滚还是动画着滚
 */
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)endAutoScroll;










@end
















































































































































