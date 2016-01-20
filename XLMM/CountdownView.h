//
//  CountdownView.h
//  XLMM
//
//  Created by younishijie on 16/1/20.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView {
    UILabel *number3Label;
    UILabel *number6Label;
    UILabel *number9Label;
    UILabel *number12Label;
    UIImageView *bgImageView;
    UILabel *topLabel;
    UILabel *timeLabel;
    UILabel *infoLabel;
    UIView *bigCircleView;
    UIView *littleCircleView;
    
    
}

- (void)updateTimeView;

@end
