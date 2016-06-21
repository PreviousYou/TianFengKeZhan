//
//  WebpageNativeObject.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/28.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "WebpageNativeObject.h"
#import "MPAlertView.h"

@implementation WebpageNativeObject

- (void)initData:(NSString*)para {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[para dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    _replyEnabled = ([dict[@"isReply"] intValue] == 1);
    _reportEnabled = ([dict[@"isReport"] intValue] == 1);
    _favEnabled = ([dict[@"isCollect"] intValue] == 1);
    _shareEnabled = ([dict[@"isShare"] intValue] == 1);
    _shareContent = dict[@"shareContent"];
    _shareImagePath = dict[@"shareImgUrl"];
    _shareUrl = dict[@"shareUrl"];
    _authorNickName = dict[@"publishMemberNick"];
    _replyAuthorMethod = dict[@"replySubjectCallBack"];
    _replyFloorMethod = dict[@"replySomeOneCallBack"];
    _favMethod = dict[@"collectCallBack"];
    _reportMethod = dict[@"reportCallBack"];
    [_delegate configReceived];
}

- (void)repleySomeone:(NSString *)targetName {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[targetName dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        [_delegate replyFloor:dict[@"targetName"]];
    });
}

- (void)showImgs:(NSString*)imgsInfo {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[imgsInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSArray *arrImagePath = [dict[@"imgsStr"] componentsSeparatedByString:@","];
    [_delegate showImageBrowser:arrImagePath atIndex:[dict[@"curIndex"] intValue]];
}

- (void)showToast:(NSString*)toast {
    [MPAlertView showAlertView:toast];
}

@end
