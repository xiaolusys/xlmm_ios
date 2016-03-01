//
//  ProductSelectionListCell2.h
//  XLMM
//
//  Created by younishijie on 16/3/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MaMaSelectProduct;

@class ProductSelectionListCell2;

@protocol ProductSelectionListCell2Delegate <NSObject>
- (void)productSelectionListBtnClick:(ProductSelectionListCell2 *)cell
                                 btn:(UIButton *)btn;
- (void)productSelectionShareClick:(ProductSelectionListCell2 *)cell btn:(UIButton *)btn;

@end

@interface ProductSelectionListCell2 : UITableViewCell



@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIButton *addBtnClick;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stdPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *backPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumberLabel;

@property (strong, nonatomic) NSString *pdtID;
//Model对象
@property (strong, nonatomic) MaMaSelectProduct *pdtModel;

//代理对象
@property (nonatomic, strong) id<ProductSelectionListCell2Delegate>delegate;


- (IBAction)xiajiaClicked:(id)sender;
- (IBAction)shareClicked:(id)sender;
- (void)fillMyChoice:(MaMaSelectProduct *)product;











@end
