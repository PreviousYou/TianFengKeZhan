//
//  LoginViewController.m
//  JuYouChe
//
//  Created by StoneArk on 15/6/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonFunction.h"
#import "LoginedUserHandler.h"
#import "CellphoneVerificationViewController.h"

#import "APIHandler.h"
#import "APService.h"
#import <MBProgressHUD.h>

#define UserDidClick @"UserClickNotification"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldCellphone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSavePassword;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
    [self receiveNoti];
    
   
    
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_btnSubmit.layer setCornerRadius:4];
    [_btnSubmit.layer setMasksToBounds:YES];
    [_btnAutoLogin setSelected:[LoginedUserHandler loginedUser].ifAutoLogin];
    [_btnSavePassword setSelected:[LoginedUserHandler loginedUser].ifSavePassword];
    if ([LoginedUserHandler loginedUser].ifSavePassword) {
        [_textFieldCellphone setText:[LoginedUserHandler loginedUser].savedUsername];
        [_textFieldPassword setText:@"xxxxxxxx"];
        [LoginedUserHandler loginedUser].ifUseSavedPassword = YES;
    } else {
        [_textFieldCellphone setText:@""];
        [_textFieldPassword setText:@""];
        [LoginedUserHandler loginedUser].ifUseSavedPassword = NO;
    }
}

- (IBAction)btnSubmitClick:(UIButton *)sender {
    if (![CommonFunction isMobileNumber:_textFieldCellphone.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误，请核对" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_textFieldPassword.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setLabelText:@"正在登录"];
    [hud show:YES];
    
    [[LoginedUserHandler loginedUser] loginWithCellphone:_textFieldCellphone.text password:_textFieldPassword.text success:^(id obj) {
        [hud hide:YES];
        NSString *registrationID = [APService registrationID];
        if (registrationID && registrationID.length > 0) {
            APIHandler *apiHandler = [[APIHandler alloc]init];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            dict[@"account"] = [LoginedUserHandler loginedUser].userObj.name;
            dict[@"regId"] = registrationID;
            [apiHandler getWithAPIName:API_USER_LOGIN_SUCCESS parameters:dict success:^(NSDictionary *dictResponse) {
                SALog(@"%@: %@",API_USER_LOGIN_SUCCESS,dictResponse);
            } failed:^(NSString *errorMessage) {
                SALog(@"%@", errorMessage);
            }];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *errorMessage) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RegisterSegue"]) {
        CellphoneVerificationViewController *viewController = segue.destinationViewController;
        
        [viewController setVerificationType:VerificationTypeRegister];
        
    } else if ([segue.identifier isEqualToString:@"ResetPasswordSegue"]) {
        
        CellphoneVerificationViewController *viewController = segue.destinationViewController;
        
        [viewController setVerificationType:VerificationTypeResetPassword];
    }
}

- (IBAction)btnSavePasswordClick:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    if (!sender.selected) {
        [_btnAutoLogin setSelected:NO];
    }
    [LoginedUserHandler loginedUser].ifSavePassword = _btnSavePassword.selected;
    [LoginedUserHandler loginedUser].ifAutoLogin= _btnAutoLogin.selected;
}

- (IBAction)btnAutoLoginClick:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [_btnSavePassword setSelected:YES];
    }
    [LoginedUserHandler loginedUser].ifSavePassword = _btnSavePassword.selected;
    [LoginedUserHandler loginedUser].ifAutoLogin= _btnAutoLogin.selected;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _textFieldPassword && [LoginedUserHandler loginedUser].ifUseSavedPassword) {
        [_textFieldPassword setText:@""];
        [LoginedUserHandler loginedUser].ifUseSavedPassword = NO;
    }
    return YES;
}

- (void)receiveNoti {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFristResponder:) name:UserDidClick object:nil];
    
}

- (void)cancelFristResponder:(NSNotification *)notic {
    
    [_textFieldPassword resignFirstResponder];
    
    [_textFieldCellphone resignFirstResponder];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
