//
//  ReBuyTableViewCell.h
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCartsModel;

@protocol ReBuyCartViewDelegate <NSObject>

@required

- (void)reBuyAddCarts:(NewCartsModel*)model;


@end

@interface ReBuyTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ReBuyCartViewDelegate>delegate;


@property (strong, nonatomic)NewCartsModel *cartModel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *reBuyButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *deleateLine;

- (IBAction)reBuyClicked:(id)sender;

@end
