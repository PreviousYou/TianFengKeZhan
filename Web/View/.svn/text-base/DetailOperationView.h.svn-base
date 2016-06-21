//
//  DetailOperationView.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/6.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

/// 详情操作类型枚举
typedef NS_ENUM(NSUInteger, DetailOperationType) {
    /// 分享到微信好友
    DetailOperationTypeShareToWechatSession,
    /// 分享到QQ好友
    DetailOperationTypeShareToQQ,
    /// 分享到微信朋友圈
    DetailOperationTypeShareToWechatTimeline,
    /// 分享到QQ空间
    DetailOperationTypeShareToQzone,
    /// 分享到新浪微博
    DetailOperationTypeShareToWeibo,
    /// 分享到腾讯微博
    DetailOperationTypeShareToTencent,
    /// 收藏
    DetailOperationTypeFavorite,
    /// 举报
    DetailOperationTypeReport
};

@protocol DetailOperationViewDelegate<NSObject>
/// 点击收藏
- (void)favClick;
/// 点击举报
- (void)reportClick;
/// 点击分享
- (void)shareClickWithPlatForm:(DetailOperationType)operationType;
@end;

@interface DetailOperationView : BaseView
@property (strong, nonatomic) id<DetailOperationViewDelegate> delegate;
- (void)reloadWithShareEnabled:(BOOL)shareEnabled favEnabled:(BOOL)favEnabled reportEnabled:(BOOL)reportEnabled;
@end
