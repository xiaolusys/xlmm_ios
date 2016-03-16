//
//  TixianTableViewCell.m
//  XLMM
//
//  Created by younishijie on 16/1/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TixianTableViewCell.h"
#import "UIColor+RGBColor.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "NSString+DeleteT.h"



@implementation TixianTableViewCell{
    TixianModel *cancelModel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillModel:(TixianModel *)model{
    
    NSString *string = [NSString dateDeleteT:model.created];
    
    
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
}

- (void)cancelButtonClicked:(UIButton *)button{
    NSLog(@"quxiao");
    NSLog(@"model id = %@", cancelModel.ID);
    
        NSLog(@"取消");
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/cashout/cancal_cashout", Root_URL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //  http://192.168.1.31:9000/rest/v1/cashout
        
        NSLog(@"url = %@", string);
        NSDictionary *paramters = @{@"id":cancelModel.ID};
        NSLog(@"paramters = %@", paramters);
        [manager POST:string parameters:paramters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"response = %@", responseObject);
                  if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alertView show];
                  } else if ([[responseObject objectForKey:@"code"] integerValue] == 0){
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alertView show];
                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  
              }];
        
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end