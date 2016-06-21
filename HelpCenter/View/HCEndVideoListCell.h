//
//  HCEndVideoListCell.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/1.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "VideoObject.h"

@interface HCEndVideoListCell : BaseTableViewCell
@property (strong, nonatomic) UIViewController *invokeViewController;
- (void)loadDataWithObjectLeft:(VideoObject*)objLeft objectRight:(VideoObject*)objRight;
@end
