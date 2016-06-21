//
//  AdObject.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "AdObject.h"
#import "AppConfig.h"

@implementation AdObject
- (instancetype)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        if ([dict[@"reqType"] intValue] == 0) {
            _adID = [NSString stringWithFormat:@"%@%@",CONFIG_API_ROOT, dict[@"reqUrl"]];
        } else {
            _adID = dict[@"reqUrl"];
        }
        _imagePath = dict[@"imgUrl"];
        _adTitle = dict[@"title"];
    }
    return self;
}

- (instancetype)initWithSubjectDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        _adID = dict[@"id"];
        _imagePath = [dict[@"imgUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _adTitle = dict[@"title"];
    }
    return self;
}

- (instancetype)initWithAnnounceDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        _adID = dict[@"id"];
        _imagePath = [dict[@"bannerImg"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _adTitle = dict[@"title"];
    }
    return self;
}

@end
