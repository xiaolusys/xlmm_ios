//
//  ProductSelectionListCell.h
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaMaSelectProduct;

@class ProductSelectionListCell;

@protocol ProductSelectionListCellDelegate <NSObject>
- (void)productSelectionListBtnClick:(ProductSelectionListCell *)cell
                                 btn:(UIButton *)btn;
@end

@interface ProductSelectionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIButton *addBtnClick;


//代理对象
@property (nonatomic, strong) id<ProductSelectionListCellDelegate>delegate;

- (IBAction)addPdtOrDeleteAction:(id)sender;

- (void)fillCell:(MaMaSelectProduct *)product;
@end
