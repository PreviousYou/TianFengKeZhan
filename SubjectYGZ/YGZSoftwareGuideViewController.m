//
//  YGZSoftwareGuideViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/6.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "YGZSoftwareGuideViewController.h"
#import "HPSegmentView.h"
#import "YGZSoftwareVideoListView.h"
#import "YGZSoftwareQuesListView.h"
#import "SearchViewController.h"

@interface YGZSoftwareGuideViewController ()<HPSegmentViewDelegate>
@property (weak, nonatomic) IBOutlet HPSegmentView *hpSegmentView;
@property (assign, nonatomic) NSInteger selectedType;
@property (strong, nonatomic) NSArray *arrView;
@end

@implementation YGZSoftwareGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_hpSegmentView reloadWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) titleArray:@[@"视频教程",@"问题解答"]];
    [_hpSegmentView setDelegate:self];
    CGRect rect = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 40);
    YGZSoftwareVideoListView *ygzSoftwareVideoListView = [[YGZSoftwareVideoListView alloc]initWithFrame:rect];
    YGZSoftwareQuesListView *ygzSoftwareQuesListView = [[YGZSoftwareQuesListView alloc]initWithFrame:rect];

    [ygzSoftwareVideoListView setInvokeViewController:self];
    [ygzSoftwareQuesListView setInvokeViewController:self];
    [ygzSoftwareVideoListView setSubjectID:_subjectID];
    [ygzSoftwareQuesListView setSubjectID:_subjectID];
    [ygzSoftwareQuesListView setQuestionType:SubjectQuestionTypeVideo];

    [ygzSoftwareVideoListView setHidden:NO];
    [ygzSoftwareQuesListView setHidden:YES];

    [self.view addSubview:ygzSoftwareVideoListView];
    [self.view addSubview:ygzSoftwareQuesListView];

    _arrView = @[ygzSoftwareVideoListView, ygzSoftwareQuesListView];
}

- (void)hpSegmentView:(HPSegmentView *)segmentView didClickItemAtIndex:(NSUInteger)index {
    _selectedType = index;
    for (int i=0;i<_arrView.count;i++) {
        UIView *view = _arrView[i];
        [view setHidden:(i!=index)];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        
        if (_selectedType == 0) {
            NSDictionary *dict = @{@"subjectID":_subjectID,
                                   @"categoryTitle":@"搜索结果",
                                   @"ifHideSearchButton":@YES,
                                   @"isSubjectSearch":@YES
                                   };
            [viewController setDictExtraParameter:dict];
            [viewController setSearchType:SearchTypeVideo];
        } else {
            NSDictionary *dict = @{@"subjectID":_subjectID,
                                   @"title":@"搜索结果",
                                   @"ifHideSearchButton":@YES,
                                   @"questionType":@(SubjectQuestionTypeVideo)
                                   };
            [viewController setDictExtraParameter:dict];
            [viewController setSearchType:SearchTypeQuestion];
        }
    }
}

@end
