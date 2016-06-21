//
//  CompanyObject.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/25.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "CompanyObject.h"

@implementation CompanyObject
@synthesize objectID;
@synthesize name;

- (instancetype)initWithListDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setWithListDictionary:dict];
    }
    return self;
}

- (void)setWithListDictionary:(NSDictionary*)dict {
    objectID = dict[@"id"];
    name = dict[@"company"];
    _taxID = dict[@"taxNo"];
    _password = dict[@"password"];
}

@end
