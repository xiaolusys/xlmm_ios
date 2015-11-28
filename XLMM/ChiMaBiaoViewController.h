//
//  ChiMaBiaoViewController.h
//  XLMM
//
//  Created by younishijie on 15/11/10.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChiMaBiaoViewController : UIViewController

@property (nonatomic, strong) NSArray *sizeArray;
@property (weak, nonatomic) IBOutlet UILabel *head1Label;
@property (weak, nonatomic) IBOutlet UILabel *head2Llabel;

@property (weak, nonatomic) IBOutlet UILabel *noHaveLabel;

@property (nonatomic, assign, getter=isChildClothing) BOOL childClothing;


@end
