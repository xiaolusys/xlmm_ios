//
//  PicHeaderCollectionReusableView.h
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *propagandaLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *turnsImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desheight;

//@property (weak, nonatomic) IBOutlet UIView *saveYetView;
//@property (nonatomic, strong) UILabel *saveYetLabel;
//@property (nonatomic, strong) UIImageView *saveDownloadImage;


@end
