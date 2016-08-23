//
//  JMHomeTomorrowController.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeTomorrowController.h"

@interface JMHomeTomorrowController ()

@end

@implementation JMHomeTomorrowController

- (void)viewDidLoad {
    [super viewDidLoad];


}


- (NSString *)urlString {
    return [NSString stringWithFormat:@"%@/rest/v2/modelproducts/tomorrow?page=1&page_size=10",Root_URL];
}




@end

































































































































