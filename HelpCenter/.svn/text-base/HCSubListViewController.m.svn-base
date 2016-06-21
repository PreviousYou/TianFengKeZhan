//
//  HCSubListViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/31.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HCSubListViewController.h"
#import "SAImageUtility.h"
#import "HCSubListCell.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "HCSubListViewController.h"
#import "HCEndQuestionListViewController.h"
#import "HCEndVideoListViewController.h"
#import "SearchViewController.h"
#import <MJRefresh.h>

@interface HCSubListViewController ()
@property (strong, nonatomic) NSMutableArray *arrData;
@end

@implementation HCSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    _arrData = [[NSMutableArray alloc]init];
    [self.tableView.header beginRefreshing];
}

- (void)initViews {
    [self setTitle:_dictBase[@"name"]];
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshTableView {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"id"] = _dictBase[@"id"];
    [apiHandler getWithAPIName:API_HELP_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_HELP_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData removeAllObjects];
            [_arrData addObjectsFromArray:dictResponse[@"extra"]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static HCSubListCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"HCSubListCell"];
    });
    NSDictionary *dictItem = _arrData[indexPath.row];
    [sizingCell.lblTitle setText:dictItem[@"name"]];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCSubListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCSubListCell"];
    NSDictionary *dictItem = _arrData[indexPath.row];
    [cell.lblTitle setText:dictItem[@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictItem = _arrData[indexPath.row];
    if ([dictItem[@"isLeaf"] intValue] == 0) {
        // 进入子类别列表
        HCSubListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HCSubListViewController"];
        [viewController setDictBase:dictItem];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        if ([dictItem[@"type"] intValue] == 0) {
            // 进入问题列表
            HCEndQuestionListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HCEndQuestionListViewController"];
            [viewController setCategoryID:dictItem[@"id"]];
            [viewController setCategoryTitle:dictItem[@"name"]];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            // 进入视频列表
            HCEndVideoListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HCEndVideoListViewController"];
            [viewController setCategoryID:dictItem[@"id"]];
            [viewController setCategoryTitle:dictItem[@"name"]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"categoryTitle":@"搜索结果",
                               @"categoryID":_dictBase[@"id"],
                               @"ifHideSearchButton":@YES
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeHelpCenterQuestion];
    }
}
@end
