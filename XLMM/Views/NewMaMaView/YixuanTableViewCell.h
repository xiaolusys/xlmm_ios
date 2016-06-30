//
//  YixuanTableViewCell.h
//  XLMM
//
//  Created by younishijie on 16/3/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAlreadyChooseModel.h"


@class YixuanTableViewCell;

@protocol ProductxiajiaDelegate <NSObject>
- (void)productxiajiaBtnClick:(YixuanTableViewCell *)cell
                                 btn:(UIButton *)btn;

@end


@interface YixuanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stdPriceLabel;
- (IBAction)xiajiaClicked:(id)sender;

@property (nonatomic, strong) NSString *pdtID;

@property (nonatomic, strong) JMAlreadyChooseModel *model;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) id<ProductxiajiaDelegate>delegate;

- (void)fillData:(JMAlreadyChooseModel *)model;

@end
