//
//  UserInfoViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/25.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginedUserHandler.h"
#import "APIHandler.h"
#import "BindCompanyViewController.h"
#import "MPAlertView.h"
#import "SAImageUtility.h"
#import "AppConfig.h"
#import "LGAlertView.h"
#import "CommonFunction.h"
#import <UIButton+WebCache.h>
#import <MBProgressHUD.h>
#import <ALBB_OSS_IOS_SDK/OSSService.h>

@interface UserInfoViewController ()<UITextFieldDelegate,LGAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSArray *arrCellHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UILabel *lblGrade;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblCellphone;
@property (weak, nonatomic) IBOutlet UIView *viewCompanyList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNickname;
@property (weak, nonatomic) IBOutlet UILabel *lblImage;
@property (weak, nonatomic) IBOutlet UIButton *btnEditNickName;
@property (strong, nonatomic) CompanyObject *currentObj;
@property (strong, nonatomic) id<ALBBOSSServiceProtocol> ossService;
@property (strong, nonatomic) OSSBucket *bucket;
@property (strong, nonatomic) TaskHandler *taskHandler;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrCellHeight = @[ @[@7], @[@118],
                        @[@7], @[@45],
                        @[@7], [[NSMutableArray alloc]initWithArray:@[@45, @45]],
                        @[@7], @[@45],
                        ];
    // 由于UI不能接受iOS7风格的TableView分割线，进行特殊处理
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [_lblGrade.layer setCornerRadius:4];
    [_lblGrade.layer setMasksToBounds:YES];
    [_lblImage.layer setCornerRadius:4];
    [_lblImage.layer setMasksToBounds:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    UserObject *userObj = [LoginedUserHandler loginedUser].userObj;
    [_btnImage sd_setImageWithURL:[NSURL URLWithString:userObj.imagePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
    [_lblGrade setText:userObj.grade];
    [_lblScore setText:[NSString stringWithFormat:@"积分：%ld",(long)userObj.score]];
    [_lblCellphone setText:[NSString stringWithFormat:@"帐号：%@", userObj.name]];
    [_textFieldNickname setText:userObj.nickName];
    
    for (UIView *view in _viewCompanyList.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat perHeight = 43;
    NSArray *arrCompany = userObj.arrCompany;
    _arrCellHeight[5][1] = @(perHeight * arrCompany.count);
    
    for (int i=0;i<arrCompany.count;i++) {
        CompanyObject *obj = arrCompany[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj.name forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [btn setFrame:CGRectMake(0, i * perHeight, [UIScreen mainScreen].bounds.size.width - 60, perHeight)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCompanyList addSubview:btn];
        
        UIImageView *imgViewSeperator = [[UIImageView alloc]initWithFrame:CGRectMake(8, (i+1)*perHeight, [UIScreen mainScreen].bounds.size.width - 8, 0.5)];
        [imgViewSeperator setBackgroundColor:[UIColor colorWithWhite:0.780 alpha:1.000]];
        [_viewCompanyList addSubview:imgViewSeperator];
        
        UIButton *btnUnbind = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUnbind setTitle:@"解除绑定" forState:UIControlStateNormal];
        [btnUnbind setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, i * perHeight, 60, perHeight)];
        [btnUnbind setBackgroundColor:[UIColor clearColor]];
        [btnUnbind setTitleColor:[UIColor colorWithRed:0.678 green:0.051 blue:0.098 alpha:1.000] forState:UIControlStateNormal];
        [btnUnbind.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btnUnbind setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btnUnbind setTag:i];
        [btnUnbind addTarget:self action:@selector(btnUnbindClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCompanyList addSubview:btnUnbind];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_arrCellHeight[indexPath.section][indexPath.row] doubleValue];
}

- (IBAction)btnEditNicknameClick:(UIButton *)sender {
    if ([_textFieldNickname isFirstResponder]) {
        [_textFieldNickname resignFirstResponder];
        [_textFieldNickname setText:[LoginedUserHandler loginedUser].userObj.nickName];
    } else {
        [_textFieldNickname becomeFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_btnEditNickName setTitle:@"取消" forState:UIControlStateNormal];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_btnEditNickName setTitle:@"编辑" forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        // 未输入任何字符
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入昵称" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if ([textField.text isEqualToString:[LoginedUserHandler loginedUser].userObj.nickName]) {
        // 与当前昵称相同，不再提交，以避免API返回昵称已存在的错误信息
        [textField resignFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    dict[@"nick"] = _textFieldNickname.text;
    dict[@"token"] = [LoginedUserHandler loginedUser].userObj.token;
    [apiHandler getWithAPIName:API_USER_CHANGE_NICKNAME parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_USER_CHANGE_NICKNAME,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [LoginedUserHandler loginedUser].userObj.nickName = _textFieldNickname.text;
            [MPAlertView showAlertView:@"昵称编辑成功"];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dictResponse[@"retmsg"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    } failed:^(NSString *errorMessage) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }];
    return YES;
}

- (void)btnCompanyClick:(UIButton*)sender {
    BindCompanyViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BindCompanyViewController"];
    CompanyObject *obj = [LoginedUserHandler loginedUser].userObj.arrCompany[sender.tag];
    [viewController setCompanyObj:obj];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)btnUnbindClick:(UIButton*)sender {
    _currentObj = [LoginedUserHandler loginedUser].userObj.arrCompany[sender.tag];
    LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"\n您确定要解除对“%@”的绑定吗？\n",_currentObj.name] buttonTitles:@[@"确认"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [CommonFunction setStyleOfLGAlertView:alertView];
    [alertView setDelegate:self];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    if (index == 0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud show:YES];
        APIHandler *apiHandler = [[APIHandler alloc]init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict[@"id"] = _currentObj.objectID;
        dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
        [apiHandler getWithAPIName:API_COMPANY_UNBIND parameters:dict success:^(NSDictionary *dictResponse) {
            SALog(@"%@: %@",API_COMPANY_UNBIND,dictResponse);
            [hud hide:YES];
            if ([dictResponse[@"retcode"] intValue] == 1) {
                [[LoginedUserHandler loginedUser].userObj.arrCompany removeObject:_currentObj];
                _currentObj = nil;
                [self loadData];
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
}

- (IBAction)btnImageClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择照片",nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert show];
            return;
        }
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        [controller setAllowsEditing:YES];
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setAllowsEditing:YES];
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage*)image {
    [self initOSSService];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelText:@"图片上传中，请稍后..."];
    [hud setMode:MBProgressHUDModeDeterminate];
    [hud setProgress:0];
    [hud.layer setZPosition:MAXFLOAT];
    [self.view addSubview:hud];
    [hud show:YES];
    
    // 限制头像最大尺寸并进行压缩
    if (image.size.width > 100) {
        image = [SAImageUtility scaleImage:image toSize:CGSizeMake(100, 100)];
    }
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    
    OSSData *ossData = [_ossService getOSSDataWithBucket:_bucket key:[NSString stringWithFormat:@"userhead_%@",[LoginedUserHandler loginedUser].userObj.objectID]];
    [ossData setData:data withType:@"image/jpeg"];
    [ossData enableUploadCheckMd5sum:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _taskHandler = [ossData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                [hud setMode:MBProgressHUDModeIndeterminate];
                [hud setLabelText:@"请稍候"];
                NSString *fileUrl = [NSString stringWithFormat:@"http://%@.%@/%@",CONFIG_ALIYUN_OSS_BUCKET_NAME,CONFIG_ALIYUN_OSS_HOST_ID,ossData.key];
                APIHandler *apiHandler = [[APIHandler alloc]init];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                dict[@"imgUrl"] = fileUrl;
                dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
                [apiHandler getWithAPIName:API_USER_CHANGE_HEAD parameters:dict success:^(NSDictionary *dictResponse) {
                    SALog(@"%@: %@",API_USER_CHANGE_HEAD,dictResponse);
                    [hud hide:YES];
                    if ([dictResponse[@"retcode"] intValue] == 1) {
                        [LoginedUserHandler loginedUser].userObj.imagePath = fileUrl;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_btnImage setImage:image forState:UIControlStateNormal];
                        });
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片上传失败，请稍后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }
        } withProgressCallback:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud setProgress:progress];
            });
        }];
    });
}

- (void)initOSSService {
    _ossService = [ALBBOSSServiceProvider getService];
    [_ossService setGlobalDefaultBucketAcl:PRIVATE];
    [_ossService setGlobalDefaultBucketHostId:CONFIG_ALIYUN_OSS_HOST_ID];
    [_ossService setAuthenticationType:ORIGIN_AKSK];
    [_ossService setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:CONFIG_ALIYUN_OSS_SECRET];
        signature = [NSString stringWithFormat:@"OSS %@:%@", CONFIG_ALIYUN_OSS_ACCESS_KEY, signature];
        return signature;
    }];
    _bucket = [_ossService getBucket:CONFIG_ALIYUN_OSS_BUCKET_NAME];
}
@end
