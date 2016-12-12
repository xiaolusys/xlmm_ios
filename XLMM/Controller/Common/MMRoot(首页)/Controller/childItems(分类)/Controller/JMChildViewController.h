//
//  JMChildViewController.h
//  XLMM
//
//  Created by zhang on 16/12/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMChildViewController : UIViewController


@property (nonatomic, copy) NSString *categoryCid;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *categoryUrlString;
- (NSArray *)setSegmentArr;
- (NSArray *)setUrlData;





@end
