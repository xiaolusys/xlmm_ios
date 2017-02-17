//
//  JMHomeSegmentCell.m
//  XLMM
//
//  Created by zhang on 17/2/16.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMHomeSegmentCell.h"
#import "JMHomeHourController.h"


NSString *const JMHomeSegmentCellIdentifier = @"JMHomeSegmentCellIdentifier";

@interface JMHomeSegmentCell () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllArr;

@end

@implementation JMHomeSegmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45)];
//        self.segmentScrollView.pagingEnabled = YES;
//        self.segmentScrollView.delegate = self;
//        self.segmentScrollView.scrollEnabled = NO;
//        [self addSubview:self.segmentScrollView];
//        
//        self.controllArr = [NSMutableArray array];
//        for (int i = 0; i < 12; i ++) {
//            
//            JMHomeHourController *hourVC = [[JMHomeHourController alloc] init];
//            hourVC.view.frame = CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, self.mj_h);
//            [self.segmentScrollView addSubview:hourVC.view];
//            [self.controllArr addObject:hourVC];
//            
//        }
//        self.segmentScrollView.contentSize = CGSizeMake(self.controllArr.count * SCREENWIDTH, 0);
        
        
    }
    return self;
}

//- (void)setCurrentIndex:(NSInteger)currentIndex {
//    _currentIndex = currentIndex;
//    
//    self.segmentScrollView.contentOffset = CGPointMake(currentIndex * SCREENWIDTH, 0);
//    
//    
//    
//    
//}
//
//- (void)setDataSource:(NSMutableArray *)dataSource {
//    _dataSource = dataSource;
//    JMHomeHourController *control = self.controllArr[self.currentIndex];
//    control.dataSource = dataSource;
//    
//    
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
////    NSLog(@"%@",scrollView);
//    
//}













@end



























































