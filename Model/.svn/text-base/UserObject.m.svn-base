//
//  UserObject.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject
/// 用户ID
@synthesize objectID;
/// 用户名
@synthesize name;
/// 用户头像地址
@synthesize imagePath;

- (instancetype)initWithLoginDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setWithLoginDictionary:dict];
    }
    return self;
}

- (instancetype)initWithInformationDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setWithInformationDictionary:dict];
    }
    return self;
}

- (void)setWithLoginDictionary:(NSDictionary*)dict {
    objectID = dict[@"id"];
    name = dict[@"account"];
    imagePath = [dict[@"headerImg"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _nickName = dict[@"nick"];
    _grade = dict[@"grade"];
    _score = [dict[@"score"] intValue];
    _arrCompany = [[NSMutableArray alloc]init];
    _token = dict[@"token"];
    for (NSDictionary *dictItem in dict[@"companyList"]) {
        CompanyObject *obj = [[CompanyObject alloc]initWithListDictionary:dictItem];
        [_arrCompany addObject:obj];
    }
}

- (void)setWithInformationDictionary:(NSDictionary*)dict {
    objectID = dict[@"id"];
    name = dict[@"account"];
    imagePath = [dict[@"headerImg"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _nickName = dict[@"nick"];
    _grade = dict[@"grade"];
    _score = [dict[@"score"] intValue];
    _arrCompany = [[NSMutableArray alloc]init];
    for (NSDictionary *dictItem in dict[@"companyList"]) {
        CompanyObject *obj = [[CompanyObject alloc]initWithListDictionary:dictItem];
        [_arrCompany addObject:obj];
    }
    _unreadMessageCount = [dict[@"myNewsNum"] intValue];
}

- (void)reset {
    objectID = @"";
    name = @"";
    imagePath = @"";
    _nickName = @"";
    _grade = @"";
    _level = @"";
    _score = 0;
    _token = @"";
    [_arrCompany removeAllObjects];
}
@end
