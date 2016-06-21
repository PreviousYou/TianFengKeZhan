//
//  NewDiscussViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "NewDiscussViewController.h"
#import "APIHandler.h"
#import "LoginedUserHandler.h"
#import "ImageUploadView.h"
#import "MPAlertView.h"
#import <MBProgressHUD.h>

@interface NewDiscussViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (strong, nonatomic) ImageUploadView *imageUploadView;
@end

@implementation NewDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageUploadView = [[ImageUploadView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 85)];
    [_imageUploadView setInvokeViewController:self];
    [_textView setInputAccessoryView:_imageUploadView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [_textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [_bottomSpace setConstant:keyboardRect.size.height - 49];
}

- (IBAction)btnSubmitClick:(UIButton *)sender {
    if (_imageUploadView.isUploading) {
        return;
    }
    if (_textView.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        return;
    }
    [self.view endEditing:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"content"] = _textView.text;
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    dict[@"imgs"] = [_imageUploadView.arrImagePath componentsJoinedByString:@","];
    [apiHandler getWithAPIName:API_DISCUSS_NEW parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_DISCUSS_NEW,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            UIView *hudView = [self generateHUDView:@"恭喜您发布成功" image:[UIImage imageNamed:@"emotion_success"]];
            [hud setMode:MBProgressHUDModeCustomView];
            [hud setDimBackground:YES];
            [hud setCustomView:hudView];
            [hud setColor:[UIColor clearColor]];
            [hud setYOffset:-20];
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_invokeViewController setValue:@YES forKey:@"ifNeedRefresh"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            UIView *hudView = [self generateHUDView:dictResponse[@"retmsg"] image:[UIImage imageNamed:@"emotion_failed"]];
            [hud setMode:MBProgressHUDModeCustomView];
            [hud setDimBackground:YES];
            [hud setCustomView:hudView];
            [hud setColor:[UIColor clearColor]];
            [hud setYOffset:-20];
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }];
            
        }
    } failed:^(NSString *errorMessage) {
        UIView *hudView = [self generateHUDView:errorMessage image:[UIImage imageNamed:@"emotion_failed"]];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setDimBackground:YES];
        [hud setCustomView:hudView];
        [hud setColor:[UIColor clearColor]];
        [hud setYOffset:-20];
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }];
    }];
}

- (UIView*)generateHUDView:(NSString*)text image:(UIImage*)image {
    UIView *hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 130)];
    [hudView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgViewEmotion = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, hudView.frame.size.width, 70)];
    [imgViewEmotion setImage:image];
    [imgViewEmotion setContentMode:UIViewContentModeCenter];
    [hudView addSubview:imgViewEmotion];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 210, 50)];
    [lbl setText:text];
    [lbl setFont:[UIFont systemFontOfSize:13]];
    [lbl setTextColor:[UIColor colorWithRed:0.984 green:0.271 blue:0.000 alpha:1.000]];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    [lbl.layer setCornerRadius:6];
    [lbl.layer setMasksToBounds:YES];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [hudView addSubview:lbl];
    
    return hudView;
}

@end
