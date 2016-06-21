//
//  ResetPasswordViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/21.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "RetractInputView.h"
#import "MBProgressHUD.h"
#import "APIHandler.h"
#import "LoginedUserHandler.h"
#import "MPAlertView.h"
#import <CocoaSecurity.h>

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword; //密码输入框
@property (weak, nonatomic) IBOutlet UITextField *textFieldRePassword; //重复密码输入框
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit; //提交按钮
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    RetractInputView *viewRetract = [[[NSBundle mainBundle] loadNibNamed:@"RetractInputView" owner:self options:nil] firstObject];
    [viewRetract setEditingView:self.view];
    [_textFieldPassword setInputAccessoryView:viewRetract];
    [_textFieldRePassword setInputAccessoryView:viewRetract];
    [_btnSubmit.layer setCornerRadius:6];
    [_btnSubmit.layer setMasksToBounds:YES];
}

- (IBAction)btnSubmitClick:(UIButton *)sender {
    if (_textFieldPassword.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请设置新密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![_textFieldRePassword.text isEqualToString:_textFieldPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *strAPIName = _verificationType == VerificationTypeRegister ? API_USER_REGISTER : API_USER_RESET_PASSWORD;
    if (_verificationType == VerificationTypeRegister) {
        // 用户注册
        strAPIName = API_USER_REGISTER;
        dict[@"account"] = _cellPhone;
        dict[@"password"] = [CocoaSecurity md5:_textFieldPassword.text].hexLower;
        dict[@"code"] = _verificationCode;
    } else if (_verificationType == VerificationTypeResetPassword) {
        // 找回密码
        strAPIName = API_USER_RESET_PASSWORD;
        dict[@"account"] = _cellPhone;
        dict[@"newPassword"] = [CocoaSecurity md5:_textFieldPassword.text].hexLower;
        dict[@"code"] = _verificationCode;
    }
    
    [apiHandler getWithAPIName:strAPIName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strAPIName,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSMutableArray *arrStack = [self.navigationController.viewControllers mutableCopy];
            if (_verificationType == VerificationTypeResetPassword) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码找回成功，请用新密码登录" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
                if (arrStack.count > 2) {
                    [arrStack removeObjectsInRange:NSMakeRange(arrStack.count - 2, 2)];
                    [self.navigationController setViewControllers:arrStack];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } else {
                UserObject *userObj = [LoginedUserHandler loginedUser].userObj;
                userObj.name = _cellPhone;
                userObj.password = dict[@"password"];
                userObj.objectID = dictResponse[@"id"];
                userObj.nickName = dictResponse[@"nick"];
                userObj.imagePath = dictResponse[@"headerImg"];
                userObj.score = [dictResponse[@"score"] intValue];
                userObj.grade = dictResponse[@"grade"];
                userObj.unreadMessageCount = [dictResponse[@"myNewsNum"] intValue];
                [LoginedUserHandler loginedUser].logined = YES;
                [MPAlertView showAlertView:@"恭喜您注册成功"];
                if (arrStack.count > 3) {
                    [arrStack removeObjectsInRange:NSMakeRange(arrStack.count - 3, 3)];
                    [self.navigationController setViewControllers:arrStack];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dictResponse[@"retmsg"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    } failed:^(NSString *errorMessage) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }];
}
@end
