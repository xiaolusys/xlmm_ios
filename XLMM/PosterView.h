//
//  PosterView.h
//  XLMM
//
//  Created by younishijie on 15/7/30.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosterView : UIView
@property (strong, nonatomic) IBOutlet UIView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end
