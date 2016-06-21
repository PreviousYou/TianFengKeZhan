//
//  AdObject.h
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdObject : NSObject
/// 广告ID
@property (strong,nonatomic) NSString *adID;
/// 广告图片的地址
@property (strong,nonatomic) NSString *imagePath;
/// 广告标题
@property (strong,nonatomic) NSString *adTitle;

/// 通过首页广告API初始化本类实例
- (instancetype)initWithDictionary:(NSDictionary*)dict;
/// 通过专题banner API 初始化本类实例
- (instancetype)initWithSubjectDictionary:(NSDictionary*)dict;
/// 通过通知公告banner API 初始化本类实例
- (instancetype)initWithAnnounceDictionary:(NSDictionary*)dict;

@end
