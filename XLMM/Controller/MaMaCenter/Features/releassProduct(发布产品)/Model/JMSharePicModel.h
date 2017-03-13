//
//  SharePicModel.h
//  XLMM
//
//  Created by 张迎 on 16/1/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMSharePicModel : NSObject

@property (nonatomic, strong)NSNumber* piID;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy) NSString *title_content;
@property (nonatomic, copy)NSString* descriptionTitle;
@property (nonatomic, copy)NSString* start_time;
@property (nonatomic, strong)NSNumber* turns_num;
@property (nonatomic, strong)NSArray* pic_arry;
@property (nonatomic, strong)NSNumber* could_share;
@property (nonatomic, assign) BOOL show_qrcode;
@property (nonatomic, strong) NSDictionary *profit;

@property (nonatomic, copy)NSString* save_times;
@property (nonatomic, copy)NSString* share_times;
@property (nonatomic, copy)NSString* sale_category;

@property (nonatomic, assign) CGFloat headerHeight;





@end



/**
 *  
 {
 "could_share" = 1;
 description = "\U3010\U79d2\U51cf\U538b\U84b8\U6c7d\U773c\U7f69\U3011https://m.xiaolumeimei.com/m/44/?next=mall/product/details/25172\n\U82b1\U738b\U773c\U7f69\U4e0d\U4ec5\U81ea\U5df1\U7528\Uff0c\U8212\U7f13\U75b2\U52b3\U3001\U5b89\U7720\Uff0c\U6bcf\U5929\U665a\U4e0a\U7761\U89c9\U524d\U7ed9\U81ea\U5df1\U5b69\U5b50\U8d34\U4e00\U8d34\Uff0c\U7528\U6765\U4fdd\U62a4\U5b69\U5b50\U89c6\U529b\Uff0c\U73b0\U5728\U4e00\U5bb6\U5b50\U90fd\U79bb\U4e0d\U5f00\U82b1\U738b\U84b8\U6c7d\U773c\U7f69\U4e86\Uff01\n";
 id = 5610;
 "pic_arry" =             (
 "http://img.xiaolumeimei.com/nine_pic1484535957241",
 "http://img.xiaolumeimei.com/nine_pic1484535957255",
 "http://img.xiaolumeimei.com/nine_pic1484535957268"
 );
 profit =             {
 max = 37;
 min = 15;
 };
 "sale_category" = 98;
 "save_times" = 85;
 "share_times" = 0;
 "show_qrcode" = 0;
 "start_time" = "2017-01-16T20:30:00";
 title = "\U3010\U79d2\U51cf\U538b\U84b8\U6c7d\U773c\U7f69\U3011https://m.xiaolumeimei.com/m/44/?next=mall/product/details/25172\n\U82b1\U738b\U773c\U7f69\U4e0d\U4ec5\U81ea\U5df1\U7528\Uff0c\U8212\U7f13\U75b2\U52b3\U3001\U5b89\U7720\Uff0c\U6bcf\U5929\U665a\U4e0a\U7761\U89c9\U524d\U7ed9\U81ea\U5df1\U5b69\U5b50\U8d34\U4e00\U8d34\Uff0c\U7528\U6765\U4fdd\U62a4\U5b69\U5b50\U89c6\U529b\Uff0c\U73b0\U5728\U4e00\U5bb6\U5b50\U90fd\U79bb\U4e0d\U5f00\U82b1\U738b\U84b8\U6c7d\U773c\U7f69\U4e86\Uff01\n";
 "title_content" = "01\U670816\U65e5\Uff5c\U7b2c26\U8f6e \U5206\U4eab\U65f6\U95f4\Uff1a20:30";
 "turns_num" = 26;
 }

 
 */
