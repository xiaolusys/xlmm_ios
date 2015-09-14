//
//  MMCartsView.h
//  XLMM
//
//  Created by younishijie on 15/9/14.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCartsView : UIView

+(instancetype)sharedCartsView;
@property (strong, nonatomic) IBOutlet MMCartsView *cartsView;
@property (weak, nonatomic) IBOutlet UIImageView *myBackImageView;
@property (weak, nonatomic) IBOutlet UIView *myLabelView;
@property (weak, nonatomic) IBOutlet UILabel *myNumberView;


@end
