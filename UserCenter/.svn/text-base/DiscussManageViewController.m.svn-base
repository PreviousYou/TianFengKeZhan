//
//  DiscussManageViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussManageViewController.h"
#import "HPSegmentView.h"
#import "DiscussSubmittedListView.h"
#import "DiscussReplyListView.h"

@interface DiscussManageViewController ()<HPSegmentViewDelegate>
@property (weak, nonatomic) IBOutlet HPSegmentView *hpSegmentView;
@property (assign, nonatomic) NSInteger selectedType;
@property (strong, nonatomic) NSArray *arrView;
@end

@implementation DiscussManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_hpSegmentView reloadWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) titleArray:@[@"吐槽",@"回帖"]];
    [_hpSegmentView setDelegate:self];
    CGRect rect = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 40);
    DiscussSubmittedListView *discussSubmittedListView = [[DiscussSubmittedListView alloc]initWithFrame:rect];
    DiscussReplyListView *discussReplyListView = [[DiscussReplyListView alloc]initWithFrame:rect];
    [discussSubmittedListView setInvokeViewController:self];
    [discussReplyListView setInvokeViewController:self];
    [discussSubmittedListView setHidden:NO];
    [discussReplyListView setHidden:YES];
    [self.view addSubview:discussSubmittedListView];
    [self.view addSubview:discussReplyListView];
    _arrView = @[discussSubmittedListView, discussReplyListView];
}

- (void)hpSegmentView:(HPSegmentView *)segmentView didClickItemAtIndex:(NSUInteger)index {
    _selectedType = index;
    for (int i=0;i<_arrView.count;i++) {
        UIView *view = _arrView[i];
        [view setHidden:(i!=index)];
    }
}

@end
