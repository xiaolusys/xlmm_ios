//
//  JMSelectAddressView.m
//  XLMM
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMSelectAddressView.h"

@interface JMSelectAddressView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIView *_contentView;
    UIPickerView *_pickView;
    NSArray *_allArr;
    NSMutableArray *_provinceAry;   // 省
    NSMutableArray *_cityAry;       // 市
    NSMutableArray *_disAry;        // 区
    
    NSInteger _proIndex;            //选择省的索引
    NSInteger _cityIndex;           //选择市的索引
    NSInteger _distrIndex;          //选择区的索引
    
    NSString *_provinceStr;         // 选择的省
    NSString *_cityStr;             // 选择的市
    NSString *_disStr;              // 选择的区
    
}



@end



@implementation JMSelectAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _provinceAry = [NSMutableArray array];
        _cityAry = [NSMutableArray array];
        _disAry = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 260)];
        [self addSubview:_contentView];
        
        UIView *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        tool.backgroundColor = [UIColor sectionViewColor];
        [_contentView addSubview:tool];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancel.frame = CGRectMake(0, 0, 60, 40);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:cancel];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureBtn.frame = CGRectMake(SCREENWIDTH - 60, 0, 60, 40);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:sureBtn];
        
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, _contentView.mj_h - 40)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor sectionViewColor];
        [_contentView addSubview:_pickView];
        
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *addressPath = [docPath stringByAppendingPathComponent:@"addressInfo.json"];
        
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:addressPath];
        if (isExist == YES) {
            NSData *data = [NSData dataWithContentsOfFile:addressPath];
            _provinceAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        }else {
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"areasAddress" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:jsonPath];
            _provinceAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //        provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:jsonPath];
        }
//        for (NSDictionary *dict in _allArr) {
//            [_provinceAry addObject:dict[@"name"]];
//        }
        
       
        
        _cityAry = [[_provinceAry objectAtIndex:0] objectForKey:@"childs"];
        _disAry = [[_cityAry objectAtIndex:0] objectForKey:@"childs"];
        
        _provinceStr = [[_provinceAry objectAtIndex:0] objectForKey:@"name"];
        _cityStr = [[_cityAry objectAtIndex:0] objectForKey:@"name"];
        
        if (_disAry.count > 0) {
            _disStr = [[_disAry objectAtIndex:0] objectForKey:@"name"];
        } else{
            _disStr = @"";
        }
        
//        NSDictionary *dict = _allArr[_proIndex];
//        NSArray *cityArr = dict[@"childs"];
//        for (NSDictionary *dic in cityArr) {
//            [_cityAry addObject:dic[@"name"]];
//            NSArray *disArr = dic[@"childs"];
//            [_pickView reloadComponent:1];
//            [_pickView selectRow:0 inComponent:1 animated:YES];
//            for (NSDictionary *di in disArr) {
//                [_disAry addObject:di[@"name"]];
//                [_pickView reloadComponent:2];
//                [_pickView selectRow:0 inComponent:2 animated:YES];
//            }
//            
//        }
        

        
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return _provinceAry.count;
            break;
        case 1:
            return _cityAry.count;
            break;
        case 2:
            return _disAry.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[_provinceAry objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [[_cityAry objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if ([_disAry count] > 0) {
                return [[_disAry objectAtIndex:row] objectForKey:@"name"];
                break;
            }
        default:
            return  @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            _cityAry = [[_provinceAry objectAtIndex:row] objectForKey:@"childs"];
            [_pickView reloadComponent:1];
            [_pickView selectRow:0 inComponent:1 animated:YES];
            
            _disAry = [[_cityAry objectAtIndex:0] objectForKey:@"childs"];
            [_pickView reloadComponent:2];
            [_pickView selectRow:0 inComponent:2 animated:YES];
            
            _provinceStr = [[_provinceAry objectAtIndex:row] objectForKey:@"name"];
            if (_cityAry.count > 0) {
                _cityStr = [[_cityAry objectAtIndex:0] objectForKey:@"name"];
            }else {
                _cityStr = @"";
            }
            
            if ([_disAry count] > 0) {
                _disStr = [[_disAry objectAtIndex:0] objectForKey:@"name"];
            } else{
                _disStr = @"";
            }
            NSLog(@"%@", _provinceStr);
            
            break;
        case 1:
            _disAry = [[_cityAry objectAtIndex:row] objectForKey:@"childs"];
            [_pickView reloadComponent:2];
            [_pickView selectRow:0 inComponent:2 animated:YES];
            
            _cityStr = [[_cityAry objectAtIndex:row] objectForKey:@"name"];
            if ([_disAry count] > 0) {
                _disStr = [[_disAry objectAtIndex:0] objectForKey:@"name"];
            } else{
                _disStr = @"";
            }
            break;
        case 2:
            if ([_disAry count] > 0) {
                _disStr = [[_disAry objectAtIndex:row] objectForKey:@"name"];
            } else{
                _disStr = @"";
            }
            break;
        default:
            break;
    }
}
//自定义每个pickerView的label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont systemFontOfSize:14.]];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//取消
- (void)cancelBtnClick {
    [self hide];
    
}
//选择
- (void)sureBtnClick {
    if (self.block) {
        self.block(_provinceStr,_cityStr,_disStr);
    }
    [self hide];
}

- (void)show {
    [JMKeyWindow addSubview:self];
    __weak typeof (UIView *)blockView = _contentView;
    __block int blockH = SCREENHEIGHT;
    __block int bjH = 260;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect BJf = blockView.frame;
        BJf.origin.y = blockH - bjH;
        blockView.frame = BJf;
    }];

}

- (void)hide {
    __weak typeof (UIView *)blockView = _contentView;
    __weak typeof(self)blockself = self;
    __block int blockH = SCREENHEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect BJf = blockView.frame;
        BJf.origin.y = blockH;
        blockView.frame = BJf;
//        blockself.alpha = 0.1;
    }completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_contentView.frame, point)) {
        [self hide];
    }
}

@end


































































