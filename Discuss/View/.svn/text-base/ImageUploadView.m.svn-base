//
//  ImageUploadView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ImageUploadView.h"
#import "PECropViewController.h"
#import "SAImageUtility.h"
#import "AppConfig.h"
#import "MPAlertView.h"
#import "LoginedUserHandler.h"
#import <MBProgressHUD.h>
#import <ALBB_OSS_IOS_SDK/OSSService.h>

#define ADD_IMAGE_WIDTH 60
#define ADD_IMAGE_HEIGHT 60
#define ADD_IMAGE_GAP 20
#define ADD_IMAGE_BASETAG 1000
#define ADD_IMAGE_MAXCOUNT 4
#define ADD_IMAGE_BADGE_BASETAG 2000
#define ADD_IMAGE_BADGE_WIDTH 22
#define ADD_IMAGE_ACTIONSHEET_TAG 10
#define ADD_IMAGE_ACTIONSHEET_BADGE_TAG 20
#define ADD_IMAGE_MARGIN_LEFT 15

@interface ImageUploadView()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PECropViewControllerDelegate>
@property (strong, nonatomic) UIButton *btnAdd;
@property (strong, nonatomic) UIScrollView *scrView;
@property (assign, nonatomic) NSUInteger clickedImageItemIndex; //被选中的图片下标
@property (strong, nonatomic) OSSBucket *bucket;
@property (strong, nonatomic) TaskHandler *taskHandler;
@property (strong, nonatomic) id<ALBBOSSServiceProtocol> ossService;
@end

@implementation ImageUploadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgViewLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        [imgViewLine setBackgroundColor:[UIColor colorWithWhite:0.875 alpha:1.000]];
        [self addSubview:imgViewLine];
        
        _scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, frame.size.width, frame.size.height)];
        [self addSubview:_scrView];
        
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAdd setImage:[UIImage imageNamed:@"btnAddImage"] forState:UIControlStateNormal];
        [_btnAdd setFrame:CGRectMake(15, 15, 60, 60)];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrView addSubview:_btnAdd];
        
        _arrImagePath = [[NSMutableArray alloc]init];
        
        [self initOSSService];
        
        _isUploading = NO;
    }
    return self;
}

- (void)btnAddClick:(UIButton*)sender {
    if (_arrImagePath.count >= ADD_IMAGE_MAXCOUNT) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您最多只能上传四张图片" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取图片", nil];
    [actionSheet setTag:ADD_IMAGE_ACTIONSHEET_TAG];
    [actionSheet showInView:_invokeViewController.view];
}

#pragma mark - Take/Pick a photo
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == ADD_IMAGE_ACTIONSHEET_TAG) {
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
                return;
            }
            UIImagePickerController *controller = [[UIImagePickerController alloc]init];
            [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
            [controller setAllowsEditing:NO];
            [controller setDelegate:self];
            [_invokeViewController presentViewController:controller animated:YES completion:nil];
        } else if (buttonIndex == 1) {
            UIImagePickerController *controller = [[UIImagePickerController alloc]init];
            [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [controller setAllowsEditing:NO];
            [controller setDelegate:self];
            [_invokeViewController presentViewController:controller animated:YES completion:nil];
        }
    } else if (actionSheet.tag == ADD_IMAGE_ACTIONSHEET_BADGE_TAG) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            NSInteger forEnd = _arrImagePath.count-2;
            for (NSInteger i=_clickedImageItemIndex; i<=forEnd; i++) {
                UIButton *btnCurrent = (UIButton*)[_scrView viewWithTag:ADD_IMAGE_BASETAG + i];
                UIButton *btnNext = (UIButton*)[_scrView viewWithTag:ADD_IMAGE_BASETAG + 1 + i];
                [btnCurrent setImage:btnNext.imageView.image forState:UIControlStateNormal];
            }
            [[_scrView viewWithTag:ADD_IMAGE_BASETAG + _arrImagePath.count - 1] removeFromSuperview];
            [[_scrView viewWithTag:ADD_IMAGE_BADGE_BASETAG + _arrImagePath.count - 1] removeFromSuperview];
            CGRect rect = _btnAdd.frame;
            rect.origin.x = ADD_IMAGE_MARGIN_LEFT + (ADD_IMAGE_WIDTH + ADD_IMAGE_GAP) * (_arrImagePath.count - 1);
            [_btnAdd setFrame:rect];
            [_arrImagePath removeObjectAtIndex:_clickedImageItemIndex];
            [_btnAdd setHidden:NO];
            
            [_scrView setContentSize:CGSizeMake(rect.origin.x + rect.size.width + 15, _scrView.frame.size.height)];
                [_scrView scrollRectToVisible:rect animated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{
        PECropViewController *viewController = [[PECropViewController alloc] init];
        viewController.delegate = self;
        viewController.image = image;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [_invokeViewController presentViewController:navigationController animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (croppedImage.size.width > 320) {
        CGSize newSize = CGSizeMake(320, 320 * croppedImage.size.height / croppedImage.size.width);
        croppedImage = [SAImageUtility scaleImage:croppedImage toSize:newSize];
    }
    [self addImage:croppedImage];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addImage:(UIImage*)image {
    [_invokeViewController.view endEditing:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:_invokeViewController.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelText:@"图片上传中，请稍后..."];
    [hud setMode:MBProgressHUDModeDeterminate];
    [hud setProgress:0];
    [hud.layer setZPosition:MAXFLOAT];
    [_invokeViewController.view addSubview:hud];
    [hud show:YES];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *keySuffix = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    NSString *ossKey = [[LoginedUserHandler loginedUser].userObj.objectID stringByAppendingString:keySuffix];
    
    OSSData *ossData = [_ossService getOSSDataWithBucket:_bucket key:ossKey];
    [ossData setData:data withType:@"image/jpeg"];
    [ossData enableUploadCheckMd5sum:YES];
    
    _isUploading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _taskHandler = [ossData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                UITextView *textView = [_invokeViewController valueForKey:@"textView"];
                if (textView && [textView isKindOfClass:[textView class]]) {
                    [textView becomeFirstResponder];
                }
            });
            _isUploading = NO;
            if (isSuccess) {
                NSString *fileUrl = [NSString stringWithFormat:@"http://%@.%@/%@",CONFIG_ALIYUN_OSS_BUCKET_NAME,CONFIG_ALIYUN_OSS_HOST_ID,ossData.key];
                CGFloat nextX;
                if (_arrImagePath.count == 0) {
                    nextX = ADD_IMAGE_MARGIN_LEFT;
                } else {
                    nextX = [_scrView viewWithTag:ADD_IMAGE_BASETAG+_arrImagePath.count-1].frame.origin.x + ADD_IMAGE_WIDTH + ADD_IMAGE_GAP;
                }
                UIButton *btnImageItem = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnImageItem setImage:image forState:UIControlStateNormal];
                [btnImageItem setFrame:CGRectMake(nextX, ADD_IMAGE_BADGE_WIDTH / 2, ADD_IMAGE_WIDTH, ADD_IMAGE_HEIGHT)];
                [btnImageItem setTag:ADD_IMAGE_BASETAG + _arrImagePath.count];
                //            [btnImageItem addTarget:self action:@selector(btnImageItemClick:) forControlEvents:UIControlEventTouchUpInside];
                [_scrView addSubview:btnImageItem];
                
                [self addDeleteBadgeTo:btnImageItem];
                
                
                [_arrImagePath addObject:fileUrl];
                
                CGRect rect = _btnAdd.frame;
                rect.origin.x = nextX + ADD_IMAGE_WIDTH + ADD_IMAGE_GAP;
                [_btnAdd setFrame:rect];
                //            [_btnAdd setHidden:(_arrImagePath.count >= ADD_IMAGE_MAXCOUNT)];
                
                [_scrView setContentSize:CGSizeMake(rect.origin.x + rect.size.width + 15, _scrView.frame.size.height)];
                [_scrView scrollRectToVisible:rect animated:YES];
            } else {
                [MPAlertView showAlertView:@"图片上传失败，请重试"];
            }
        } withProgressCallback:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud setProgress:progress];
            });
        }];
    });

}

- (void)addDeleteBadgeTo:(UIButton*)btnImage {
    UIButton *btnDeleteBadge = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDeleteBadge setFrame:CGRectMake(btnImage.frame.origin.x + ADD_IMAGE_WIDTH - ADD_IMAGE_BADGE_WIDTH / 2, 0, ADD_IMAGE_BADGE_WIDTH, ADD_IMAGE_BADGE_WIDTH)];
    [btnDeleteBadge setImage:[UIImage imageNamed:@"badge_delete"] forState:UIControlStateNormal];
    [btnDeleteBadge setTag:btnImage.tag - ADD_IMAGE_BASETAG + ADD_IMAGE_BADGE_BASETAG];
    [btnDeleteBadge addTarget:self action:@selector(btnDeleteBadgeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrView addSubview:btnDeleteBadge];
}

- (void)btnDeleteBadgeClick:(UIButton*)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles: nil];
    [actionSheet setTag:ADD_IMAGE_ACTIONSHEET_BADGE_TAG];
    _clickedImageItemIndex = sender.tag - ADD_IMAGE_BADGE_BASETAG;
    [actionSheet showInView:_invokeViewController.view];
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
