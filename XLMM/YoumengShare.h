//
//  YoumengShare.h
//  XLMM
//
//  Created by 张迎 on 15/12/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoumengShare : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *shareBackView;

@property (weak, nonatomic) IBOutlet UIButton *weixinShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendsShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqshareBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqspaceShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboShareBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancleShareBtn;

@end
