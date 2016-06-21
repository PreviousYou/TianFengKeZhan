//
//  FavObject.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/27.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "FavObject.h"
#import "DiscussObject.h"
#import "VideoObject.h"
#import "ArticleObject.h"

@implementation FavObject
/// 收藏ID
@synthesize objectID;

- (instancetype)initWithListDictionary:(NSDictionary*)dict contentType:(FavContentType)type {
    if (self = [super init]) {
        [self setWithListDictionary:dict contentType:type];
    }
    return self;
}

- (void)setWithListDictionary:(NSDictionary*)dict contentType:(FavContentType)type {
    objectID = dict[@"storeId"];
    _contentType = type;
    switch (type) {
        case FavContentTypeQuestion:
        case FavContentTypeArticle: {
            _contentObj = [[ArticleObject alloc]initWithFavDictionary:dict];
            if ([dict[@"type"] intValue] == 0) {
                _contentType = FavContentTypeQuestion;
            } else {
                _contentType = FavContentTypeArticle;
            }
            break;
        }
        case FavContentTypeVideo: {
            _contentObj = [[VideoObject alloc]initWithFavDictionary:dict];
            break;
        }
        case FavContentTypeDiscuss: {
            _contentObj = [[DiscussObject alloc]initWithFavDictionary:dict];
            break;
        }
        default:
            break;
    }
}
@end
