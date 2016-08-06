//
//  AddressViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
@class AddressViewController;

@protocol PurchaseAddressDelegate <NSObject>

@required

- (void)addressView:(AddressViewController *)addressVC model:(AddressModel *)model;

@end

@interface AddressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)addButtonClicked:(id)sender;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) id <PurchaseAddressDelegate>delegate;


@property (nonatomic, assign) BOOL isButtonSelected;
@property (nonatomic, copy) NSString *addressID;

@end
