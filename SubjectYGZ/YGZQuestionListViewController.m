//
//  YGZQuestionListViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "YGZQuestionListViewController.h"
#import "SAImageUtility.h"
#import "YGZBasicCell.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "WebpageAdvancedViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "SearchViewController.h"
#import <MJRefresh.h>

@interface YGZQuestionListViewController ()
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) NSString *pageStart;
@property (weak, nonatomic) IBOutlet UIButton *btnNavRight;
@end

@implementation YGZQuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    _arrData = [[NSMutableArray alloc]init];
    [self.tableView.header beginRefreshing];
}

- (void)initViews {
    [_btnNavRight setHidden:_ifHideSearchButton];
    
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YGZBasicCell" bundle:nil] forCellReuseIdentifier:@"YGZBasicCell"];
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
    if (_questionType == SubjectQuestionTypeHomepage) {
        strAPIName = API_HOME_QUESTION_LIST;
        dict[@"start"] = _pageStart;
        dict[@"word"] = _keyword ? _keyword : @"";
    } else {
        strAPIName = API_SUBJECT_QUESTION_LIST;
        dict[@"start"] = _pageStart;
        dict[@"subjectId"] = _subjectID;
        dict[@"type"] = SubjectQuestionTypeDict[@(_questionType)];
        dict[@"word"] = _keyword ? _keyword : @"";
    }
    
    [apiHandler getWithAPIName:strAPIName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strAPIName,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData removeAllObjects];
            [_arrData addObjectsFromArray:dictResponse[@"extra"]];
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
    if (_questionType == SubjectQuestionTypeHomepage) {
        strAPIName = API_HOME_QUESTION_LIST;
        dict[@"start"] = _pageStart;
        dict[@"word"] = _keyword ? _keyword : @"";
    } else {
        strAPIName = API_SUBJECT_QUESTION_LIST;
        dict[@"start"] = _pageStart;
        dict[@"subjectId"] = _subjectID;
        dict[@"type"] = SubjectQuestionTypeDict[@(_questionType)];
        dict[@"word"] = _keyword ? _keyword : @"";
    }
    [apiHandler getWithAPIName:strAPIName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strAPIName,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData addObjectsFromArray:dictResponse[@"extra"]];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static YGZBasicCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"YGZBasicCell"];
    });
    NSDictionary *dictItem = _arrData[indexPath.row];
    [sizingCell.lblTitle setText:dictItem[@"title"]];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YGZBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGZBasicCell"];
    NSDictionary *dictItem = _arrData[indexPath.row];
    [cell.lblTitle setText:dictItem[@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeQuestionID];
    NSDictionary *dictItem = _arrData[indexPath.row];
    [viewController setWebpageID:dictItem[@"id"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"subjectID":_subjectID,
                               @"title":@"搜索结果",
                               @"ifHideSearchButton":@YES,
                               @"questionType":@(_questionType)
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeQuestion];
    }
}

@end
