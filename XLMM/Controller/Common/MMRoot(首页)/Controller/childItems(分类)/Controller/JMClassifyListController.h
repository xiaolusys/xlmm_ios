//
//  JMClassifyListController.h
//  XLMM
//
//  Created by zhang on 16/8/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMClassifyListController : UIViewController

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *emptyTitle;

- (void)refresh;

@end
