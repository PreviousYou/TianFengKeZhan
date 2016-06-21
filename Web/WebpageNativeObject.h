//
//  WebpageNativeObject.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/28.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

/// Native 方法
@protocol NativeObjectExport <JSExport>
//-(void)goBack;
//-(NSString *)getAuthInfo;
//-(void)goTaDy:(NSString *)friendID;

/// 接收配置参数
- (void)initData:(NSString*)para;
/// 回复某人
- (void)repleySomeone:(NSString*)targetName;
/// 显示大图
- (void)showImgs:(NSString*)imgsInfo;
/// 显示消息
- (void)showToast:(NSString*)toast;
@end

/// Native 对象代理
@protocol WebpageNativeObjectDelegate<NSObject>
//-(void)nativeGoBack;
//-(BOOL)nativePushViewController:(UIViewController *)viewController animated:(BOOL)isAnimated;
//- (void)nativeShowKeyboard;
/// 显示大图
- (void)showImageBrowser:(NSArray*)imagePath atIndex:(NSUInteger)index;
/// 接收到配置参数
- (void)configReceived;
/// 回复某条评论
- (void)replyFloor:(NSString*)targetName;
@end

/// Native 对象
@interface WebpageNativeObject : NSObject<NativeObjectExport>
/// 代理
@property (assign, nonatomic) id<WebpageNativeObjectDelegate> delegate;
/// 是否允许回复
@property (assign, nonatomic) BOOL replyEnabled;
/// 是否允许举报
@property (assign, nonatomic) BOOL reportEnabled;
/// 是否允许收藏
@property (assign, nonatomic) BOOL favEnabled;
/// 是否允许分享
@property (assign, nonatomic) BOOL shareEnabled;
/// 分享内容
@property (strong, nonatomic) NSString *shareContent;
/// 分享图片地址
@property (strong, nonatomic) NSString *shareImagePath;
/// 分享链接
@property (strong, nonatomic) NSString *shareUrl;
/// 作者昵称
@property (strong, nonatomic) NSString *authorNickName;
/// 回复作者JS方法名
@property (strong, nonatomic) NSString *replyAuthorMethod;
/// 回复评论JS方法名
@property (strong, nonatomic) NSString *replyFloorMethod;
/// 收藏JS方法名
@property (strong, nonatomic) NSString *favMethod;
/// 举报JS方法名
@property (strong, nonatomic) NSString *reportMethod;

@end
