//
//  CartTableCellTableViewCell.h
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCartModel;

@protocol CartViewDelegate <NSObject>

@required

- (void)reduceNumber:(ShoppingCartModel*)model;
- (void)addNumber:(ShoppingCartModel*)model;
- (void)deleteCartView:(ShoppingCartModel*)model;
- (void)buyOneGood;


@end

@interface CartTableCellTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CartViewDelegate>delegate;

@property (strong, nonatomic)ShoppingCartModel *cartModel;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
- (IBAction)reduceBtn:(id)sender;
- (IBAction)addBtn:(id)sender;
- (IBAction)deleteBtn:(id)sender;


@end
