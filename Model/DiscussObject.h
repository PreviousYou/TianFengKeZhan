//
//  DiscussObject.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseObject.h"
#import "UserObject.h"

@interface DiscussObject : BaseObject
/// 状态(0.正常 1.精华 2.置顶)
@property (assign, nonatomic) int status;
/// 简介
@property (strong, nonatomic) NSString *brief;
/// 浏览量
@property (assign, nonatomic) int browseCount;
/// 评论量
@property (assign, nonatomic) int commentCount;
/// 收藏量
@property (assign, nonatomic) int favCount;
/// 发帖人信息
@property (strong, nonatomic) UserObject *userObj;
/// 创建时间
@property (strong, nonatomic) NSDate *createDate;

/// 由列表API获取的字典初始化该类实例
- (instancetype)initWithListDictionary:(NSDictionary*)dict;

/// 由列表API获取的字典设置实例属性
- (void)setWithListDictionary:(NSDictionary*)dict;

/// 由收藏列表API获取的字典初始化该类实例
- (instancetype)initWithFavDictionary:(NSDictionary*)dict;

/// 由收藏列表API获取的字典设置实例属性
- (void)setWithFavDictionary:(NSDictionary*)dict;
@end
