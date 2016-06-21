//
//  AnnounceViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "AnnounceViewController.h"
#import "HPAdView.h"
#import "ArticleListCell.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "ArticleObject.h"
#import "WebpageViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "AdObject.h"
#import "WebpageAdvancedViewController.h"
#import "SearchViewController.h"
#import <MJRefresh.h>

@interface AnnounceViewController ()<HPAdViewDelegate>
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) HPAdView *hpAdView;
@property (assign, nonatomic) int pageStart;
@property (strong, nonatomic) NSMutableArray *arrAdObject; //广告数据

@property (weak, nonatomic) IBOutlet UIButton *btnNavRight;
@end

@implementation AnnounceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [[NSMutableArray alloc]init];
    [self initViews];
    if (_ifHasAdvertisement) {
        [self loadAdvertisement];
    }
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_btnNavRight setHidden:_ifHideSearchButton];
    [self setTitle:_subjectTitle ? _subjectTitle : @"动态列表"];
    if (_ifHasAdvertisement) {
        _hpAdView = [[HPAdView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 5 / 16) adObjectArray:@[]];
        [_hpAdView setDelegate:self];
        [_hpAdView setPlaceholderImage:[UIImage imageNamed:@"placeholder_320x100"]];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleListCell" bundle:nil] forCellReuseIdentifier:@"ArticleListCell"];
    
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListCell"];
    [cell loadDataWithObject:_arrData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85 * [UIScreen mainScreen].bounds.size.width / 320;  //列表区域
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleObject *obj = _arrData[indexPath.row];
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeID];
    [viewController setWebpageID:obj.objectID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)hpAdView:(HPAdView *)adView clickedAtIndex:(NSUInteger)index {
    AdObject *adObj = _arrAdObject[index];
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeID];
    [viewController setWebpageID:adObj.adID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadAdvertisement {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_ANNOUNCE_ADVERTISE_LIST parameters:nil success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_ANNOUNCE_ADVERTISE_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrAdList = dictResponse[@"extra"];
            if (arrAdList.count <= 0) {
                [self.tableView setTableHeaderView:nil];
            } else {
                _arrAdObject = [[NSMutableArray alloc]init];
                for (NSDictionary *dictItem in arrAdList) {
                    AdObject *obj = [[AdObject alloc]initWithAnnounceDictionary:dictItem];
                    [_arrAdObject addObject:obj];
                }
                [_hpAdView reloadAdObjectArr:_arrAdObject];
                [self.tableView setTableHeaderView:_hpAdView];
            }
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
    }];
}

#pragma mark - TableView Refresh/Load
- (void)refreshTableView {
    _pageStart = 0;
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *strAPIName;
    if (_ifAnnounce) {
        strAPIName = API_ANNOUNCE_ARTICLE_LIST;
        dict[@"start"] = @(_pageStart);
        dict[@"word"] = _keyword ? _keyword : @"";
    } else {
        strAPIName = API_SUBJECT_ARTICLE_LIST;
        dict[@"start"] = @(_pageStart);
        dict[@"isIndex"] = SubjectDataFilterDict[@(_dataFilter)];
        dict[@"subjectId"] = _subjectID ? _subjectID : @"";
        dict[@"word"] = _keyword ? _keyword : @"";
    }
    [apiHandler getWithAPIName:strAPIName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strAPIName,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData removeAllObjects];
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                ArticleObject *obj = [[ArticleObject alloc]initWithListDictionary:dictItem];
                [_arrData addObject:obj];
            }
            _pageStart = [dictResponse[@"start"] intValue];
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
    if (_ifAnnounce) {
        strAPIName = API_ANNOUNCE_ARTICLE_LIST;
        dict[@"start"] = @(_pageStart);
        dict[@"word"] = _keyword ? _keyword : @"";
    } else {
        strAPIName = API_SUBJECT_ARTICLE_LIST;
        dict[@"start"] = @(_pageStart);
        dict[@"isIndex"] = SubjectDataFilterDict[@(_dataFilter)];
        dict[@"subjectId"] = _subjectID ? _subjectID : @"";
        dict[@"word"] = _keyword ? _keyword : @"";
    }
    [apiHandler getWithAPIName:strAPIName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strAPIName,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                ArticleObject *obj = [[ArticleObject alloc]initWithListDictionary:dictItem];
                [_arrData addObject:obj];
            }
            _pageStart = [dictResponse[@"start"] intValue];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"subjectID":_subjectID ? _subjectID : @"",
                               @"subjectTitle":@"搜索结果",
                               @"ifHasAdvertisement":@NO,
                               @"ifHideSearchButton":@YES,
                               @"ifAnnounce":@(_ifAnnounce)
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeArticle];
    }
}
@end
