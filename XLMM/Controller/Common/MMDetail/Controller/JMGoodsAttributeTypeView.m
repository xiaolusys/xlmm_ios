//
//  JMGoodsAttributeTypeView.m
//  XLMM
//
//  Created by zhang on 16/8/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsAttributeTypeView.h"
#import "MMClass.h"

@implementation JMGoodsAttributeTypeView

-(instancetype)initWithFrame:(CGRect)frame DataArray:(NSArray *)dataArray GoodsTypeName:(NSString *)goodsTypeName {
    if (self == [super initWithFrame:frame]) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        titleLabel.text = goodsTypeName;
        [self addSubview:titleLabel];
//        
//        kWeakSelf
//        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf).offset(10);
//            make.centerY.equalTo(weakSelf.mas_centerY);
//        }];
        
        
        BOOL isLineReturn = NO;
        CGFloat upX = 15;
        CGFloat upY = 40;
        for (int i = 0; i< dataArray.count; i++) {
            NSString *str = [dataArray objectAtIndex:i] ;
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [str sizeWithAttributes:dic];
            //NSLog(@"%f",size.height);
            if (upX > (self.frame.size.width - 20 - size.width - 35)) {
                
                isLineReturn = YES;
                upX = 15;
                upY += 30;
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
            
            [self addSubview:btn];
            btn.tag = 1 + i;
            [btn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
            upX += size.width + 40;
            
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
        
        upY +=30;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, upY+10, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lineGrayColor];
        [self addSubview:line];
        
        self.height = upY + 10.;
//        self.selectIndex = -1;

        
        
    }
    return self;
}




-(void)touchbtn:(UIButton *)button {

//    NSInteger index = button.tag - 100;
//    if (button.selected == NO) {
//        
//        self.selectIndex = (int)button.tag - 100;
////        button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
//        button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//    }else {
////        self.selectIndex = -1;
////        button.selected = NO;
////        button.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
////        button.backgroundColor = [UIColor countLabelColor];
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(composeAttrubuteTypeView:Index:)]) {
        [_delegate composeAttrubuteTypeView:self Index:button.tag];
    }
    
    
}




@end













































































