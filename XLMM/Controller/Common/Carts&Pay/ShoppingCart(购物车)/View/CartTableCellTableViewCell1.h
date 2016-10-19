//
//  CartTableCellTableViewCell1.h
//  XLMM
//
//  Created by younishijie on 15/10/29.
//  Copyright © 2015年 上海己美. All rights reserved.
//

//
//  CartTableCellTableViewCell.h
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartListModel;
@protocol CartViewDelegate <NSObject>

@required

- (void)reduceNumber:(CartListModel*)model;
- (void)addNumber:(CartListModel*)model;
- (void)deleteCartView:(CartListModel*)model;
- (void)buyOneGood;
- (void)tapClick:(CartListModel*)model;

@end

@interface CartTableCellTableViewCell1 : UITableViewCell

@property (weak, nonatomic) id<CartViewDelegate>delegate;

@property (strong, nonatomic)CartListModel *cartModel;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleateLine;
- (IBAction)reduceBtn:(id)sender;
- (IBAction)addBtn:(id)sender;


@end
