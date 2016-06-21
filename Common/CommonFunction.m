//
//  CommonFunction.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/20.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "CommonFunction.h"

@implementation CommonFunction

+ (void)copyFileIfNeed:(NSString *)fromFilePath copyFilePath:(NSString *)toFilePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:toFilePath]) {
        if (![fileManager copyItemAtPath:fromFilePath toPath:toFilePath error:&error]) {
            NSLog(@"Copy error : %@",[error localizedDescription]);
        }
    } else {
        NSLog(@"file exist!");
    }
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (NSString*)compareCurrentTime:(NSDate*)compareDate {
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    } else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        result = [formatter stringFromDate:compareDate];
    }
    return result;
}

+ (void)setStyleOfLGAlertView:(LGAlertView*)alertView {
    [alertView setCancelButtonBackgroundColor:[UIColor colorWithRed:0.278 green:0.588 blue:0.153 alpha:1.000]];
    [alertView setButtonsBackgroundColor:[UIColor colorWithRed:0.278 green:0.588 blue:0.153 alpha:1.000]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithRed:0.222 green:0.476 blue:0.125 alpha:1.000]];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithRed:0.222 green:0.476 blue:0.125 alpha:1.000]];
    [alertView setButtonsTitleColor:[UIColor whiteColor]];
    [alertView setCancelButtonTitleColor:[UIColor whiteColor]];
}
@end
