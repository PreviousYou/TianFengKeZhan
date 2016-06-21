//
//  FavMessageListView.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/26.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussReplyListView.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "DiscussReplyListCell.h"
#import "LoginedUserHandler.h"
#import "FavObject.h"
#import "ReplyDetailViewController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

@interface DiscussReplyListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong,nonatomic) NSString *pageStart;
@end

@implementation DiscussReplyListView

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
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
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
    [apiHandler getWithAPIName:API_REPLY_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_REPLY_LIST,dictResponse);
        if ([dictResponse[@"retcode"]intValue] == 1) {
            [_arrData removeAllObjects];
            [_arrData addObjectsFromArray: dictResponse[@"extra"]];
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
    [apiHandler getWithAPIName:API_REPLY_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_REPLY_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData addObjectsFromArray: dictResponse[@"extra"]];
            _pageStart = dictResponse[@"start"];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            if (((NSArray*)dictResponse[@"extra"]).count == 0) {
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
    NSDictionary *dict = _arrData[indexPath.row];
    NSString *brief = [(@"回复了你：") stringByAppendingString:dict[@"content"]];
    CGRect rect = [brief boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height + 70;  // 80 is the height besides the brief content.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscussReplyListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DiscussReplyListCell" owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithDictionary:_arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReplyDetailViewController *viewController = [_invokeViewController.storyboard instantiateViewControllerWithIdentifier:@"ReplyDetailViewController"];
    NSDictionary *dict = _arrData[indexPath.row];
    [viewController setReplyID:dict[@"id"]];
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
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
    [self addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"replyId"] = _arrData[indexPath.row][@"id"];
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.name;
    dict[@"token"] = [LoginedUserHandler loginedUser].userObj.token;
    [apiHandler getWithAPIName:API_REPLY_DELETE parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_REPLY_DELETE,dictResponse);
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
