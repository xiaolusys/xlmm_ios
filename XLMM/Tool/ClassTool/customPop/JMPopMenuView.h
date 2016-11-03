//
//  JMPopMenuView.h
//  XLMM
//
//  Created by zhang on 16/8/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class JMPopMenuView;
//
//
//@protocol JMPopMenuViewDelegate <NSObject>
//
//@optional
//- (void)coverDidClickCoverHide:(JMPopMenuView *)cover;
//
//@end

@interface JMPopMenuView : UIView

+ (void)configCustomPopMenuWithFrame:(CGRect)frame ImageArr:(NSArray *)imageArr TitleArr:(NSArray *)titleArr AnchorPoint:(CGPoint)anchorPoint selectedRowIndex:(void(^)(NSInteger index))indexBlock Animation:(BOOL)animation ShowTime:(NSTimeInterval)show hideTime:(NSTimeInterval)hide;

+ (void)hideView;

//@property (nonatomic, weak) id<JMPopMenuViewDelegate> delegate;




@end
