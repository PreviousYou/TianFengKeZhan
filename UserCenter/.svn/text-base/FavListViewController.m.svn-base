//
//  FavListViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "FavListViewController.h"
#import "HPSegmentView.h"
#import "FavMessageListView.h"
#import "FavDiscussListView.h"
#import "FavVideoListView.h"

@interface FavListViewController ()<HPSegmentViewDelegate>
@property (weak, nonatomic) IBOutlet HPSegmentView *hpSegmentView;
@property (assign, nonatomic) NSInteger selectedType;
@property (strong, nonatomic) NSArray *arrView;
@end

@implementation FavListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_hpSegmentView reloadWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) titleArray:@[@"信息",@"帖子",@"视频"]];
    [_hpSegmentView setDelegate:self];
    CGRect rect = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 40);
    FavMessageListView *favMessageListView = [[FavMessageListView alloc]initWithFrame:rect];
    FavDiscussListView *favDiscussListView = [[FavDiscussListView alloc]initWithFrame:rect];
    FavVideoListView *favVideoListView = [[FavVideoListView alloc]initWithFrame:rect];
    [favMessageListView setInvokeViewController:self];
    [favDiscussListView setInvokeViewController:self];
    [favVideoListView setInvokeViewController:self];
    [favMessageListView setHidden:NO];
    [favDiscussListView setHidden:YES];
    [favVideoListView setHidden:YES];
    [self.view addSubview:favMessageListView];
    [self.view addSubview:favDiscussListView];
    [self.view addSubview:favVideoListView];
    _arrView = @[favMessageListView, favDiscussListView, favVideoListView];
}

- (void)hpSegmentView:(HPSegmentView *)segmentView didClickItemAtIndex:(NSUInteger)index {
    _selectedType = index;
    for (int i=0;i<_arrView.count;i++) {
        UIView *view = _arrView[i];
        [view setHidden:(i!=index)];
    }
}

@end
