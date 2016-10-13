//
//  JMPushSaveModel.h
//  XLMM
//
//  Created by zhang on 16/10/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "Tool_FMDBModel.h"

@interface JMPushSaveModel : Tool_FMDBModel

@property (nonatomic, strong) NSNumber *pushID;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, copy) NSString *currentTime;


@end
