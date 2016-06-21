//
//  FavVideoListView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "FavVideoListView.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "FavVideoListCell.h"
#import "LoginedUserHandler.h"
#import "FavObject.h"
#import "UIStoryboard+SAGetter.h"
#import "WebpageAdvancedViewController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

@interface FavVideoListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong,nonatomic) NSString *pageStart;
@end

@implementation FavVideoListView

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
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    dict[@"type"] = @"1";
    [apiHandler getWithAPIName:API_FAVOURITE_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_FAVOURITE_LIST,dictResponse);
        if ([dictResponse[@"retcode"]intValue] == 1) {
            [_arrData removeAllObjects];
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                FavObject *obj = [[FavObject alloc]initWithListDictionary:dictItem contentType:FavContentTypeVideo];
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
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    dict[@"type"] = @"1";
    [apiHandler getWithAPIName:API_FAVOURITE_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_FAVOURITE_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                FavObject *obj = [[FavObject alloc]initWithListDictionary:dictItem contentType:FavContentTypeVideo];
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
    FavObject *favObj = _arrData[indexPath.row];
    VideoObject *videoObj = (VideoObject*)favObj.contentObj;
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
    FavObject *favObj = _arrData[indexPath.row];
    [cell loadDataWithObject:(VideoObject*)favObj.contentObj];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeVideoID];
    FavObject *favObj = _arrData[indexPath.row];
    VideoObject *videoObj = (VideoObject*)favObj.contentObj;
    [viewController setWebpageID:videoObj.objectID];
    [_invokeViewController.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:_invokeViewController.view];
    [_invokeViewController.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    FavObject *obj = _arrData[indexPath.row];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"storeId"] = obj.objectID;
    dict[@"account"] = [LoginedUserHandler loginedUser].userObj.name;
    dict[@"token"] = [LoginedUserHandler loginedUser].userObj.token;
    [apiHandler getWithAPIName:API_FAVOURITE_DELETE parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_FAVOURITE_DELETE,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dictResponse[@"retmsg"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    } failed:^(NSString *errorMessage) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }];
}
@end
