//
//  AppDelegate+DynamicMethod.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/20.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "AppDelegate+DynamicMethod.h"
#import "CommonFunction.h"
#import "APIHandler.h"
#define TabbarDataFilePath [NSString stringWithFormat:@"%@/TabbarData.plist", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@implementation AppDelegate (DynamicMethod)

- (NSArray*)getTabbarData {
    [CommonFunction copyFileIfNeed:[[NSBundle mainBundle] pathForResource:@"TabbarData" ofType:@"plist"] copyFilePath:TabbarDataFilePath];
    NSArray *arrData = [[NSArray alloc] initWithContentsOfFile:TabbarDataFilePath];
    [self updateTabbarDataFromServer];
    return arrData;
}

- (void)saveTabbarData:(NSArray *)arrData {
    if (arrData && [arrData count]>0) {
        [arrData writeToFile:TabbarDataFilePath atomically:YES];
    }
}

- (void)updateTabbarDataFromServer {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_MENU_LIST parameters:@{@"position":@"2"} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_MENU_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrData = dictResponse[@"extra"];
            if (arrData && arrData.count > 0) {
                [self saveTabbarData:arrData];
            }
        }
    } failed:^(NSString *errorMessage) {
        SALog(errorMessage);
    }];
}

@end
