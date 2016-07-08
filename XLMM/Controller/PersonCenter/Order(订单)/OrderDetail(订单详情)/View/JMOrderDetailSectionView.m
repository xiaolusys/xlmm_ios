//
//  JMOrderDetailSectionView.m
//  XLMM
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMOrderDetailSectionView.h"
#import "Masonry.h"
#import "MMClass.h"

@interface JMOrderDetailSectionView ()

@property (nonatomic, strong) UILabel *packageLabel;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JMOrderDetailSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor sectionViewColor];
        [self setUpTopUI];
    }
    return self;
}
- (void)setIndexSection:(NSInteger)indexSection {
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    _indexSection = indexSection;
    self.packageLabel.text = [NSString stringWithFormat:@"包裹%@",arr[indexSection]];
}
- (void)setPackAgeStr:(NSString *)packAgeStr {
    _packAgeStr = packAgeStr;
    self.descLabel.text = packAgeStr;
}
- (void)setUpTopUI {
    UIView *baseView = [UIView new];
    [self addSubview:baseView];
    baseView.frame = self.frame;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [baseView addGestureRecognizer:tap];
    
    UILabel *packageLabel = [UILabel new];
    [baseView addSubview:packageLabel];
    packageLabel.font = [UIFont systemFontOfSize:13.];
    packageLabel.textColor = [UIColor timeLabelColor];
    self.packageLabel = packageLabel;
    
    UILabel *descLabel = [UILabel new];
    [baseView addSubview:descLabel];
    self.descLabel = descLabel;
    self.descLabel.font = [UIFont systemFontOfSize:13.];
    self.descLabel.textColor = [UIColor timeLabelColor];
    
    [self.packageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView).offset(10);
        make.centerY.equalTo(baseView.mas_centerY);
    }];

    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(baseView).offset(-10);
        make.centerY.equalTo(baseView.mas_centerY);
    }];
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    tapView.tag = 100 + _indexSection;
    if (_delegate && [_delegate respondsToSelector:@selector(composeSectionView:Index:)]) {
        [_delegate composeSectionView:self Index:tapView.tag];
    }
}


/**
 *  NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
 UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
 view.frame = CGRectMake(0, 0, SCREENWIDTH, 35);
 view.backgroundColor = [UIColor sectionViewColor];
 UILabel *label = [UILabel new];
 [view addSubview:label];
 [label mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(view).offset(10);
 make.centerY.equalTo(view.mas_centerY);
 }];
 label.font = [UIFont systemFontOfSize:13.];
 label.textColor = [UIColor timeLabelColor];
 label.text = [NSString stringWithFormat:@"包裹%@ :",arr[section]];
 
 [view addTarget:self action:@selector(packageClick:) forControlEvents:UIControlEventTouchUpInside];
 view.tag = 100 + section;
 UILabel *descLabel = [UILabel new];
 [view addSubview:descLabel];
 [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 make.right.equalTo(view).offset(-10);
 make.centerY.equalTo(view.mas_centerY);
 }];
 descLabel.font = [UIFont systemFontOfSize:13.];
 descLabel.textColor = [UIColor timeLabelColor];
 NSArray *arr1 = _logisticsArr;
 JMPackAgeModel *packageModel = [[JMPackAgeModel alloc] init];
 packageModel = arr1[0];
 descLabel.text = packageModel.assign_status_display;
 
 return view;

 */
@end
















































