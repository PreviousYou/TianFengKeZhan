//
//  LoginedUserObject.h
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseHandler.h"
#import "UserObject.h"

@interface LoginedUserHandler : BaseHandler
/// 保存当前登录用户的对象
@property (strong,nonatomic) UserObject *userObj;
/// 是否登录
@property (assign,nonatomic) BOOL logined;
/// 是否保存密码
@property (assign,nonatomic) BOOL ifSavePassword;
/// 是否自动登录
@property (assign,nonatomic) BOOL ifAutoLogin;
/// 保存的用户名
@property (strong,nonatomic) NSString *savedUsername;
/// 保存的密码
@property (strong,nonatomic) NSString *savedPassword;
/// 是否采用保存的密码
@property (assign,nonatomic) BOOL ifUseSavedPassword;

/// 返回当前登录用户
+ (LoginedUserHandler*)loginedUser;

/*!
 *  @brief  登录
 *  @param cellphone        手机号
 *  @param password         密码
 *  @param success          登录成功回调
 *  @param failed           登录失败回调
 */
- (void)loginWithCellphone:(NSString*)cellphone password:(NSString*)password success:(SuccessBlock)success failed:(FailedBlock)failed;

/*!
 *  @brief  登出用户
 *  @return 登出是否成功
 */
- (BOOL)logout;

/// 读取用户鉴权信息, 返回是否成功读取并登录
- (BOOL)loadUserAuthInformation;

/// 刷新用户信息
- (void)refreshUserInfoWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;
@end