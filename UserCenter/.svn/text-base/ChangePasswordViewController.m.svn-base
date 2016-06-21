//
//  ChangePasswordViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "APIHandler.h"
#import "LoginedUserHandler.h"
#import <MBProgressHUD.h>
#import <CocoaSecurity.h>

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOriginPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReNewPassword;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_btnSubmit.layer setCornerRadius:6];
    [_btnSubmit.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnSubmitClick:(UIButton *)sender {
    if (_textFieldOriginPassword.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入原密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        return;
    }
    if (_textFieldNewPassword.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入新密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        return;
    }
    if (_textFieldReNewPassword.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请再次输入新密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        return;
    }
    if (![_textFieldReNewPassword.text isEqualToString:_textFieldNewPassword.text]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的新密码不一致，请核对" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    dict[@"oldPassword"] = [CocoaSecurity md5:_textFieldOriginPassword.text].hexLower;
    dict[@"newPassword"] = [CocoaSecurity md5:_textFieldNewPassword.text].hexLower;
    [apiHandler getWithAPIName:API_USER_CHANGE_PASSWORD parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_USER_CHANGE_PASSWORD,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            [LoginedUserHandler loginedUser].userObj.password = dict[@"newPassword"];
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
