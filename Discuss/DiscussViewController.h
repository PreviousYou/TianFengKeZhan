//
//  DiscussViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewController.h"

@interface DiscussViewController : BaseTableViewController
/// 是否需要刷新
@property (assign, nonatomic) BOOL ifNeedRefresh;
/// 是否隐藏搜索按钮
@property (assign, nonatomic) BOOL ifHideSearchButton;
/// 是否隐藏发帖按钮
@property (assign, nonatomic) BOOL ifHideNewButton;
/// 搜索关键字
@property (strong, nonatomic) NSString *keyword;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@end
