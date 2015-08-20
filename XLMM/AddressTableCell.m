//
//  AddressTableCell.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddressTableCell.h"
#import "AddAdressViewController.h"

@implementation AddressTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAddress:(id)sender {
    NSLog(@"删除地址");
    [self.delegate deleteAddress:self.addressModel];


}




- (IBAction)modifyAddress:(id)sender {
    NSLog(@"修改地址");
    

    [self.delegate modifyAddress:self.addressModel];
}
@end
