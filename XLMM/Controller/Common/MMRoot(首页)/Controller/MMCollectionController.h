//
//  MMCollectionController.h
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCollectionController : UIViewController
{
    
}

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign, getter=isChildClothing) BOOL childClothing;

@property (nonatomic, copy) NSString * activityId;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ;


@end
