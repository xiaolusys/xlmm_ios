//
//  ShenQingTuiHuoController.h
//  XLMM
//
//  Created by younishijie on 15/11/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class PerDingdanModel;
@class JMOrderGoodsModel;

typedef void(^changeBtnBlock) (BOOL btnStatus);
@interface ShenQingTuiHuoController : UIViewController

@property (nonatomic, strong) JMOrderGoodsModel *dingdanModel;
/**
 *  声明block属性
 */
@property (nonatomic,copy) changeBtnBlock changeStatusBlock;
/**
 *  声明调用方法
 */
//- (void) changeStatus:(changeBtnBlock)block;

@property (assign, nonatomic) float refundPrice;
@property (copy, nonatomic) NSString *tid;
@property (copy, nonatomic) NSString *oid;
@property (copy, nonatomic) NSString *status;

@property (nonatomic, strong) UIButton *button;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (weak, nonatomic) IBOutlet UILabel *sizeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containterWidth;
@property (weak, nonatomic) IBOutlet UIView *sendImgesView;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundNumLabel;
- (IBAction)reduceButtonClicked:(id)sender;
- (IBAction)addBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *selectedReason;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
- (IBAction)yuanyinClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
- (IBAction)commitClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIImageView *sendImageView;

@property (weak, nonatomic) IBOutlet UIImageView *sendImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageView3;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton1;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton2;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton3;

- (IBAction)sendImages:(id)sender;


- (IBAction)deleteImageone:(id)sender;

- (IBAction)deleteImageTwo:(id)sender;
- (IBAction)deleteButtonThr:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteImageThree;
/**
 *  显示顶部显示退货选择显示
 */
@property (weak, nonatomic) IBOutlet UIView *topShowRefundView;

@end
