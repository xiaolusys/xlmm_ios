//
//  TixianTableViewCell.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianTableViewCell.h"



@implementation TixianTableViewCell{
    TixianModel *cancelModel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillModel:(TixianModel *)model{
    
    NSString *string = [NSString jm_deleteTimeWithT:model.created];
    
    
    self.timeLabel.text = string;
    self.infoLabel.text = model.get_status_display;
    self.jineLabel.text= [NSString stringWithFormat:@"%.2f", model.value_money];
    if ([model.get_status_display isEqualToString:@"待审核"]) {
        self.cancelButton.layer.cornerRadius = 15;
        self.cancelButton.layer.borderWidth = 0.5;
        self.cancelButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelModel = model;
        self.cancelButton.hidden = NO;
        
    } else {
        self.cancelButton.hidden = YES;
    }
    
    self.tixianTypeLabel.text = model.get_cash_out_type_display;
    
   
    
    
    
}

- (void)cancelButtonClicked:(UIButton *)button{
    NSLog(@"model id = %@", cancelModel.ID);
        NSLog(@"取消");
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cancal_cashout", Root_URL];
        //  http://192.168.1.31:9000/rest/v1/cashout
        NSDictionary *paramters = @{@"id":cancelModel.ID};
        NSLog(@"paramters = %@", paramters);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:paramters WithSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else if ([[responseObject objectForKey:@"code"] integerValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





































