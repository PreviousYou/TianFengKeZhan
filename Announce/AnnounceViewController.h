//
//  AnnounceViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, SubjectDataFilter) {
    SubjectDataFilterAll,
    SubjectDataFilterOnlyHomepage,
    SubjectDataFilterOnlySubpage
};
#define SubjectDataFilterDict @{@(SubjectDataFilterOnlyHomepage):@"1", @(SubjectDataFilterOnlySubpage):@"0", @(SubjectDataFilterAll):@""}

@interface AnnounceViewController : BaseTableViewController
/// 专题ID
@property (strong, nonatomic) NSString *subjectID;
/// 专题名称
@property (strong, nonatomic) NSString *subjectTitle;
/// 是否有广告
@property (assign, nonatomic) BOOL ifHasAdvertisement;
/// 数据筛选类型
@property (assign, nonatomic) SubjectDataFilter dataFilter;
/// 搜索关键字
@property (strong, nonatomic) NSString *keyword;
/// 是否隐藏搜索按钮
@property (assign, nonatomic) BOOL ifHideSearchButton;
/// 若为YES，则为通知公告，若为NO，则为专题（由于通知公告的API后来被分离成为一个单独的接口）
@property (assign, nonatomic) BOOL ifAnnounce;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@end
