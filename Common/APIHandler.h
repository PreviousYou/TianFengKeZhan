//
//  APIHandler.h
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/13.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "BaseHandler.h"
#import "APIConsts.h"

@protocol APIHandlerDelegate;

@interface APIHandler : AFHTTPSessionManager
/// APIHandler代理
@property (nonatomic, weak) id<APIHandlerDelegate> delegate;

/*!
 *  @brief  初始化方法，采用默认BaseURL
 *  @param delegate 实例代理
 *  @return 本类实例
 */
- (instancetype)initWithDelegate:(id<APIHandlerDelegate>)delegate;

/*!
 *  @brief  初始化方法
 *  @param url API基准URL
 *  @return 本类实例
 */
- (instancetype)initWithBaseURL:(NSURL *)url;

/*!
 *  @brief  初始化方法
 *  @param url      API基准URL
 *  @param delegate 实例代理
 *  @return 本类实例
 */
- (instancetype)initWithBaseURL:(NSURL *)url delegate:(id<APIHandlerDelegate>)delegate;

/*!
 *  @brief  刷新HTTP Header
 */
- (void)resetHTTPHeader;

/*!
 *  @brief  通用GET请求方法（代理方式）
 *  @param strAPIName    API名称(相对路径)
 *  @param dictParameter 参数表
 */
- (void)getWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter;

/*!
 *  @brief  通用GET请求方法（Block方式）
 *  @param strAPIName    API名称(相对路径)
 *  @param dictParameter 参数表
 *  @param success       成功Block
 *  @param failed        失败Block
 */
- (void)getWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter success:(SuccessBlock)success failed:(FailedBlock)failed;

/*!
 *  @brief  通用POST请求方法（代理方式）
 *  @param strAPIName    API名称(相对路径)
 *  @param dictParameter 参数表
 */
- (void)postWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter;

/*!
 *  @brief  通用POST请求方法（Block方式）
 *  @param strAPIName    API名称(相对路径)
 *  @param dictParameter 参数表
 *  @param success       成功Block
 *  @param failed        失败Block
 */
- (void)postWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter success:(SuccessBlock)success failed:(FailedBlock)failed;

/*!
 *  @brief  获取验证码(Block方式)
 *  @param phone   手机号
 *  @param type    验证码类型，-1:登录注册，-2:忘记密码
 *  @param success 成功Block
 *  @param failed  失败Block
 */
- (void)getVerificationCodeWithPhone:(NSString*)phone type:(NSInteger)type success:(SuccessBlock)success failed:(FailedBlock)failed;

/*!
 *  @brief  获取验证码
 *  @param phone 手机号
 *  @param type  验证码类型，-1:登录注册，-2:忘记密码
 */
- (void)getVerificationCodeWithPhone:(NSString*)phone type:(NSInteger)type;

/*!
 *  @brief  上传文件
 *  @param data 文件数据
 *  @param type 文件类型，1:用户头像，2:人物图片，3:语音
 */
- (void)uploadFileWithData:(NSData*)data type:(NSInteger)type;

/*!
 *  @brief  上传文件(Block方式)
 *  @param data 文件数据
 *  @param type 文件类型，1:用户头像，2:人物图片，3:语音
 *  @param success 成功Block
 *  @param failed  失败Block
 */
- (void)uploadFileWithData:(NSData*)data type:(NSInteger)type success:(SuccessBlock)success failed:(FailedBlock)failed;

/*!
 *  @brief  从URL下载文件到文档目录
 *  @param url      源URL
 *  @param filename 目标文件名
 *  @param success  成功Block
 *  @param failed   失败Block
 */
- (void)downloadFileWithURL:(NSURL*)url saveToDocumentFile:(NSString*)filename success:(SuccessBlock)success failed:(FailedBlock)failed;
@end

@protocol APIHandlerDelegate <NSObject>
@optional
/*!
 *  @brief  数据获取成功回调方法
 *  @param handler      APIHandler实例
 *  @param responseData 返回的数据字典
 *  @param name         API名称(相对路径)
 */
- (void)apiHandler:(APIHandler*)handler didSuccessWithResponse:(id)responseData apiName:(NSString*)name;

/*!
 *  @brief  获取数据失败回调方法
 *  @param handler APIHandler实例
 *  @param error   返回的错误信息
 *  @param name    API名称(相对路径)
 */
- (void)apiHandler:(APIHandler*)handler didFailedWithErrorMessage:(NSString*)error apiName:(NSString*)name;

void SALog(NSString* format, ...);
@end
