//
//  YouHuiQuanViewController.h
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHQModel;
@protocol YouhuiquanDelegate <NSObject>


- (void)updateYouhuiquanWithmodel:(YHQModel *)model;

@end


@interface YouHuiQuanViewController : UIViewController{
    
}

@property (assign, nonatomic)BOOL isSelectedYHQ;
@property (nonatomic, copy) NSString *selectedModelID;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *buyongBUtton;
- (IBAction)buyongClicked:(id)sender;

@property (assign, nonatomic) NSInteger payment;




@property (assign, nonatomic) id <YouhuiquanDelegate> delegate;


@end