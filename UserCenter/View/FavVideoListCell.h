//
//  FavVideoListCell.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"

@interface FavVideoListCell : UITableViewCell
@property (strong, nonatomic) UIViewController *invokeViewController;
- (void)loadDataWithObject:(VideoObject*)obj;
@end
