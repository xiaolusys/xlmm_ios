//
//  JMPopLogistcsCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopLogistcsCell.h"
#import "Masonry.h"
#import "MMClass.h"

@interface JMPopLogistcsCell ()

@property (nonatomic,strong) UILabel *nameLabel;



@end

@implementation JMPopLogistcsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {

    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
//    UIImageView *selecImage = [UIImageView new];
//    [self.contentView addSubview:selecImage];
//    self.selecImage = selecImage;
    kWeakSelf
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
//    [self.selecImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.contentView).offset(-10);
//        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
//    }];
//    
//    
    

}


- (void)configWithModel:(JMPopLogistcsModel *)model {
    
    self.nameLabel.text = model.name;

}


@end






















