//
//  JMPageScrollController.h
//  XLMM
//
//  Created by zhang on 17/2/24.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMPageScrollControllerDelegate <NSObject>

- (void)scrollViewIscanScroll:(UIScrollView *)scrollView;

@end

@interface JMPageScrollController : UIViewController

@property (nonatomic, weak) id <JMPageScrollControllerDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
