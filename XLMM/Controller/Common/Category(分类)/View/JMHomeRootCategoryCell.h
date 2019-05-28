//
//  JMHomeRootCategoryCell.h
//  XLMM
//
//  Created by zhang on 16/9/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMHomeRootCategoryCell : UITableViewCell

@property (nonatomic, copy) NSString *nameString;

- (void)configName:(NSString *)nameString Index:(NSInteger)index SelectedIndex:(NSInteger)selectedIndex;


@end
