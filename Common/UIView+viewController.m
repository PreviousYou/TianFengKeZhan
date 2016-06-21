//
//  UIView+viewController.m
//
//
//  Created by  on 14-11-19.
//  Copyright (c)  All rights reserved.
//

#import "UIView+viewController.h"

@implementation UIView (viewController)

- (UIViewController *)viewController {
// 拿到下一个响应者
    UIResponder *nextRes = self.nextResponder;
    do {
        if ([nextRes isKindOfClass:[UIViewController class]]) {
// 如果响应者是 viewController 则返回
            return (UIViewController *)nextRes;
        }
        nextRes = nextRes.nextResponder;
    } while (nextRes != nil);
    return nil;
}


@end
