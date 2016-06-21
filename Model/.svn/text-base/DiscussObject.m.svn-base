//
//  DiscussObject.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussObject.h"

@implementation DiscussObject
@synthesize objectID;
@synthesize imagePath;

- (instancetype)initWithListDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        _userObj = [[UserObject alloc]init];
        [self setWithListDictionary:dict];
    }
    return self;
}

- (instancetype)initWithFavDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        _userObj = [[UserObject alloc]init];
        [self setWithFavDictionary:dict];
    }
    return self;
}

- (void)setWithListDictionary:(NSDictionary*)dict {
    objectID = dict[@"postId"];
    _status = [dict[@"type"] intValue];
    _brief = dict[@"summary"];
    imagePath = dict[@"imgs"];
    _browseCount = [dict[@"viewCount"] intValue];
    _commentCount = [dict[@"commentCount"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _createDate = [formatter dateFromString:dict[@"createDate"]];
    _favCount = [dict[@"storeCount"] intValue];
    _userObj.nickName = dict[@"nick"];
    _userObj.imagePath = dict[@"headerImg"];
    _userObj.grade = dict[@"grade"];
    _userObj.level = dict[@"level"];
}

- (void)setWithFavDictionary:(NSDictionary*)dict {
    objectID = dict[@"storeContentId"];
    _status = [dict[@"type"] intValue];
    _brief = dict[@"summary"];
    imagePath = dict[@"imgs"];
    _browseCount = [dict[@"viewCount"] intValue];
    _commentCount = [dict[@"commentCount"] intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _createDate = [formatter dateFromString:dict[@"createDate"]];
    _favCount = [dict[@"storeCount"] intValue];
    _userObj.nickName = dict[@"nick"];
    _userObj.imagePath = dict[@"headerImg"];
    _userObj.grade = dict[@"grade"];
    _userObj.level = dict[@"level"];
}
@end
