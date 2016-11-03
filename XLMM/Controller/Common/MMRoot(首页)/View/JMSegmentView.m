//
//  JMSegmentView.m
//  XLMM
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMSegmentView.h"
#import "HMSegmentedControl.h"
#import "JMCountDownView.h"

@interface JMSegmentView ()<UIScrollViewDelegate> {
    NSArray *_controllersArray;
    NSArray *_urlArray;

    BOOL isCreateSegment;
}

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, strong) UIView *segmentView;



@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *Label1;

@property (nonatomic, strong) JMCountDownView *countDownView;

@end

@implementation JMSegmentView

- (void)setTimeArray:(NSArray *)timeArray {
    _timeArray = timeArray;
    [self countTime:1];
}

-(NSString*)spaceFormatTimeString:(NSString*)timeString{
    if ([NSString isStringEmpty:timeString]) {
        return nil;
    }else {
        NSMutableString *ms = [NSMutableString stringWithString:timeString];
        NSRange range = {10,1};
        [ms replaceCharactersInRange:range withString:@" "];
        return ms;
    }
}
- (instancetype)initWithFrame:(CGRect)frame Controllers:(NSArray *)controller TitleArray:(NSArray *)titleArray PageController:(UIViewController *)pageVC {
    if (self == [super initWithFrame:frame]) {
        _controllersArray = controller;
        _urlArray = @[@"yesterday",@"today",@"tomorrow"];
        self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        [self addSubview:self.segmentView];
        
        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        self.segmentedControl.sectionTitles = titleArray;
        self.segmentedControl.selectedSegmentIndex = 1;
        self.segmentedControl.backgroundColor = [UIColor whiteColor];
        self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13.]};
        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:14.]};
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        __weak typeof(self) weakSelf = self;
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
//            [weakSelf.segmentScrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * index, 80, SCREENWIDTH, SCREENHEIGHT) animated:YES];
        }];
        [self.segmentView addSubview:self.segmentedControl];
        
        // == 倒计时 == //
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 45)];
        [self.segmentView addSubview:timeView];
        
        self.Label1 = [UILabel new];
        [timeView addSubview:self.Label1];
        self.Label1.text = @"距本场结束";
        self.Label1.textColor = [UIColor dingfanxiangqingColor];
        self.Label1.font = [UIFont systemFontOfSize:14.];
        
        self.timeLabel = [UILabel new];
        [timeView addSubview:self.timeLabel];
        self.timeLabel.textColor = [UIColor buttonTitleColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14.];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];;
        lineView.backgroundColor = [UIColor lineGrayColor];
        [timeView addSubview:lineView];
        
        [self.Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeView.mas_centerY);
            make.centerX.equalTo(timeView.mas_centerX).offset(-60);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeView.mas_centerY);
            make.left.equalTo(weakSelf.Label1.mas_right);
        }];
        
        [MobClick event:_urlArray[1]];
        
        self.segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, frame.size.height - 64)];
        self.segmentScrollView.pagingEnabled = YES;
        self.segmentScrollView.showsHorizontalScrollIndicator = NO;
        self.segmentScrollView.contentSize = CGSizeMake(SCREENWIDTH * controller.count, frame.size.height - 64);
        self.segmentScrollView.delegate = self;
//        [self.segmentScrollView scrollRectToVisible:CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT) animated:NO];
        [self addSubview:self.segmentScrollView];
        self.segmentScrollView.contentOffset = CGPointMake(self.segmentedControl.selectedSegmentIndex * SCREENWIDTH, 0);
        
        for (int i = 0 ; i < controller.count; i++) {
            UIViewController *control = controller[i];
            [self.segmentScrollView addSubview:control.view];
            control.view.frame = CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, frame.size.height - 80); // 整理高度 - 64 --> 是否需要添加???
            [pageVC addChildViewController:control];
            [control didMoveToParentViewController:pageVC];
            
        }

    }
    return self;
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger page = segmentedControl.selectedSegmentIndex;
    self.segmentScrollView.contentOffset = CGPointMake(page * SCREENWIDTH, 0);
    [MobClick event:_urlArray[page]];
    [self countTime:page];
    
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld", (long)segmentedControl.selectedSegmentIndex);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    [MobClick event:_urlArray[page]];
    [self countTime:page];
    
}


- (void)countTime:(NSInteger)num {
    if (num == 2) {
        self.Label1.text = @"距本场开始";
    }else {
        self.Label1.text = @"距本场结束";
    }
    NSString *todayTimeString = self.timeArray[num];
    if ([NSString isStringEmpty:todayTimeString]) {
        //        self.timerLabel.text = @"即将上架";
        self.timeLabel.text = @"--:--:--:--";
    }else {
        kWeakSelf
        
        NSString *endTime = [self spaceFormatTimeString:todayTimeString];
        self.countDownView = [JMCountDownView shareCountDown];
        //    [JMCountDownView countDownWithCurrentTime:endTime];
        [self.countDownView initWithCountDownTime:endTime];
        //    self.countDownView.delegate = self;
        self.countDownView.timeBlock = ^(NSString *timeString) {
            weakSelf.timeLabel.text = timeString;
        };
    }
    
    
}





@end






























































































