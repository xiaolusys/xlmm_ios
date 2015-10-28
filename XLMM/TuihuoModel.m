//
//  TuihuoModel.m
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TuihuoModel.h"

@implementation TuihuoModel

- (NSString *)description{
    NSString *string = [NSString stringWithFormat:@"%ld\n%@\n%@\n%ld\n%ld\n%ld\n%ld\n%@\n%ld\n%@\n%ld\n%@\n%@\n%@\n%.1f\n%.1f\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%d\n%d\n%ld\n%ld\n%.1f\n%@\n\n",
                        self.ID,
                        self.url,
                        self.refund_no,
                        self.trade_id,
                        self.order_id,
                        self.buyer_id,
                        self.item_id,
                        self.title,
                        self.sku_id,
                        self.sku_name,
                        self.refund_num,
                        self.buyer_nick,
                        self.mobile,
                        self.phone,
                        self.total_fee,
                        self.payment,
                        self.created,
                        self.company_name,
                        self.sid,
                        self.reason,
                        self.pic_path,
                        self.desc,
                        self.feedback,
                        self.has_good_return,
                        self.has_good_return,
                        self.good_status,
                        self.status,
                        self.refund_fee,
                        self.status_display];
    
    return string;
}

@end
