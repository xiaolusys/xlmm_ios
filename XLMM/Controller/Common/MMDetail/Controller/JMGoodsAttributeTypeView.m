//
//  JMGoodsAttributeTypeView.m
//  XLMM
//
//  Created by zhang on 16/8/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsAttributeTypeView.h"

@implementation JMGoodsAttributeTypeView

-(instancetype)initWithFrame:(CGRect)frame DataArray:(NSArray *)dataArray GoodsTypeName:(NSString *)goodsTypeName {
    if (self == [super initWithFrame:frame]) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        titleLabel.text = goodsTypeName;
        [self addSubview:titleLabel];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(55, 0, SCREENWIDTH - 60, frame.size.height)];
        [self addSubview:contentView];
        
        BOOL isLineReturn = NO;
        CGFloat upX = 10;
        CGFloat upY = 10;
        for (int i = 0; i< dataArray.count; i++) {
            NSString *str = [dataArray objectAtIndex:i];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [str sizeWithAttributes:dic];
            //NSLog(@"%f",size.height);
            if (upX > (self.frame.size.width - 20 - size.width - 30 - 40)) {
                isLineReturn = YES;
                upX = 10;
                upY += 40;
            }
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(upX, upY, size.width + 30,25);
            //            [btn setBackgroundColor:[UIColor countLabelColor]];
            [btn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:[dataArray objectAtIndex:i] forState:UIControlStateNormal];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            //            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.borderWidth = 0.5;
            
            [contentView addSubview:btn];
            btn.tag = 1 + i;
            [btn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
            upX += size.width + 45;
            
            if (btn.tag == 1) {
                //                btn.selected = YES;
                btn.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
                [btn setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
            }else {
                //                btn.selected = NO;
                btn.layer.borderColor = [UIColor buttonTitleColor].CGColor;
                [btn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
            };
            
            //            if (btn.tag == 100) {
            //                btn.selected = YES;
            //                btn.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
            //            }
        }
        upY += 40;
        //        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, upY+10, self.frame.size.width, 0.5)];
        //        line.backgroundColor = [UIColor lineGrayColor];
        //        [self addSubview:line];
        self.height = upY + 10.;
        //        self.selectIndex = -1;
        contentView.frame = CGRectMake(55, 0, SCREENWIDTH - 60, self.height);
        
    }
    return self;
}

-(void)touchbtn:(UIButton *)button {
//    NSInteger index = button.tag - 100;
    if (_delegate && [_delegate respondsToSelector:@selector(composeAttrubuteTypeView:Index:)]) {
        [_delegate composeAttrubuteTypeView:self Index:button.tag];
    }
}

@end













































































