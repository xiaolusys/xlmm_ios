//
//  JMHomeYesterdayController.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeYesterdayController.h"


@interface JMHomeYesterdayController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JMHomeYesterdayController {
    NSString *_nextPageUrl;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];



}



//- (NSString *)urlString {
//    return [NSString stringWithFormat:@"%@/rest/v2/modelproducts/yesterday?page=1&page_size=10",Root_URL];
//}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentSelectedIndexChange:) name:@"JMHomeYesterdayController" object:nil];
//    [MobClick beginLogPageView:@"JMHomeYesterdayController"];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [MobClick endLogPageView:@"JMHomeYesterdayController"];
//    [super viewWillDisappear:animated];
//}





@end































































