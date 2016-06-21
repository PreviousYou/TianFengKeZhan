//
//  YGZSoftwareQuesListView.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/6.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, SubjectQuestionType) {
    SubjectQuestionTypeUndefined,
    SubjectQuestionTypeFrequent,
    SubjectQuestionTypeOperate,
    SubjectQuestionTypeVideo
};
#define SubjectQuestionTypeDict @{@(SubjectQuestionTypeUndefined):@"", @(SubjectQuestionTypeFrequent):@"1", @(SubjectQuestionTypeOperate):@"2", @(SubjectQuestionTypeVideo):@"3"}

@interface YGZSoftwareQuesListView : BaseView
@property (strong, nonatomic) NSString *subjectID;
@property (strong, nonatomic) UIViewController *invokeViewController;
@property (assign, nonatomic) SubjectQuestionType questionType;
@end
