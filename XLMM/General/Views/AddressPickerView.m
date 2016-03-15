//
//  AddressPickerView.m
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddressPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface AddressPickerView()
{
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *countyArray;
}
@end

@implementation AddressPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (id)initWithdelegate:(id <AddressPickerDelegate>)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    if (self) {
        self.addressPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
        self.addressPicker.backgroundColor = [UIColor whiteColor];
       // self.addressPicker.frame = CGRectMake(0, 0, 320, 216);
        [self addSubview:self.addressPicker];
        self.address = [[AddressModel alloc] init];
        self.delegate = delegate;
        self.addressPicker.delegate = self;
        self.addressPicker.dataSource = self;
        provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        cityArray = [[provinceArray objectAtIndex:0] objectForKey:@"cities"];
        NSLog(@"province = %u", (unsigned int)provinceArray.count);
        NSLog(@"city = %u", (unsigned int)cityArray.count);
        
        _address.provinceName = [[provinceArray objectAtIndex:0] objectForKey:@"state"];
        
        NSLog(@"%@", [[provinceArray objectAtIndex:0] objectForKey:@"state"]);

        NSLog(@"%@", self.address.provinceName);

        

        self.address.cityName = [[cityArray objectAtIndex:0] objectForKey:@"city"];
        NSLog(@"%@", [[cityArray objectAtIndex:0] objectForKey:@"city"]);

        NSLog(@"%@", _address.cityName);

        countyArray = [[cityArray objectAtIndex:0] objectForKey:@"areas"];
        if (countyArray.count > 0) {
            self.address.countyName = [countyArray objectAtIndex:0];
        } else{
            self.address.countyName = @"";
        }
        
    }
    return self;

    
}

#pragma mark --PickerViewDelegate--

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return provinceArray.count;
            break;
        case 1:
            return cityArray.count;
            break;
        case 2:
            return countyArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[provinceArray objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[cityArray objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([countyArray count] > 0) {
                return [countyArray objectAtIndex:row];
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
            cityArray = [[provinceArray objectAtIndex:row] objectForKey:@"cities"];
            [self.addressPicker selectRow:0 inComponent:1 animated:YES];
            [self.addressPicker reloadComponent:1];
            
            countyArray = [[cityArray objectAtIndex:0] objectForKey:@"areas"];
            [self.addressPicker selectRow:0 inComponent:2 animated:YES];
            [self.addressPicker reloadComponent:2];
            
            self.address.provinceName = [[provinceArray objectAtIndex:row] objectForKey:@"state"];
            self.address.cityName = [[cityArray objectAtIndex:0] objectForKey:@"city"];
            if ([countyArray count] > 0) {
                self.address.countyName = [countyArray objectAtIndex:0];
            } else{
                self.address.countyName = @"";
            }
            NSLog(@"%@", self.address.provinceName);

            break;
        case 1:
            countyArray = [[cityArray objectAtIndex:row] objectForKey:@"areas"];
            [self.addressPicker selectRow:0 inComponent:2 animated:YES];
            [self.addressPicker reloadComponent:2];
            
            self.address.cityName = [[cityArray objectAtIndex:row] objectForKey:@"city"];
            if ([countyArray count] > 0) {
                self.address.countyName = [countyArray objectAtIndex:0];
            } else{
                self.address.countyName = @"";
            }
            break;
        case 2:
            if ([countyArray count] > 0) {
                self.address.countyName = [countyArray objectAtIndex:row];
            } else{
                self.address.countyName = @"";
            }
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChangeStatus:)]) {
        [self.delegate pickerDidChangeStatus:self];
    }

}





- (void)showInView:(UIView *)view{
    NSLog(@"shou in");
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    NSString  *str = NSStringFromCGRect(self.frame);
    NSLog(@"%@", str);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        NSString  *str = NSStringFromCGRect(self.frame);
        NSLog(@"%@", str);
    }];
}

- (void)cancelPicker{
    
    NSLog(@"quxiao");
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
