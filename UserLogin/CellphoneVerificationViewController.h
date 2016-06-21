//
//  ResetPasswordViewController.h
//  JuYouChe
//
//  Created by StoneArk on 15/6/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewController.h"

/// 验证业务类型
typedef NS_ENUM(NSUInteger, VerificationType) {
    /// 未定义
    VerificationTypeUndefined,
    /// 注册
    VerificationTypeRegister,
    /// 忘记密码
    VerificationTypeResetPassword
};


@interface CellphoneVerificationViewController : BaseTableViewController
/// 验证类型
@property (assign, nonatomic) VerificationType verificationType;

@end
