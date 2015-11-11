//
//  HistoryCartsView.m
//  XLMM
//
//  Created by younishijie on 15/11/11.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "HistoryCartsView.h"
#import "UIColor+RGBColor.h"

@implementation HistoryCartsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
       NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HistoryCartsView" owner:nil options:nil];
        NSLog(@"views = %@", views);
        self = [views objectAtIndex:0];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor;
    
}


@end
