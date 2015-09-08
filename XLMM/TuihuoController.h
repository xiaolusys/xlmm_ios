//
//  TuihuoController.h
//  XLMM
//
//  Created by younishijie on 15/9/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuihuoController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField1;
@property (weak, nonatomic) IBOutlet UITextField *myTextField2;

- (IBAction)commit:(id)sender;


- (IBAction)selectClicked:(id)sender;

- (IBAction)querenClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end
