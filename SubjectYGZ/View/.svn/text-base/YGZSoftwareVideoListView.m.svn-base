//
//  YGZSoftwareVideoListView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/6.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "YGZSoftwareVideoListView.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "FavVideoListCell.h"
#import "VideoObject.h"
#import "UIStoryboard+SAGetter.h"
#import "WebpageAdvancedViewController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

@interface YGZSoftwareVideoListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong,nonatomic) NSString *pageStart;
@end

@implementation YGZSoftwareVideoListView

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden && _arrData.count == 0) {
        [_tableView.header beginRefreshing];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        _arrData = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)initViews {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.910 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

#pragma mark - TableView Refresh/Load
- (void)refreshTableView {
    _pageStart = @"0";
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"start"] = _pageStart;
    dict[@"subjectId"] = _subjectID;
    [apiHandler getWithAPIName:API_SUBJECT_VIDEO_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_SUBJECT_VIDEO_LIST,dictResponse);
        if ([dictResponse[@"retcode"]intValue] == 1) {
            [_arrData removeAllObjects];
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                VideoObject *obj = [[VideoObject alloc]initWithListDictionary:dictItem];
                [_arrData addObject:obj];
            }
            _pageStart = dictResponse[@"start"];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer resetNoMoreData];
            // 无数据背景图
            if (_arrData.count == 0) {
                [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]]];
                [self.tableView.backgroundView setContentMode:UIViewContentModeCenter];
            } else {
                [self.tableView setBackgroundView:nil];
            }
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
            [self.tableView.header endRefreshing];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
        [self.tableView.header endRefreshing];
        [_arrData removeAllObjects];
        [self.tableView reloadData];
        // 网络请求失败背景图
        [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"networkfail"]]];
        [self.tableView.backgroundView setContentMode:UIViewContentModeCenter];
    }];
}

- (void)loadNextPage {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"start"] = _pageStart;
    dict[@"subjectId"] = _subjectID;
    [apiHandler getWithAPIName:API_SUBJECT_VIDEO_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_SUBJECT_VIDEO_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                VideoObject *obj = [[VideoObject alloc]initWithListDictionary:dictItem];
                [_arrData addObject:obj];
            }
            _pageStart = dictResponse[@"start"];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            if (arrList.count == 0) {
                [self.tableView.footer noticeNoMoreData];
            }
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
            [self.tableView.footer endRefreshing];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
        [self.tableView.footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ([UIScreen mainScreen].bounds.size.width - 10) * 17 / 31; // -10 is the view's left and right space, 31:17 is the image's width:height.
    VideoObject *videoObj = _arrData[indexPath.row];
    CGRect rect = [videoObj.name boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10 - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil]; // -10 is the view's left and right space, -16 is the label's left and right space.
    height += rect.size.height;
    height += (5+5+4+8); // the first two 5 is the view's top and bottom space, 4 is the label's top space, 8 is the label's bottom space.
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavVideoListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FavVideoListCell" owner:self options:nil] firstObject];
    }
    [cell setInvokeViewController:_invokeViewController];
    [cell loadDataWithObject:_arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeVideoID];
    VideoObject *videoObj = _arrData[indexPath.row];
    [viewController setWebpageID:videoObj.objectID];
    [_invokeViewController.navigationController pushViewController:viewController animated:YES];
}

@end
