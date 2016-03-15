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
@class NewCartsModel;

@protocol CartViewDelegate <NSObject>

@required

- (void)reduceNumber:(NewCartsModel*)model;
- (void)addNumber:(NewCartsModel*)model;
- (void)deleteCartView:(NewCartsModel*)model;
- (void)buyOneGood;

@end

@interface CartTableCellTableViewCell1 : UITableViewCell

@property (weak, nonatomic) id<CartViewDelegate>delegate;

@property (strong, nonatomic)NewCartsModel *cartModel;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
- (IBAction)reduceBtn:(id)sender;
- (IBAction)addBtn:(id)sender;


@end
