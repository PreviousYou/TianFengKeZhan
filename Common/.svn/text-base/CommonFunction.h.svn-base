//
//  CommonFunction.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/20.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAlertView.h"

@interface CommonFunction : NSObject

/// 如果目标文件不存在，拷贝文件
+ (void)copyFileIfNeed:(NSString *)fromFilePath copyFilePath:(NSString *)toFilePath;
/// 判断是否为合法的手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/// 将时间生成为“...前”的形式，类别为：刚刚、分钟前、小时前、年月日
+ (NSString*)compareCurrentTime:(NSDate*)compareDate;
/// 设置公共的弹出框样式
+ (void)setStyleOfLGAlertView:(LGAlertView*)alertView;
@end
