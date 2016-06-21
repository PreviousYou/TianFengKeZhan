//
//  ArticleObject.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/20.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ArticleObject.h"

@implementation ArticleObject
@synthesize objectID;
@synthesize name;
@synthesize imagePath;

- (instancetype)initWithListDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setWithListDictionary:dict];
    }
    return self;
}

- (void)setWithListDictionary:(NSDictionary*)dict {
    objectID = dict[@"id"];
    name = dict[@"title"];
    imagePath = [dict[@"imgUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _brief = dict[@"summary"];
    _status = [dict[@"status"] intValue];
}

- (instancetype)initWithFavDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setWithFavDictionary:dict];
    }
    return self;
}

- (void)setWithFavDictionary:(NSDictionary*)dict {
    objectID = dict[@"storeContentId"];
    name = dict[@"title"];
    imagePath = [dict[@"imgUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _brief = dict[@"summary"];
    _status = [dict[@"status"] intValue];
}
@end
