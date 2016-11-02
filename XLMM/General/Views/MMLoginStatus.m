//
//  MMLoginStatus.m
//  XLMM
//
//  Created by younishijie on 16/2/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MMLoginStatus.h"

@implementation MMLoginStatus

static  MMLoginStatus *_instance = nil;

+ (instancetype)shareLoginStatus{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    }) ;
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _loginUrl = [NSString stringWithFormat:@""];
        _userInfoUrl = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    }
    return self;
}

- (BOOL)islogin{
    NSLog(@"login url = %@", self.loginUrl);
    NSURL *url = [NSURL URLWithString:self.loginUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return NO;
    } else {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error != nil) {
            return NO;
        } else {
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (code == 0) {
                return YES;
            }
            else {
                return NO;
            }
        }
    }

}

- (BOOL)isxlmm{
    NSLog(@"user's profile url= %@", self.userInfoUrl);
    NSURL *url = [NSURL URLWithString:self.userInfoUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return NO;
    } else{
        NSError *error = nil;
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error == nil) {
            NSLog(@"userinfo = %@", userInfo);
            id object = [userInfo objectForKey:@"xiaolumm"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                self.xiaolumm = object;
                NSLog(@"xiaolumm = %@", object);
                return YES;
            } else {
                return NO;
            }
        } else{
            return NO;
        }
    }
}


@end
