//
//  LoginedUserObject.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "LoginedUserHandler.h"
#import "CocoaSecurity.h"
#import "APIHandler.h"
#import "AppConfig.h"
#import "APIConsts.h"
#import "MPAlertView.h"
#import "APService.h"

#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PLISTPATH [DOCUMENTPATH stringByAppendingPathComponent:@"uauth.plist"]

@implementation LoginedUserHandler

static LoginedUserHandler *_loginedUser = nil;

+ (LoginedUserHandler*)loginedUser {
    @synchronized (self)
    {
        if (!_loginedUser) {
            NSLog(@"%@ Singleton alloc!",NSStringFromSelector(_cmd));
            _loginedUser = [[LoginedUserHandler alloc]init];
        }
    }
    return _loginedUser;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!_loginedUser) {
            _loginedUser = [super allocWithZone:zone];
            return _loginedUser;
        }
    }
    return nil;
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (id)init {
    if (self = [super init]) {
        _userObj = [[UserObject alloc]init];
        [_userObj reset];
    }
    return self;
}

- (void)loginWithCellphone:(NSString*)cellphone password:(NSString*)password success:(SuccessBlock)success failed:(FailedBlock)failed {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSString *strPassword;
    if (_ifUseSavedPassword) {
        strPassword = _savedPassword;
    } else {
        strPassword = [CocoaSecurity md5:password].hexLower;
    }
    NSDictionary *dict = @{@"account":cellphone,
                           @"password":strPassword};
    [apiHandler getWithAPIName:API_USER_LOGIN parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_USER_LOGIN,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_userObj setWithLoginDictionary:dictResponse[@"extra"]];
            _userObj.password = dict[@"password"];
            _logined = YES;
            [APService setTags:[NSSet setWithObject:_userObj.name] alias:_userObj.name callbackSelector:nil object:nil];
            if (_ifSavePassword) {
                [self saveUserAuthInformation];
            } else {
                [self resetUserAuthInformation];
            }
            success(dictResponse);
        } else {
            [_userObj reset];
            failed(dictResponse[@"retmsg"]);
        }
    } failed:^(NSError *error) {
        failed(error.description);
    }];

}

- (BOOL)logout {
//    [self resetUserAuthInformation];
    [_userObj reset];
    [APService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
    _logined = NO;
    return YES;
}

/// 保存用户鉴权信息
- (void)saveUserAuthInformation {
    NSDictionary *dict = @{@"cellphone":_userObj.name,
                           @"userID":_userObj.objectID,
                           @"password":_userObj.password,
                           @"savepwd":@(_ifSavePassword),
                           @"autologin":@(_ifAutoLogin),
                           @"token":_userObj.token
                           };
    [dict writeToFile:PLISTPATH atomically:YES];
    _savedUsername = [_userObj.name copy];
    _savedPassword = [_userObj.password copy];
}

/// 重置用户鉴权信息
- (void)resetUserAuthInformation {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:PLISTPATH]) {
        [fileManager removeItemAtPath:PLISTPATH error:nil];
    }
}

/// 读取用户鉴权信息, 返回是否成功读取并登录
- (BOOL)loadUserAuthInformation {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:PLISTPATH]) {
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:PLISTPATH];
        _ifSavePassword = [dict[@"savepwd"] boolValue];
        _ifAutoLogin = [dict[@"autologin"] boolValue];
        _savedUsername = [dict[@"cellphone"] copy];
        _savedPassword = [dict[@"password"] copy];
        if (_ifAutoLogin) {
            _userObj.objectID = dict[@"userID"];
            _userObj.name = dict[@"cellphone"];
            _userObj.password = dict[@"password"];
            _userObj.token = dict[@"token"];
            [APService setTags:[NSSet setWithObject:_userObj.name] alias:_userObj.name callbackSelector:nil object:nil];
            _logined = YES;
        } else {
            [_userObj reset];
            _logined = NO;
        }
    } else {
        [_userObj reset];
        _logined = NO;
    }
    return _logined;
}

- (void)refreshUserInfoWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_USER_INFO parameters:@{@"memberId":_userObj.objectID,@"account":_userObj.name,@"token":_userObj.token} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_USER_INFO,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_userObj setWithInformationDictionary:dictResponse[@"extra"]];
            success(dictResponse);
        }
    } failed:^(NSError *error) {
        failed(error.description);
    }];
}

@end

