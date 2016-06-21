//
//  BaseHandler.h
//  BaseClass
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Handler处理成功时调用的Block
typedef void (^SuccessBlock)(id obj);

/// Handler处理失败时调用的Block
typedef void (^FailedBlock)(id obj);

@interface BaseHandler : NSObject

@end
