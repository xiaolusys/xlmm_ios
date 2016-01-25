//
//  ProductSelectionListCell.h
//  XLMM
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductSelectionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;

- (IBAction)addPdtOrDeleteAction:(id)sender;
@end
