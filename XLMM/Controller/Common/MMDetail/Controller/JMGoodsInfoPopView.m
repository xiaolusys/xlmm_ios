//
//  JMSelectionGoodsInfoController.m
//  XLMM
//
//  Created by zhang on 16/8/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsInfoPopView.h"
#import "MMClass.h"
#import "JMGoodsInfoModel.h"
#import "JMgoodsSizeModel.h"
#import "JMGoodsAttributeTypeView.h"
#import "JMBuyNumberView.h"


#define TableViewH SCREENHEIGHT * 0.6


@interface JMGoodsInfoPopView ()<JMGoodsAttributeTypeViewDelegate>


@property (nonatomic, strong) NSMutableArray *goodsColorArray;

@property (nonatomic, strong) NSMutableArray *goodsSizeArray;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameTitle;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;

//@property (nonatomic, strong) NSMutableDictionary *goodsAttributeDic;

@end

@implementation JMGoodsInfoPopView {
    NSMutableArray *_sizeArray;
    NSMutableArray *_colorArray;
    NSMutableDictionary *_stockDict;
    NSMutableArray *_imageArray;
    NSArray *goodsAllArray;
    
    NSInteger _stockValue;
    NSString *_choiseGoodsColor;
    NSString *_choiseGoodsSize;
    
    NSInteger _goodsNum;
    NSInteger _goodsColorID;
    NSInteger _goodsSizeID;
    
    NSInteger _defaultChoiseSize;
}
//- (NSMutableDictionary *)goodsInfoArray {
//    if (_goodsAttributeDic == nil) {
//        _goodsAttributeDic = [NSMutableDictionary dictionary];
//    }
//    return _goodsAttributeDic;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        _goodsNum = 1;
        
        
        [self topView];
        
        
        
        _sizeArray = [NSMutableArray array];
        _colorArray = [NSMutableArray array];
        _stockDict = [NSMutableDictionary dictionary];
        _imageArray = [NSMutableArray array];
        
        
        UIView *bottomView = [UIView new];
        bottomView.frame = CGRectMake(0, TableViewH - 60, SCREENWIDTH, 60);
        [self addSubview:bottomView];
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

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.backgroundColor = [UIColor whiteColor];
//    
//    
//    
//    
//    [self createTableView];
//    
//    
//    
//}
//- (void)setGoodsInfoArray:(NSMutableArray *)goodsInfoArray {
//    _goodsInfoArray = goodsInfoArray;
//    
//    
//    
////    [self.tableView reloadData];
//}
/**
 *  po _stockDict
 {
 120 =     {
 "\U7070\U8272" = 14;
 "\U9ed1\U8272" = 15;
 };
 130 =     {
 "\U7070\U8272" = 14;
 "\U9ed1\U8272" = 15;
 };
 140 =     {
 "\U7070\U8272" = 14;
 "\U9ed1\U8272" = 15;
 };
 150 =     {
 "\U7070\U8272" = 14;
 "\U9ed1\U8272" = 15;
 };
 160 =     {
 "\U7070\U8272" = 14;
 "\U9ed1\U8272" = 15;
 };
 "\U7070\U8272" =     {
 120 = 15;
 130 = 14;
 140 = 15;
 150 = 14;
 160 = 13;
 };
 "\U9ed1\U8272" =     {
 120 = 15;
 130 = 14;
 140 = 15;
 150 = 14;
 160 = 13;
 };
 }

 */
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
//- (void)createTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, SCREENWIDTH , TableViewH - 150) style:UITableViewStylePlain];
//    
//    [self.view addSubview:self.tableView];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//}

- (void)topView {
    UIView *headerView = [UIView new];
    [self addSubview:headerView];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, 90);
    
//    self.tableView.tableHeaderView = headerView;
    
    UIImageView *iconImage = [UIImageView new];
    iconImage.backgroundColor = [UIColor orangeColor];
    [headerView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *goodsTitle = [UILabel new];
    [headerView addSubview:goodsTitle];
    self.nameTitle = goodsTitle;
    
    UILabel *PriceLabel = [UILabel new];
    [headerView addSubview:PriceLabel];
    PriceLabel.font = [UIFont boldSystemFontOfSize:14.];
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
        make.left.top.equalTo(headerView).offset(10);
        make.width.height.mas_equalTo(@70);
    }];
    
    [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(10);
        make.left.equalTo(iconImage.mas_right).offset(15);
    }];
    
    [PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(15);
        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
    }];
    
    [curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
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
    goodsAllArray = [NSArray array];
    goodsAllArray = goodsArray;
    NSMutableDictionary *sizeDict = [NSMutableDictionary dictionary];
    for (NSDictionary *goodsDic in goodsArray) {
        JMGoodsInfoModel *infoModel = [JMGoodsInfoModel mj_objectWithKeyValues:goodsDic];
        [self.goodsColorArray addObject:infoModel];
        NSArray *sizeArr = goodsDic[@"sku_items"];
        NSDictionary *sizeDic = [NSDictionary dictionary];
        sizeDict = [NSMutableDictionary dictionary];
        for (sizeDic in sizeArr) {
            
            [sizeDict setObject:sizeDic forKey:sizeDic[@"name"]];  // --> 需要展示价格 把整个字典包含进去
            
            JMgoodsSizeModel *sizeModel = [JMgoodsSizeModel mj_objectWithKeyValues:sizeDic];
            [self.goodsSizeArray addObject:sizeModel];

            [_sizeArray addObject:sizeDic[@"name"]];
            int count = 0;
            for (NSString *str in _sizeArray) {
                if ([sizeDic[@"name"] isEqualToString:str]) {
                    count ++;
                    if (count > 1) {
                        [_sizeArray removeObjectAtIndex:(_sizeArray.count - 1)];
                    }
                }else {
                    
                }
            }
        }
        [_colorArray addObject:goodsDic[@"name"]];
        [_imageArray addObject:goodsDic[@"product_img"]];
        [_stockDict setObject:sizeDict forKey:goodsDic[@"name"]];
        
    }
    
    self.nameTitle.text = titleString;
    
    UIScrollView *headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREENWIDTH, TableViewH - 150)];
//    self.tableView.tableHeaderView = headerView;
    [self addSubview:headerView];
    
    // == 购买数量视图 == //
    self.buyNumView = [[JMBuyNumberView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    [headerView addSubview:self.buyNumView];
    
    kWeakSelf
    self.buyNumView.numblock = ^(NSInteger index) {
        if (index == 100) {
            NSInteger count = [weakSelf.buyNumView.numLabel.text integerValue];
            if (count > 1) {
                weakSelf.buyNumView.numLabel.text = [NSString stringWithFormat:@"%ld",count - 1];
                _goodsNum -= 1;
            }else {
                return ;
            }
        }else {
            NSInteger count = [weakSelf.buyNumView.numLabel.text integerValue];
            if (count < _stockValue) { //  == >>  这里是商品的数量
                weakSelf.buyNumView.numLabel.text = [NSString stringWithFormat:@"%ld",count + 1];
                _goodsNum += 1;
            }else {
                return ;
            }
        }
    };

    
    self.colorView = [[JMGoodsAttributeTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) DataArray:_colorArray GoodsTypeName:@"颜色分类"];
    self.colorView.delegate = self;
    [headerView addSubview:self.colorView];
    self.colorView.frame = CGRectMake(0, 0, SCREENWIDTH, self.colorView.height);
    CGFloat colorViewH = self.colorView.frame.size.height;
    
    self.sizeView = [[JMGoodsAttributeTypeView alloc] initWithFrame:CGRectMake(0, colorViewH, SCREENWIDTH, 50) DataArray:_sizeArray GoodsTypeName:@"尺码"];
    self.sizeView.delegate = self;
    [headerView addSubview:self.sizeView];
    self.sizeView.frame = CGRectMake(0, colorViewH, SCREENWIDTH, self.sizeView.height);
    CGFloat sizeViewH = self.sizeView.frame.size.height;
    
    self.buyNumView.frame = CGRectMake(0, sizeViewH + self.sizeView.frame.origin.y, SCREENWIDTH, 50);
    CGFloat heanderViewH = headerView.frame.size.height;
    headerView.contentSize = CGSizeMake(SCREENWIDTH, heanderViewH + headerView.frame.origin.y);
    
    
    self.colorView.selectIndex = 0;
    _defaultChoiseSize = 0;
    
    NSDictionary *colorDict = goodsArray[self.colorView.selectIndex];
    NSString *color = [_colorArray objectAtIndex:self.colorView.selectIndex];
    NSDictionary *dic = [_stockDict objectForKey:color];
    
    [self reloadTypeButton:dic DataArray:_sizeArray GoodsAttributeTypeView:self.sizeView];
    [self resumeBtn:_colorArray GoodsAttributeTypeView:self.colorView];
    
    _stockValue = 0;
    _choiseGoodsColor = color;
    _choiseGoodsSize = @"";
    
    NSMutableString *newImageUrl = [NSMutableString stringWithString:[_imageArray objectAtIndex:self.colorView.selectIndex]];
    [newImageUrl appendString:@"?"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
    
    
//    self.sizeView.selectIndex = _defaultChoiseSize;
    
    NSString *size = [_sizeArray objectAtIndex:_defaultChoiseSize];
    _defaultChoiseSize = 0;
    NSDictionary *stockDic = [[_stockDict objectForKey:color] objectForKey:size];
    _stockValue = [stockDic[@"free_num"] integerValue];
    _choiseGoodsColor = color;
    _choiseGoodsSize = size;
    
    [self reloadTypeButton:[_stockDict objectForKey:color] DataArray:_sizeArray GoodsAttributeTypeView:self.sizeView];
    [self resumeBtn:_sizeArray GoodsAttributeTypeView:self.sizeView];
    
    
    _goodsColorID = [colorDict[@"product_id"] integerValue];
    _goodsSizeID = [stockDic[@"sku_id"] integerValue];
}
- (void)composeAttrubuteTypeView:(JMGoodsAttributeTypeView *)typeView Index:(NSInteger)index {
    
    if ([typeView isEqual:self.colorView]) {
        NSDictionary *colorDic = goodsAllArray[self.colorView.selectIndex];
        NSString *color = [_colorArray objectAtIndex:self.colorView.selectIndex];
        NSDictionary *dic = [_stockDict objectForKey:color];
        _goodsColorID = [colorDic[@"product_id"] integerValue];
        
        [self reloadTypeButton:dic DataArray:_sizeArray GoodsAttributeTypeView:self.colorView];
        [self resumeBtn:_colorArray GoodsAttributeTypeView:self.colorView];
        
        _stockValue = 0;
        _choiseGoodsColor = color;
        _choiseGoodsSize = @"";
        
        NSMutableString *newImageUrl = [NSMutableString stringWithString:[_imageArray objectAtIndex:self.colorView.selectIndex]];
        [newImageUrl appendString:@"?"];
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
        
        
    }else if ([typeView isEqual:self.sizeView]) {
        NSString *size = [_sizeArray objectAtIndex:self.sizeView.selectIndex];
        NSString *color = [_colorArray objectAtIndex:self.colorView.selectIndex];
        
        NSDictionary *stockDic = [[_stockDict objectForKey:color] objectForKey:size];
        _goodsSizeID = [stockDic[@"sku_id"] integerValue];
        
        _stockValue = [stockDic[@"free_num"] integerValue];
        _choiseGoodsColor = color;
        _choiseGoodsSize = size;
        
        
        [self reloadTypeButton:[_stockDict objectForKey:color] DataArray:_sizeArray GoodsAttributeTypeView:self.sizeView];
        [self resumeBtn:_sizeArray GoodsAttributeTypeView:self.sizeView];
    }else {
    }
}
-(void)resumeBtn:(NSArray *)typeArr GoodsAttributeTypeView:(JMGoodsAttributeTypeView *)typeView
{
    for (int i = 0; i< typeArr.count; i++) {
        UIButton *btn =(UIButton *) [typeView viewWithTag:100+i];
        if (typeView.selectIndex == i) {
            btn.selected = YES;
//            btn.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
            [btn setBackgroundColor:[UIColor buttonEnabledBackgroundColor]];
        }else {
            btn.selected = NO;
            [btn setBackgroundColor:[UIColor countLabelColor]];
        }
    }
}

- (void)reloadTypeButton:(NSDictionary *)typeDic DataArray:(NSArray *)dataArray GoodsAttributeTypeView:(JMGoodsAttributeTypeView *)typeView {
    
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dic = [typeDic objectForKey:[dataArray objectAtIndex:i]];
        int count = [dic[@"free_num"] intValue];
        
        self.PriceLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"agent_price"] floatValue]];
        self.oldPriceLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"std_sale_price"] floatValue]];
        
        
        UIButton *btn =(UIButton *)[typeView viewWithTag:100+i];

        //库存为零 不可点击
        if (count == 0) {
            _defaultChoiseSize ++;
            btn.enabled = NO;
            [btn setTitleColor:[UIColor titleDarkGrayColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor countLabelColor]];
        }else
        {
            btn.enabled = YES;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor countLabelColor]];
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (typeView.selectIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor buttonEnabledBackgroundColor]];
            
        }
    }

}

- (void)sureButtonClick:(UIButton *)button {
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    paramer[@"item_id"] = [NSString stringWithFormat:@"%ld",_goodsColorID];
    paramer[@"sku_id"] = [NSString stringWithFormat:@"%ld",_goodsSizeID];
    paramer[@"num"] = [NSString stringWithFormat:@"%ld",_goodsNum];
    
    
//    if (self.block) {
//        self.block(self.goodsAttributeDic);
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(composeGoodsInfoView:AttrubuteDic:)]) {
        [_delegate composeGoodsInfoView:self AttrubuteDic:paramer];
    }
    
}

@end









































































































