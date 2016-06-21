//
//  ArticleObject.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/20.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseObject.h"

@interface ArticleObject : BaseObject
/// 简介
@property (strong, nonatomic) NSString *brief;
/// 状态(0.正常 1.精华 2.置顶)
@property (assign, nonatomic) int status;

/// 由列表API获取的字典初始化该类实例
- (instancetype)initWithListDictionary:(NSDictionary*)dict;

/// 由列表API获取的字典设置实例属性
- (void)setWithListDictionary:(NSDictionary*)dict;

/// 由收藏列表API获取的字典初始化该类实例
- (instancetype)initWithFavDictionary:(NSDictionary*)dict;

/// 由收藏列表API获取的字典设置实例属性
- (void)setWithFavDictionary:(NSDictionary*)dict;
@end
