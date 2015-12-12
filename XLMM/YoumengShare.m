//
//  YoumengShare.m
//  XLMM
//
//  Created by 张迎 on 15/12/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "YoumengShare.h"
#import "MMClass.h"

@implementation YoumengShare

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YoumengShare" owner:nil options:nil]objectAtIndex:0];
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0];
        self.backView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
        self.shareBackView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
//         self.frame = CGRectMake(SCREENHEIGHT, 0, SCREENWIDTH, SCREENHEIGHT);
        
        self.cancleShareBtn.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        self.cancleShareBtn.layer.cornerRadius = 20;
        self.cancleShareBtn.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
        self.cancleShareBtn.layer.borderWidth = 1.0;
        
        self.shareBackView.layer.cornerRadius = 20;
    }
    
    return self;
}


@end
