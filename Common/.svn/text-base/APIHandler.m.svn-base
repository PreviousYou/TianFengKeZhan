//
//  APIHandler.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/13.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "APIHandler.h"
#import "AFNetworking.h"
#import "AppConfig.h"
#import "LoginedUserHandler.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIStoryboard+SAGetter.h"
#import "MPAlertView.h"

#define ERRORMESSAGE_NETWORK @"网络状况不佳，请稍后再试"
#define LOGIN_VIEWCONTROLLER_ID @"LoginViewController"

@implementation APIHandler

- (instancetype)init {
    return [self initWithBaseURL:CONFIG_API_ROOT_URL delegate:nil];
}

- (instancetype)initWithDelegate:(id<APIHandlerDelegate>)delegate {
    return [self initWithBaseURL:CONFIG_API_ROOT_URL delegate:delegate];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url delegate:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url delegate:(id<APIHandlerDelegate>)delegate {
    if (self = [super initWithBaseURL:url])
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self resetHTTPHeader];
        _delegate = delegate;
    }
    return self;
}

- (void)resetHTTPHeader {
//    [self.requestSerializer setValue:@"0" forHTTPHeaderField:@"sblx"];
//    [self.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"ver"];
    [self.requestSerializer setValue:[LoginedUserHandler loginedUser].userObj.objectID forHTTPHeaderField:@"memberId"];
    [self.requestSerializer setValue:[LoginedUserHandler loginedUser].userObj.token forHTTPHeaderField:@"token"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

- (void)getWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter {
    [self GET:strAPIName parameters:dictParameter success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didSuccessWithResponse:apiName:)]) {
            [_delegate apiHandler:self didSuccessWithResponse:responseObject apiName:strAPIName];
        }
        [self detectTokenOutOfDate:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didFailedWithErrorMessage:apiName:)]) {
            [_delegate apiHandler:self didFailedWithErrorMessage:ERRORMESSAGE_NETWORK apiName:strAPIName];
        }
    }];
}

- (void)getWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter success:(SuccessBlock)success failed:(FailedBlock)failed {
    [self GET:strAPIName parameters:dictParameter success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
        [self detectTokenOutOfDate:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(ERRORMESSAGE_NETWORK);
    }];
}

- (void)postWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter {
    [self POST:strAPIName parameters:dictParameter success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didSuccessWithResponse:apiName:)]) {
            [_delegate apiHandler:self didSuccessWithResponse:responseObject apiName:strAPIName];
        }
        [self detectTokenOutOfDate:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didFailedWithErrorMessage:apiName:)]) {
            [_delegate apiHandler:self didFailedWithErrorMessage:ERRORMESSAGE_NETWORK apiName:strAPIName];
        }
    }];
}

- (void)postWithAPIName:(NSString*)strAPIName parameters:(NSDictionary*)dictParameter success:(SuccessBlock)success failed:(FailedBlock)failed {
    [self POST:strAPIName parameters:dictParameter success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
        [self detectTokenOutOfDate:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(ERRORMESSAGE_NETWORK);
    }];
}

- (void)getVerificationCodeWithPhone:(NSString*)phone type:(NSInteger)type success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSString *strAPIName = API_GET_VERIFICATION;
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc]init];
    [dictParameter setValue:phone forKey:@"phone"];
    [dictParameter setValue:[NSNumber numberWithInteger:type] forKey:@"flag"];
    
    [self GET:strAPIName parameters:dictParameter success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(ERRORMESSAGE_NETWORK);
    }];
}

- (void)getVerificationCodeWithPhone:(NSString*)phone type:(NSInteger)type {
    NSString *strAPIName = API_GET_VERIFICATION;
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc]init];
    [dictParameter setValue:phone forKey:@"phone"];
    [dictParameter setValue:[NSNumber numberWithInteger:type] forKey:@"flag"];
    
    [self GET:strAPIName parameters:dictParameter success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didSuccessWithResponse:apiName:)]) {
            [_delegate apiHandler:self didSuccessWithResponse:responseObject apiName:strAPIName];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didFailedWithErrorMessage:apiName:)]) {
            [_delegate apiHandler:self didFailedWithErrorMessage:ERRORMESSAGE_NETWORK apiName:strAPIName];
        }
    }];
}

- (void)uploadFileWithData:(NSData*)data type:(NSInteger)type {
    NSString *strAPIName = API_FILE_UPLOAD;
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc]init];
    [dictParameter setValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    [self POST:strAPIName parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *strFileName;
        NSString *strMimeType;
        if (type == 1 || type == 2) {
            strFileName = @"file.jpg";
            strMimeType = @"image/jpeg";
        }
        else if (type == 3) {
            strFileName = @"file.m4a";
            strMimeType = @"audio/mp4a-latm";
        }
        else {
            strFileName = @"file";
            strMimeType = @"multipart/form-data";
        }
        [formData appendPartWithFileData:data name:@"file" fileName:strFileName mimeType:strMimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didSuccessWithResponse:apiName:)]) {
            [_delegate apiHandler:self didSuccessWithResponse:responseObject apiName:strAPIName];
        }
        [self detectTokenOutOfDate:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([_delegate respondsToSelector:@selector(apiHandler:didFailedWithErrorMessage:apiName:)]) {
            [_delegate apiHandler:self didFailedWithErrorMessage:ERRORMESSAGE_NETWORK apiName:strAPIName];
        }
    }];
}

- (void)uploadFileWithData:(NSData*)data type:(NSInteger)type success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSString *strAPIName = API_FILE_UPLOAD;
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc]init];
    [dictParameter setValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    [self POST:strAPIName parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *strFileName;
        NSString *strMimeType;
        strFileName = @"file.jpg";
        strMimeType = @"image/jpeg";
        /*
        if (type == 1 || type == 2) {
            strFileName = @"file.jpg";
            strMimeType = @"image/jpeg";
        } else if (type == 3) {
            strFileName = @"file.m4a";
            strMimeType = @"audio/mp4a-latm";
        } else {
            strFileName = @"file";
            strMimeType = @"multipart/form-data";
        }
         */
        [formData appendPartWithFileData:data name:@"file" fileName:strFileName mimeType:strMimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
        [self detectTokenOutOfDate:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(ERRORMESSAGE_NETWORK);
    }];
}

- (void)downloadFileWithURL:(NSURL*)url saveToDocumentFile:(NSString*)filename success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        [data writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename] atomically:YES];
        success(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ downloading error : %@", url, [error localizedDescription]);
        failed(nil);
    }];
    [downloadRequest start];
}

- (void)detectTokenOutOfDate:(NSDictionary*)dictResponse {
    if ([dictResponse[@"retcode"] intValue] == 401) {
        // 将用户登出，回到首页tabBarItem，并弹出登录页
        [[LoginedUserHandler loginedUser] logout];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController*)delegate.window.rootViewController;
        [tabBarController setSelectedIndex:0];
        LoginViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateInitialViewController];
        [(UINavigationController *)tabBarController.selectedViewController popToRootViewControllerAnimated:NO];
        [(UINavigationController *)tabBarController.selectedViewController pushViewController:viewController animated:YES];
        [MPAlertView showAlertView:@"登录超时，请重新登录"];
    }
}

void SALog(NSString* format, ...) {
#ifdef DEBUG
    va_list argList;
    va_start(argList, format);
    NSString *strLog = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    NSLog(@"[SALog] %@",strLog);
#endif
}
@end
