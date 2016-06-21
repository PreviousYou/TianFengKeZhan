//
//  HCEndVideoListViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/31.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HCEndVideoListViewController : BaseTableViewController
/// 分类ID
@property (strong, nonatomic) NSString *categoryID;
/// 分类标题
@property (strong, nonatomic) NSString *categoryTitle;
/// 是否隐藏搜索按钮
@property (assign, nonatomic) BOOL ifHideSearchButton;
/// 搜索关键字
@property (strong, nonatomic) NSString *keyword;

/// 是否来自专栏搜索
@property (assign, nonatomic) BOOL isSubjectSearch;
/// 专栏ID
@property (strong, nonatomic) NSString *subjectID;
@end
