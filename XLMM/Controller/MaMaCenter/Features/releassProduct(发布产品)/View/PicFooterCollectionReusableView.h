//
//  PicFooterCollectionReusableView.h
//  XLMM
//
//  Created by 张迎 on 16/1/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicFooterCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *statisticsView;

@property (weak, nonatomic) IBOutlet UIButton *savePhotoBtn;
@property (nonatomic, assign)NSInteger sectionNum;

@property (nonatomic, strong) UIButton *seeButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;


@end
