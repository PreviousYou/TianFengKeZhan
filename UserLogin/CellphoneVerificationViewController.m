//
//  ResetPasswordViewController.m
//  JuYouChe
//
//  Created by StoneArk on 15/6/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "CellphoneVerificationViewController.h"
#import "RetractInputView.h"
#import "MBProgressHUD.h"
#import "APIHandler.h"
#import "CommonFunction.h"
#import "ResetPasswordViewController.h"
#import <CocoaSecurity.h>

@interface CellphoneVerificationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldCellphone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldVerificationCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnGetVerification;

@property (weak, nonatomic) IBOutlet UIButton *voiceCodeBtn;

@property (strong, nonatomic) NSTimer *timer; //获取验证码计时器
@property (assign, nonatomic) int countdown; //获取验证码倒计时时间




@end

@implementation CellphoneVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initInputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    
    [self creatUI];
    
    if (_verificationType == VerificationTypeRegister) {
        [self setTitle:@"注册"];
    } else if (_verificationType == VerificationTypeResetPassword) {
        [self setTitle:@"忘记密码"];
    }
    [_btnSubmit.layer setCornerRadius:4];
    [_btnSubmit.layer setMasksToBounds:YES];
    [_btnGetVerification.layer setCornerRadius:4];
    [_btnGetVerification.layer setMasksToBounds:YES];
    [_btnGetVerification.layer setBorderColor:[UIColor colorWithRed:0.145 green:0.588 blue:0.224 alpha:1.000].CGColor];
    [_btnGetVerification.layer setBorderWidth:1];
}

- (void)creatUI {

    _voiceCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_voiceCodeBtn setTitleColor:[UIColor colorWithRed:187.0f/255.0f green:120.0f/255.0f blue:61.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    [_voiceCodeBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initInputView {
    RetractInputView *viewRetract = [[[NSBundle mainBundle] loadNibNamed:@"RetractInputView" owner:self options:nil] firstObject];
    [viewRetract setEditingView:self.view];
    [_textFieldCellphone setInputAccessoryView:viewRetract];
    [_textFieldVerificationCode setInputAccessoryView:viewRetract];
}

- (IBAction)btnSubmitClick:(UIButton *)sender {
    if (_textFieldCellphone.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![CommonFunction isMobileNumber:_textFieldCellphone.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误，请核对" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_textFieldVerificationCode.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    

    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    
    
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    dict[@"phone"] = _textFieldCellphone.text;
    dict[@"code"] = _textFieldVerificationCode.text;
    
    dict[@"flag"] = [NSNumber numberWithInteger:-_verificationType];
    
    
    
    [apiHandler getWithAPIName:API_VERIFICATE parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_VERIFICATE,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            ResetPasswordViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
            
            viewController.verificationCode = _textFieldVerificationCode.text;
            
            [viewController setCellPhone:_textFieldCellphone.text];
            [viewController setVerificationType:_verificationType];
            [self.navigationController pushViewController:viewController animated:YES];
            
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

- (IBAction)btnGetVerificationCodeClick:(UIButton *)sender {
    if ([CommonFunction isMobileNumber:_textFieldCellphone.text]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud show:YES];
        [hud setLabelText:@"请稍后"];
        [hud show:YES];
        APIHandler *apiHandler = [[APIHandler alloc]init];
        [apiHandler getVerificationCodeWithPhone:_textFieldCellphone.text type:-_verificationType success:^(NSDictionary *dictResponse) {
            [hud hide:YES];
            if ([dictResponse[@"retcode"] intValue] == 1) {
                // 开始倒计时，并禁止按钮可点击
                _countdown = 60;
                [_btnGetVerification setUserInteractionEnabled:NO];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dictResponse[@"retmsg"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }
        } failed:^(NSString *errorMessage) {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误，请核对" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)timerTick {
    // 更新倒计时时间
    _countdown --;
    [_btnGetVerification setTitle:[NSString stringWithFormat:@"%d",_countdown] forState:UIControlStateNormal];
    if (_countdown <= 0) {
        // 倒计时已结束，恢复可点击状态
        [_timer invalidate];

        _voiceCodeBtn.hidden = NO;
        
        [_textFieldCellphone resignFirstResponder];
        
        [_textFieldVerificationCode resignFirstResponder];


        [_btnGetVerification setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnGetVerification setUserInteractionEnabled:YES];
        
    }
    
}


- (void)voiceBtnAction:(UIButton *)sender {

    APIHandler *apiHandler = [[APIHandler alloc] init];
    
    NSMutableDictionary *voiceDic = [NSMutableDictionary dictionary];
    
    [voiceDic setObject:_textFieldCellphone.text forKey:@"phone"];
    
    
    [voiceDic setObject:@(-_verificationType) forKey:@"flag"];
    
    [apiHandler getWithAPIName:API_GET_VOICE_VERIFICATION parameters:voiceDic success:^(id obj) {

        [sender setTitle:@"语音验证码已发送，请注意接听" forState:UIControlStateNormal];
        
    } failed:^(id obj) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"@提示" message:@"获取语音验证码失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }];
    
}


@end
