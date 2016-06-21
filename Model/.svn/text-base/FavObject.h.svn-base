//
//  FavObject.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/27.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseObject.h"

/// 收藏内容类型
typedef NS_ENUM(NSUInteger, FavContentType) {
    /// 问题
    FavContentTypeQuestion,
    /// 动态
    FavContentTypeArticle,
    /// 视频
    FavContentTypeVideo,
    /// 帖子
    FavContentTypeDiscuss
};

@interface FavObject : BaseObject
/// 收藏内容的对象
@property (strong, nonatomic) BaseObject *contentObj;
/// 收藏内容类型
@property (assign, nonatomic) FavContentType contentType;

/// 由列表API获取的字典初始化该类实例
- (instancetype)initWithListDictionary:(NSDictionary*)dict contentType:(FavContentType)type;

/// 由列表API获取的字典设置实例属性
- (void)setWithListDictionary:(NSDictionary*)dict contentType:(FavContentType)type;
@end
