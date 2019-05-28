//
//  JMSearchViewController.h
//  XLMM
//
//  Created by zhang on 17/1/9.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSearchViewController;
typedef void(^JMDidSearchBlock)(JMSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText); // 点击搜索时调用的blcok

@interface JMSearchViewController : UIViewController


@property (nonatomic, copy) NSArray *historySearchs;
@property (nonatomic, weak) UISearchBar *searchBar;

// 点击搜索时调用的blcok
@property (nonatomic, copy) JMDidSearchBlock didSearchBlock;







/*      
    historySearchs 历史搜索数组
 
 */
+ (JMSearchViewController *)searchViewControllerWithHistorySearchs:(NSArray<NSString *> *)historySearchs searchBarPlaceHolder:(NSString *)placeHolder didSearchBlock:(JMDidSearchBlock)block;
+ (JMSearchViewController *)searchViewControllerWithHistorySearchs:(NSArray<NSString *> *)historySearchs searchBarPlaceholder:(NSString *)placeHolder;


@end
