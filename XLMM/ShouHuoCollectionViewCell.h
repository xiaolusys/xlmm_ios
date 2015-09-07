//
//  ShouHuoCollectionViewCell.h
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouHuoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *xiadanshijianLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myimageView;
@property (weak, nonatomic) IBOutlet UIButton *querenButton;
@property (weak, nonatomic) IBOutlet UILabel *biaohaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jineLabel;

- (IBAction)querenClicked:(id)sender;




@end
