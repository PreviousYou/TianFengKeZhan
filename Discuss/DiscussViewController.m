//
//  DiscussViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "DiscussViewController.h"
#import "DiscussListCell.h"
#import "WebpageAdvancedViewController.h"
#import "DiscussObject.h"
#import "APIHandler.h"
#import "UIStoryboard+SAGetter.h"
#import "MPAlertView.h"
#import "NewDiscussViewController.h"
#import "LoginedUserHandler.h"
#import "SearchViewController.h"
#import <MJRefresh.h>

@interface DiscussViewController ()
@property (strong, nonatomic) NSMutableArray *arrData;
@property (assign, nonatomic) int pageStart;
@property (weak, nonatomic) IBOutlet UIButton *btnNavRight;
@property (weak, nonatomic) IBOutlet UIButton *btnNavLeft;

@end

@implementation DiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [[NSMutableArray alloc]init];
    [self initViews];
    _ifNeedRefresh = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_ifNeedRefresh) {
        [self.tableView.header beginRefreshing];
        _ifNeedRefresh = NO;
    }
}

- (void)initViews {
    [_btnNavRight setHidden:_ifHideSearchButton];
    if (_ifHideNewButton) {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscussListCell" bundle:nil] forCellReuseIdentifier:@"DiscussListCell"];
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscussListCell"];
    
    [cell loadDataWithObject:_arrData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussObject *obj = _arrData[indexPath.row];
    CGRect rect = [obj.brief boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    if (obj.imagePath && obj.imagePath.length > 0) {
        // 有图片
        return rect.size.height + 126 + 60;  // 126 is the height besides the brief content, 60 is the image's height.
    } else {
        // 无图片
        return rect.size.height + 126;  // 126 is the height besides the brief content.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussObject *obj = _arrData[indexPath.row];
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeDiscussID];
    [viewController setWebpageID:obj.objectID];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - TableView Refresh/Load
- (void)refreshTableView {
    _pageStart = 0;
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"start"] = @(_pageStart);
    dict[@"summary"] = _keyword ? _keyword : @"";
    [apiHandler getWithAPIName:API_DISCUSS_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_DISCUSS_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData removeAllObjects];
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                DiscussObject *obj = [[DiscussObject alloc]initWithListDictionary:dictItem];
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
    dict[@"start"] = @(_pageStart);
    dict[@"summary"] = _keyword ? _keyword : @"";
    [apiHandler getWithAPIName:API_DISCUSS_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_DISCUSS_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrList = dictResponse[@"extra"];
            for (NSDictionary *dictItem in arrList) {
                DiscussObject *obj = [[DiscussObject alloc]initWithListDictionary:dictItem];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"NewDiscussSegue"]) {
        if (![LoginedUserHandler loginedUser].logined) {
            UIViewController *viewController = [[UIStoryboard userLoginStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewDiscussSegue"]) {
        NewDiscussViewController *viewController = segue.destinationViewController;
        [viewController setInvokeViewController:self];
    } else if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"title":@"搜索结果",
                               @"ifHideNewButton":@YES,
                               @"ifHideSearchButton":@YES
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeDiscuss];
    }
}
@end
