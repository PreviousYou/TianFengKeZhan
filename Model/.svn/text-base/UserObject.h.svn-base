//
//  UserObject.h
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseObject.h"
#import "CompanyObject.h"

/// 用户类
@interface UserObject : BaseObject
/// 用户昵称
@property (strong,nonatomic) NSString* nickName;
/// 用户等级名称
@property (strong,nonatomic) NSString* grade;
/// 用户等级
@property (strong,nonatomic) NSString* level;
/// 用户积分
@property (assign,nonatomic) NSInteger score;
/// 新消息数量
@property (assign,nonatomic) NSInteger unreadMessageCount;
/// 绑定企业数组
@property (strong,nonatomic) NSMutableArray *arrCompany;
/// 用户密码(md5密文)
@property (strong,nonatomic) NSString* password;
/// 用户token
@property (strong,nonatomic) NSString* token;

/// 由登录API获取的字典初始化该类实例
- (instancetype)initWithLoginDictionary:(NSDictionary*)dict;
/// 由用户信息API获取的字典初始化该类实例
- (instancetype)initWithInformationDictionary:(NSDictionary*)dict;

/// 由登录API获取的字典设置实例属性
- (void)setWithLoginDictionary:(NSDictionary*)dict;
/// 由用户信息API获取的字典设置实例属性
- (void)setWithInformationDictionary:(NSDictionary*)dict;

- (void)reset;

@end
