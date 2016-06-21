//
//  VideoObject.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/27.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "VideoObject.h"

@implementation VideoObject
@synthesize objectID;
@synthesize name;
@synthesize imagePath;
@synthesize createTime;

- (instancetype)initWithListDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        [self setWithListDictionary:dict];
    }
    return self;
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
}

- (void)setWithListDictionary:(NSDictionary*)dict {
    objectID = dict[@"id"];
    name = dict[@"title"];
    imagePath = [dict[@"imgUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
