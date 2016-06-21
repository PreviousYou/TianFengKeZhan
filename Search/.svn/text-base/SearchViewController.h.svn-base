//
//  SearchViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/8.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseViewController.h"

/// 搜索类型枚举
typedef NS_ENUM(NSUInteger, SearchType) {
    /// 搜索问题
    SearchTypeQuestion,
    /// 搜索动态
    SearchTypeArticle,
    /// 搜索视频
    SearchTypeVideo,
    /// 搜索帖子
    SearchTypeDiscuss,
    /// 搜索帮助中心问题
    SearchTypeHelpCenterQuestion,
    /// 搜索帮助中心视频
    SearchTypeHelpCenterVideo,
    /// 搜索首页问题
    SearchTypeHomeQuestion
};

@interface SearchViewController : BaseViewController
@property (assign, nonatomic) SearchType searchType;
@property (strong, nonatomic) NSDictionary *dictExtraParameter;
@end
