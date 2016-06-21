//
//  FavMessageListCell.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleObject.h"

@interface FavMessageListBasicCell : UITableViewCell
- (void)loadDataWithObject:(ArticleObject*)obj;
@end
