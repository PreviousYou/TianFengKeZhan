//
//  HCEndVideoListViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/31.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HCEndVideoListViewController.h"
#import "MJRefresh.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "VideoObject.h"
#import "HCEndVideoListCell.h"
#import "SearchViewController.h"
#import "WebpageAdvancedViewController.h"

@interface HCEndVideoListViewController ()
@property (strong,nonatomic) NSMutableArray *arrData;
@property (strong,nonatomic) NSString *pageStart;
@property (weak, nonatomic) IBOutlet UIButton *btnNavRight;
@end

@implementation HCEndVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    _arrData = [[NSMutableArray alloc]init];
    [self.tableView.header beginRefreshing];
}

- (void)initViews {
    [_btnNavRight setHidden:_ifHideSearchButton];
    
    [self setTitle:_categoryTitle];
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Refresh/Load
- (void)refreshTableView {
    _pageStart = @"0";
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *strAPIName;
    if (_isSubjectSearch) {
        dict[@"start"] = _pageStart;
        dict[@"subjectId"] = _subjectID;
        dict[@"word"] = _keyword ? _keyword : @"";
        strAPIName = API_SUBJECT_VIDEO_LIST;
    } else {
        dict[@"start"] = _pageStart;
        dict[@"id"] = _categoryID;
        dict[@"word"] = _keyword ? _keyword : @"";
        strAPIName = API_HELP_VIDEO_LIST;
    }
    
    [apiHandler getWithAPIName:strAPIName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strAPIName,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
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
    NSString *strAPIName;
    if (_isSubjectSearch) {
        dict[@"start"] = _pageStart;
        dict[@"subjectId"] = _subjectID;
        dict[@"word"] = _keyword ? _keyword : @"";
        strAPIName = API_SUBJECT_VIDEO_LIST;
    } else {
        dict[@"start"] = _pageStart;
        dict[@"id"] = _categoryID;
        dict[@"word"] = _keyword ? _keyword : @"";
        strAPIName = API_HELP_VIDEO_LIST;
    }
    [apiHandler getWithAPIName:API_HELP_VIDEO_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_HELP_VIDEO_LIST,dictResponse);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_arrData.count + 1) / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCEndVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCEndVideoListCell"];
    VideoObject *objLeft = _arrData[indexPath.row * 2];
    VideoObject *objRight = nil;
    if (indexPath.row * 2 + 1 < _arrData.count) {
        objRight = _arrData[indexPath.row * 2 + 1];
    }
    [cell loadDataWithObjectLeft:objLeft objectRight:objRight];
    [cell setInvokeViewController:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (([UIScreen mainScreen].bounds.size.width -8 -8 -6) / 2) / 15 * 13 + 10; // -8-8-6 is horizontal space, div 2 is to get one view's width, 15:13 is the view's width:height, 10 is for looser.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"categoryTitle":@"搜索结果",
                               @"categoryID":_categoryID,
                               @"ifHideSearchButton":@YES
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeHelpCenterVideo];
    }
}

@end
