//
//  CompanyObject.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/25.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseObject.h"

@interface CompanyObject : BaseObject
/// 税号
@property (strong, nonatomic) NSString *taxID;
/// 密码，后期客户要求不再保存密码字段，此属性仅留作备用
@property (strong, nonatomic) NSString *password;

/// 由列表API获取的字典初始化该类实例
- (instancetype)initWithListDictionary:(NSDictionary*)dict;

/// 由列表API获取的字典设置实例属性
- (void)setWithListDictionary:(NSDictionary*)dict;
@end
