//
//  WebpageAdvancedViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/28.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseViewController.h"

#ifndef WebpageSourceTypedef
#define WebpageSourceTypedef
/*!
 * @typedef WebpageSourceType
 * @brief 网页来源类型枚举
 */
typedef NS_ENUM(NSUInteger, WebpageSourceType){
    /// 从URL加载
    WebpageSourceTypeURL,
    /// 从ID加载
    WebpageSourceTypeID,
    /// 从帖子ID加载
    WebpageSourceTypeDiscussID,
    /// 从视频ID加载
    WebpageSourceTypeVideoID,
    /// 从问题ID加载
    WebpageSourceTypeQuestionID
};
#endif

@interface WebpageAdvancedViewController : BaseViewController
/// 网页ID
@property (strong, nonatomic) NSString *webpageID;
/// 网页标题
@property (strong, nonatomic) NSString *webpageTitle;
/// 网页URL
@property (strong, nonatomic) NSURL *webpageURL;
/// 网页来源类型
@property (assign, nonatomic) WebpageSourceType sourceType;




@end