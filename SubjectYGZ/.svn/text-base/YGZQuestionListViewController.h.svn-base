//
//  YGZQuestionListViewController.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewController.h"

/// 问题类型枚举
typedef NS_ENUM(NSUInteger, SubjectQuestionType) {
    /// 未定义
    SubjectQuestionTypeUndefined,
    /// 专栏常见问题
    SubjectQuestionTypeFrequent,
    /// 专栏操作流程
    SubjectQuestionTypeOperate,
    /// 专栏软件操作解答(视频教程)-问题解答
    SubjectQuestionTypeVideo,
    /// 首页问题搜索
    SubjectQuestionTypeHomepage
};
#define SubjectQuestionTypeDict @{@(SubjectQuestionTypeUndefined):@"", @(SubjectQuestionTypeFrequent):@"1", @(SubjectQuestionTypeOperate):@"2", @(SubjectQuestionTypeVideo):@"3", @(SubjectQuestionTypeHomepage):@""}

@interface YGZQuestionListViewController : BaseTableViewController
/// 专栏ID
@property (strong, nonatomic) NSString *subjectID;
/// 问题类型
@property (assign, nonatomic) SubjectQuestionType questionType;
/// 是否隐藏搜索按钮
@property (assign, nonatomic) BOOL ifHideSearchButton;
/// 搜索关键字
@property (strong, nonatomic) NSString *keyword;
@end
