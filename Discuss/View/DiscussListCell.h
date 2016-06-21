//
//  DiscussListCell.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/24.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DiscussObject.h"

@interface DiscussListCell : BaseTableViewCell
- (void)loadDataWithObject:(DiscussObject*)obj;
@end
