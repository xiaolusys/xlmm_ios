//
//  JMSelectionGoodsInfoController.m
//  XLMM
//
//  Created by zhang on 16/8/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsInfoPopView.h"
#import "JMGoodsAttributeTypeView.h"
#import "JMBuyNumberView.h"


//#define TableViewH SCREENHEIGHT * 0.6


@interface JMGoodsInfoPopView ()<JMGoodsAttributeTypeViewDelegate> {
    
    NSMutableDictionary *_stockDict;
    NSMutableArray *_imageArray;
    NSMutableArray *_goodsAllArray;
    NSArray *_goodsArr;
    
    NSInteger _stockValue;
    NSString *_choiseGoodsColor;
    NSString *_choiseGoodsSize;
    NSString *_goodsTitleString;     // 商品名称
    NSString *_skuColorString;       // 颜色
    NSString *_skuSizeString;        // 尺码
    NSInteger _sizeSelectedIndex;    // 当前选中尺码按钮下标
    NSInteger _colorSelectedIndex;   // 当前选中尺码按钮下标
    
    NSInteger _goodsNum;
    NSInteger _goodsColorID;
    NSInteger _goodsSizeID;
//    BOOL _isGoodsEnough;             // 判断商品是否有库存
    NSInteger _defaultChoiseSize;
}



@property (nonatomic, strong) NSMutableArray *goodsColorArray;

@property (nonatomic, strong) NSMutableArray *goodsSizeArray;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameTitle;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;

@end

@implementation JMGoodsInfoPopView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        _goodsNum = 1;
//        _isGoodsEnough = NO;
        
        [self topView];
        _stockDict = [NSMutableDictionary dictionary];
        _imageArray = [NSMutableArray array];
        _goodsAllArray = [NSMutableArray array];
        
        UIView *bottomView = [UIView new];
        bottomView.frame = CGRectMake(0, self.mj_h - 60, SCREENWIDTH, 60);
        [self addSubview:bottomView];
        bottomView.layer.borderWidth = 1.;
        bottomView.layer.borderColor = [UIColor lineGrayColor].CGColor;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:button];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16.];
        button.layer.cornerRadius = 20.;
        [button addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.sureButton = button;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.centerX.equalTo(bottomView.mas_centerX);
            make.width.mas_equalTo(@(SCREENWIDTH - 30));
            make.height.mas_equalTo(@40);
        }];
        
        //        [self createHeaderView];
        
        
        
        
    }
    return self;
}

- (NSMutableArray *)goodsColorArray {
    if (!_goodsColorArray) {
        _goodsColorArray = [NSMutableArray array];
    }
    return _goodsColorArray;
}
- (NSMutableArray *)goodsSizeArray {
    if (!_goodsSizeArray) {
        _goodsSizeArray = [NSMutableArray array];
    }
    return _goodsSizeArray;
}

- (void)topView {
    UIView *headerView = [UIView new];
    [self addSubview:headerView];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, 100);
    headerView.layer.borderWidth = 1.;
    headerView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    //    self.tableView.tableHeaderView = headerView;
    
    UIImageView *iconImage = [UIImageView new];
    iconImage.backgroundColor = [UIColor orangeColor];
    [headerView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    UILabel *goodsTitle = [UILabel new];
    [headerView addSubview:goodsTitle];
    goodsTitle.font = [UIFont systemFontOfSize:15.];
    goodsTitle.textColor = [UIColor buttonTitleColor];
    goodsTitle.numberOfLines = 2;
    self.nameTitle = goodsTitle;
    
    UILabel *PriceLabel = [UILabel new];
    [headerView addSubview:PriceLabel];
    PriceLabel.font = [UIFont systemFontOfSize:32.];
    PriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.PriceLabel = PriceLabel;
    
    UILabel *curreLabel = [UILabel new];
    [headerView addSubview:curreLabel];
    curreLabel.text = @"/";
    curreLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *oldPriceLabel = [UILabel new];
    [headerView addSubview:oldPriceLabel];
    oldPriceLabel.font = [UIFont systemFontOfSize:11.];
    oldPriceLabel.textColor = [UIColor dingfanxiangqingColor];
    self.oldPriceLabel = oldPriceLabel;
    
    UILabel *deletLine = [UILabel new];
    [headerView addSubview:deletLine];
    deletLine.backgroundColor = [UIColor titleDarkGrayColor];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(headerView).offset(10);
        make.width.height.mas_equalTo(@80);
    }];
    
    [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(15);
        make.left.equalTo(iconImage.mas_right).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 100);
    }];
    
    [PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    
    [curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(PriceLabel.mas_bottom).offset(-5);
        make.left.equalTo(PriceLabel.mas_right);
        make.height.mas_equalTo(@13);
    }];
    
    [oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(curreLabel.mas_right).offset(2);
        //        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
        make.centerY.equalTo(curreLabel.mas_centerY);
    }];
    
    [deletLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oldPriceLabel.mas_centerY);
        make.left.right.equalTo(oldPriceLabel);
        make.height.mas_equalTo(@1);
    }];
    
    
    
}

- (void)initTypeSizeView:(NSArray *)goodsArray TitleString:(NSString *)titleString {
    _goodsArr = [NSArray array];
    _goodsArr = goodsArray;
    _goodsTitleString = titleString;
    NSMutableDictionary *sizeDict = [NSMutableDictionary dictionary];
    for (NSDictionary *goodsDic in goodsArray) {
        NSArray *sizeArr = goodsDic[@"sku_items"];
        sizeDict = [NSMutableDictionary dictionary];
        for (NSDictionary *sizeDic in sizeArr) {
            [sizeDict setObject:sizeDic forKey:sizeDic[@"name"]];  // --> 需要展示价格 把整个字典包含进去
        }
        [_imageArray addObject:goodsDic[@"product_img"]];
        [_stockDict setObject:sizeDict forKey:goodsDic[@"name"]];
    }
    
    NSMutableDictionary *colorDict = [NSMutableDictionary dictionary];
    
    for (NSDictionary *colorDic in goodsArray) {
        NSArray *sizeArr = colorDic[@"sku_items"];
        for (NSDictionary *sizeDic in sizeArr) {
            [colorDict setObject:colorDic[@"name"] forKey:@"color"];
            [colorDict setObject:sizeDic[@"name"] forKey:@"size"];
            [colorDict setObject:sizeDic[@"free_num"] forKey:@"stock"];
            
            [_goodsAllArray addObject:colorDict];
            colorDict = [NSMutableDictionary dictionary];
        }
    }
    
    for (NSDictionary *dic in _goodsAllArray) {
        if (![self.goodsColorArray containsObject:dic[@"color"]]) {
            [self.goodsColorArray addObject:dic[@"color"]];
        }
        if (![self.goodsSizeArray containsObject:dic[@"size"]]) {
            [self.goodsSizeArray addObject:dic[@"size"]];
        }
        
    }
    
    self.nameTitle.text = _goodsTitleString;
    
    UIScrollView *headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, self.mj_h - 160)];
    //    self.tableView.tableHeaderView = headerView;
    [self addSubview:headerView];
    
    // == 购买数量视图 == //
    self.buyNumView = [[JMBuyNumberView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    [headerView addSubview:self.buyNumView];
    JMBuyNumberView * __weak buyWeakSelf = self.buyNumView;
    self.buyNumView.numblock = ^(NSInteger index) {
        if (index == 100) {
            NSInteger count = [buyWeakSelf.numLabel.text integerValue];
            if (count > 1) {
                buyWeakSelf.numLabel.text = [NSString stringWithFormat:@"%ld",count - 1];
                _goodsNum -= 1;
            }else {
                return ;
            }
        }else {
            NSInteger count = [buyWeakSelf.numLabel.text integerValue];
            if (count < _stockValue) { //  == >>  这里是商品的数量
                buyWeakSelf.numLabel.text = [NSString stringWithFormat:@"%ld",count + 1];
                _goodsNum += 1;
            }else {
                return ;
            }
        }
    };
    
    if (self.goodsColorArray.count == 1 && self.goodsSizeArray.count == 1) {
        self.buyNumView = [[JMBuyNumberView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        headerView.contentSize = CGSizeMake(SCREENWIDTH, 60);
    }else {
        self.colorView = [[JMGoodsAttributeTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) DataArray:self.goodsColorArray GoodsTypeName:@"颜色"];
        self.colorView.delegate = self;
        [headerView addSubview:self.colorView];
        self.colorView.frame = CGRectMake(0, 0, SCREENWIDTH, self.colorView.height);
        CGFloat colorViewH = self.colorView.frame.size.height;
        
        self.sizeView = [[JMGoodsAttributeTypeView alloc] initWithFrame:CGRectMake(0, colorViewH, SCREENWIDTH, 50) DataArray:self.goodsSizeArray GoodsTypeName:@"尺码"];
        self.sizeView.delegate = self;
        [headerView addSubview:self.sizeView];
        self.sizeView.frame = CGRectMake(0, colorViewH, SCREENWIDTH, self.sizeView.height);
        CGFloat sizeViewH = self.sizeView.frame.size.height;
        
        self.buyNumView.frame = CGRectMake(0, sizeViewH + self.sizeView.frame.origin.y, SCREENWIDTH, 60);
        //        CGFloat heanderViewH = headerView.frame.size.height;
        CGFloat H = sizeViewH + self.sizeView.frame.origin.y + 60;
        headerView.contentSize = CGSizeMake(SCREENWIDTH, H);
        
        
    }
    
    _choiseGoodsColor = self.goodsColorArray[0];
    NSString *size = self.goodsSizeArray[0];
    NSDictionary *sizeDic = [_stockDict objectForKey:_choiseGoodsColor];
    NSDictionary *sizeD = sizeDic[size];
    // --> 这里展示价格 与初始颜色与尺寸
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[sizeD[@"agent_price"] floatValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"%.2f",[sizeD[@"std_sale_price"] floatValue]];
    _stockValue =  [sizeD[@"free_num"] integerValue];
    _sizeSelectedIndex = 1;
//    [self reloadTypeButton:sizeDic SizeArr:self.goodsSizeArray TypeView:self.sizeView];
    
    NSString *newImageUrl = [_imageArray objectAtIndex:0]; // [NSMutableString stringWithString:[_imageArray objectAtIndex:0]];
//    [newImageUrl appendString:@"?"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    NSDictionary *colorD = _goodsArr[0];
    
    _goodsColorID = [colorD[@"product_id"] integerValue];
    _goodsSizeID = [sizeD[@"sku_id"] integerValue];
    _skuColorString = colorD[@"name"];
    _skuSizeString = sizeD[@"name"];
    [self reloadTypeButton:sizeDic SizeArr:self.goodsSizeArray TypeView:self.sizeView];
    self.nameTitle.text = [NSString stringWithFormat:@"%@(%@ %@)",_goodsTitleString,_skuColorString,_skuSizeString];
    NSLog(@"_goodsColorID ----- > %ld, _goodsSizeID ---- > %ld",_goodsColorID,_goodsSizeID);
}
- (void)composeAttrubuteTypeView:(JMGoodsAttributeTypeView *)typeView Index:(NSInteger)index {
    
    if ([typeView isEqual:self.colorView]) {
        // 点击了颜色按钮
        for (int i = 1; i <= self.goodsColorArray.count; i++) {
            UIButton *button = (UIButton *)[self.colorView viewWithTag:i];
            if (i == index) {
                //                button.selected = YES;
                button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
                [button setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
                
            }else {
                //                button.selected = NO;
                button.layer.borderColor = [UIColor buttonTitleColor].CGColor;
                [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
            }
        }
        
        NSString *newImageUrl = [_imageArray objectAtIndex:index - 1]; // [NSMutableString stringWithString:[_imageArray objectAtIndex:index - 1]];
//        [newImageUrl appendString:@"?"];
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
        
        // -- > 在这里面给颜色 赋值
        NSDictionary *colirD = _goodsArr[index - 1];
        _goodsColorID = [colirD[@"product_id"] integerValue];
        _choiseGoodsColor = self.goodsColorArray[index - 1];
        _skuColorString = _choiseGoodsColor;
        NSDictionary *sizeDic = [_stockDict objectForKey:_choiseGoodsColor];
        [self reloadTypeButton:sizeDic SizeArr:self.goodsSizeArray TypeView:self.sizeView];
        //        _skuSizeString = _isGoodsEnough ? @"库存不足" : _skuSizeString;
        self.nameTitle.text = [NSString stringWithFormat:@"%@(%@ %@)",_goodsTitleString,_skuColorString,_skuSizeString];
        
    }else if ([typeView isEqual:self.sizeView]) {
        NSDictionary *sizeDic = [_stockDict objectForKey:_choiseGoodsColor];
        for (int i = 1; i <= self.goodsSizeArray.count; i++) {
            UIButton *button = (UIButton *)[self.sizeView viewWithTag:i];
            if (i == index) {
                _sizeSelectedIndex = i;
                button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
                [button setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
            }else {
                NSString *size = self.goodsSizeArray[i - 1];
                NSDictionary *sizeD = sizeDic[size];
                NSInteger count =  [sizeD[@"free_num"] integerValue];
                if (count == 0) {
                    button.enabled = NO;
                    button.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
                    [button setTitleColor:[UIColor titleDarkGrayColor] forState:UIControlStateNormal];
                }else {
                    button.layer.borderColor = [UIColor buttonTitleColor].CGColor;
                    [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
                }
            }
        }
        // -- > 在这里面给尺码 赋值
        //        NSString *color = self.goodsColorArray[self.colorView.tag - 1];
        NSString *size = self.goodsSizeArray[index - 1];
        NSDictionary *sizeD = sizeDic[size];
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[sizeD[@"agent_price"] floatValue]];
        self.oldPriceLabel.text = [NSString stringWithFormat:@"%.2f",[sizeD[@"std_sale_price"] floatValue]];
        _goodsSizeID = [sizeD[@"sku_id"] integerValue];
        _stockValue =  [sizeD[@"free_num"] integerValue];
        _skuSizeString = sizeD[@"name"];
        self.nameTitle.text = [NSString stringWithFormat:@"%@(%@ %@)",_goodsTitleString,_skuColorString,_skuSizeString];
        
        NSLog(@"_goodsColorID ----- > %ld, _goodsSizeID ---- > %ld",_goodsColorID,_goodsSizeID);
        
    }else {
        
    }
    
}
- (void)reloadTypeButton:(NSDictionary *)sizeDic SizeArr:(NSArray *)sizeArr TypeView:(JMGoodsAttributeTypeView *)typeView {
    NSInteger sizeCountNum = sizeArr.count;
    NSMutableArray *countArr = [NSMutableArray array];
    for (int i = 1 ; i <= sizeCountNum; i++) {
        NSString *size = sizeArr[i - 1];
        NSDictionary *sizeDict = [sizeDic objectForKey:size];
        NSInteger count = [sizeDict[@"free_num"] integerValue];
        UIButton *button = (UIButton *)[self.sizeView viewWithTag:i];
        if (count == 0) {
            button.enabled = NO;
            button.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
            [button setTitleColor:[UIColor titleDarkGrayColor] forState:UIControlStateNormal];
        }else {
            button.enabled = YES;
            button.layer.borderColor = [UIColor buttonTitleColor].CGColor;
            [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
            [countArr addObject:@(i)];
        }
    }
    if (countArr.count != 0) {
        BOOL isbool = [countArr containsObject:[NSNumber numberWithInteger:_sizeSelectedIndex]];
        NSInteger maxIndex = [[countArr firstObject] integerValue];
        //    NSInteger maxIndex = [[countArr valueForKeyPath:@"@max.intValue"] integerValue]; // -- > 取出数组中最大值
        if (maxIndex >= _sizeSelectedIndex) {
            _sizeSelectedIndex = maxIndex;
        }else {
            _sizeSelectedIndex = isbool ? _sizeSelectedIndex : maxIndex;
        }
        UIButton *button1 = (UIButton *)[self.sizeView viewWithTag:_sizeSelectedIndex];
        button1.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
        [button1 setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
        NSString *size = sizeArr[_sizeSelectedIndex - 1];
        NSDictionary *sizeDict = [sizeDic objectForKey:size];
        [self fetchSizeDict:sizeDict];
    }else {
        NSString *size = sizeArr[_sizeSelectedIndex - 1];
        NSDictionary *sizeDict = [sizeDic objectForKey:size];
        [self fetchSizeDict:sizeDict];
    }
}
- (void)fetchSizeDict:(NSDictionary *)sizeDict {
    _goodsSizeID = [sizeDict[@"sku_id"] integerValue];
    _stockValue =  [sizeDict[@"free_num"] integerValue];
    _skuSizeString = sizeDict[@"name"];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[sizeDict[@"agent_price"] floatValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"%.2f",[sizeDict[@"std_sale_price"] floatValue]];
}

- (void)sureButtonClick:(UIButton *)button {
    button.enabled = NO;
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    paramer[@"item_id"] = [NSString stringWithFormat:@"%ld",(long)_goodsColorID];
    paramer[@"sku_id"] = [NSString stringWithFormat:@"%ld",(long)_goodsSizeID];
    paramer[@"num"] = [NSString stringWithFormat:@"%ld",(long)_goodsNum];
    if (_delegate && [_delegate respondsToSelector:@selector(composeGoodsInfoView:AttrubuteDic:)]) {
        [_delegate composeGoodsInfoView:self AttrubuteDic:paramer];
    }
    
}
@end



































































































