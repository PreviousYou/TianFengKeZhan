//
//  ResetPasswordViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/21.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CellphoneVerificationViewController.h"

@interface ResetPasswordViewController : BaseTableViewController
/// 验证类型
@property (assign, nonatomic) VerificationType verificationType;
/// 手机号
@property (strong, nonatomic) NSString *cellPhone;
/// 验证码
@property (copy, nonatomic) NSString *verificationCode;

@end
