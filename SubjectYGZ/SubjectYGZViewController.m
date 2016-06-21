//
//  SubjectYGZViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/2.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "SubjectYGZViewController.h"
#import "HPAdView.h"
#import "ArticleListCell.h"
#import "CommonFunction.h"
#import "WebpageViewController.h"
#import "WebpageAdvancedViewController.h"
#import "UIStoryboard+SAGetter.h"
#import "APIHandler.h"
#import "AdObject.h"
#import "MPAlertView.h"
#import "ArticleObject.h"
#import "LoginedUserHandler.h"
#import "YGZQuestionListViewController.h"
#import "YGZSoftwareGuideViewController.h"
#import "AnnounceViewController.h"
#import <MJRefresh.h>
#import <UIButton+WebCache.h>

@interface SubjectYGZViewController ()<HPAdViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;
@property (strong, nonatomic) NSMutableArray *arrMetro;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) HPAdView *hpAdView;
@property (strong, nonatomic) UITableViewCell *adCell;
@property (strong, nonatomic) UITableViewCell *metroCell;
@property (strong, nonatomic) NSMutableArray *arrAdObject; //广告数据
@property (assign, nonatomic) int pageStart;
@end

@implementation SubjectYGZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [[NSMutableArray alloc]init];
    [self initViews];
    [self updateMetroDataFromServer];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_separatorHeight setConstant:0.5];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleListCell" bundle:nil] forCellReuseIdentifier:@"ArticleListCell"];
    _adCell = [self.tableView dequeueReusableCellWithIdentifier:@"YGZAdCell"];
    _hpAdView = [[HPAdView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 5 / 16) adObjectArray:@[]];
    [_hpAdView setDelegate:self];
    [_hpAdView setPlaceholderImage:[UIImage imageNamed:@"placeholder_320x100"]];
    [_adCell addSubview:_hpAdView];
    
    _metroCell = [self.tableView dequeueReusableCellWithIdentifier:@"YGZMetroCell"];
    UIImageView *separatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 92, [UIScreen mainScreen].bounds.size.width, 0.5)];
    [separatorLine setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
    [_metroCell addSubview:separatorLine];
    
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return _arrData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return _adCell;
        } else {
            return _metroCell;
        }
    } else {
        ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListCell"];
        [cell loadDataWithObject:_arrData[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (_arrAdObject.count == 0) {
                return 0;
            } else {
                return [UIScreen mainScreen].bounds.size.width * 5 / 16;    //320x100
            }
        } else if (indexPath.row == 1) {
            return 95;
        }
    } else {
        return 85;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ArticleObject *obj = _arrData[indexPath.row];
        WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
        [viewController setSourceType:WebpageSourceTypeID];
        [viewController setWebpageID:obj.objectID];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)hpAdView:(HPAdView *)adView clickedAtIndex:(NSUInteger)index {
    AdObject *adObj = _arrAdObject[index];
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeID];
    [viewController setWebpageID:adObj.adID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)updateMetroDataFromServer {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_MENU_LIST parameters:@{@"position":@"3",@"subjectId":_subjectID} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_MENU_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            _arrMetro = [dictResponse[@"extra"] mutableCopy];
            NSMutableArray *arrPendingRemove = [[NSMutableArray alloc]init];
            for (NSDictionary *dictItem in _arrMetro) {
                int type = [dictItem[@"type"] intValue];
                if (type == 0) {
                    NSString *strCode = dictItem[@"code"];
                    if (!([strCode isEqualToString:@"ygzdt"]  ||
                          [strCode isEqualToString:@"ygzcjwt"]   ||
                          [strCode isEqualToString:@"rjczjd"] ||
                          [strCode isEqualToString:@"czlc"]
                          )) {
                        [arrPendingRemove addObject:dictItem];
                    }
                } else if (type == 1) {
                    NSString *strUrl = dictItem[@"reqUrl"];
                    if (!(strUrl && strUrl.length > 0)) {
                        [arrPendingRemove addObject:dictItem];
                    }
                } else {
                    [arrPendingRemove addObject:dictItem];
                }
            }
            for (NSDictionary *dictItem in arrPendingRemove) {
                [_arrMetro removeObject:dictItem];
            }
            [arrPendingRemove removeAllObjects];
            
            CGFloat perWidth = [UIScreen mainScreen].bounds.size.width / _arrMetro.count;
            CGFloat perHeight = 55;
            CGFloat posY = 13;
            for (int i=0;i<_arrMetro.count;i++) {
                NSDictionary *dictItem = _arrMetro[i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(i*perWidth, posY, perWidth, perHeight)];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [button setContentMode:UIViewContentModeScaleAspectFit];
                [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
                NSString *imagePath = dictItem[@"imgUrl"];
                if ([imagePath hasPrefix:@"bundle://"]) {
                    [button setImage:[UIImage imageNamed:[imagePath substringFromIndex:9]] forState:UIControlStateNormal];
                } else {
                    [button sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal];
                }
                [button setTag:i];
                [button addTarget:self action:@selector(btnMetroClick:) forControlEvents:UIControlEventTouchUpInside];
                [_metroCell addSubview:button];
                
                CGRect rect = button.frame;
                rect.origin.y += rect.size.height;
                rect.size.height = 20;
                UILabel *label = [[UILabel alloc]initWithFrame:rect];
                [label setText:dictItem[@"title"]];
                [label setFont:[UIFont systemFontOfSize:10]];
                [label setTextColor:[UIColor colorWithWhite:0.188 alpha:1.000]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [_metroCell addSubview:label];
            }
        }
    } failed:^(NSString *errorMessage) {
        SALog(errorMessage);
    }];
}

- (void)btnMetroClick:(UIButton*)sender {
    NSDictionary *dictItem = _arrMetro[sender.tag];
    int type = [dictItem[@"type"] intValue];
    if (type == 0) {
        NSString *strCode = dictItem[@"code"];
        if ([strCode isEqualToString:@"ygzcjwt"]) {
            YGZQuestionListViewController *viewController = [[UIStoryboard subjectYGZStoryboard] instantiateViewControllerWithIdentifier:@"YGZQuestionListViewController"];
            [viewController setSubjectID:_subjectID];
            [viewController setTitle:dictItem[@"title"] ? dictItem[@"title"] : @"营改增常见问题"];
            [viewController setQuestionType:SubjectQuestionTypeFrequent];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([strCode isEqualToString:@"ygzdt"]) {
            AnnounceViewController *viewController = [[UIStoryboard announceStoryboard] instantiateViewControllerWithIdentifier:@"AnnounceViewController"];
            [viewController setSubjectID:_subjectID];
            [viewController setSubjectTitle:dictItem[@"title"] ? dictItem[@"title"] : @"营改增动态"];
            [viewController setIfHasAdvertisement:NO];
            [viewController setDataFilter:SubjectDataFilterAll];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([strCode isEqualToString:@"czlc"]) {
            YGZQuestionListViewController *viewController = [[UIStoryboard subjectYGZStoryboard] instantiateViewControllerWithIdentifier:@"YGZQuestionListViewController"];
            [viewController setSubjectID:_subjectID];
            [viewController setTitle:dictItem[@"title"] ? dictItem[@"title"] : @"操作流程"];
            [viewController setQuestionType:SubjectQuestionTypeOperate];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([strCode isEqualToString:@"rjczjd"]) {
            YGZSoftwareGuideViewController *viewController = [[UIStoryboard subjectYGZStoryboard] instantiateViewControllerWithIdentifier:@"YGZSoftwareGuideViewController"];
            [viewController setSubjectID:_subjectID];
            [viewController setTitle:dictItem[@"title"] ? dictItem[@"title"] : @"软件操作解答"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if (type == 1) {
        NSString *strUrl = dictItem[@"reqUrl"];
        WebpageViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageViewController"];
        [viewController setSourceType:WebpageSourceTypeURL];
        [viewController setWebpageURL:[NSURL URLWithString:strUrl]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)loadAdvertisement {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_ADVERTISE_LIST parameters:@{@"moduleId":_subjectID} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_ADVERTISE_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrAdList = dictResponse[@"extra"];
            if (arrAdList.count <= 0) {
                [_hpAdView reloadAdObjectArr:@[]];
            } else {
                _arrAdObject = [[NSMutableArray alloc]init];
                for (NSDictionary *dictItem in arrAdList) {
                    AdObject *obj = [[AdObject alloc]initWithDictionary:dictItem];
                    [_arrAdObject addObject:obj];
                }
                [_hpAdView reloadAdObjectArr:_arrAdObject];
            }
            [self.tableView reloadData];
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
    }];
}

#pragma mark - TableView Refresh/Load
- (void)refreshTableView {
    [self loadAdvertisement];
    _pageStart = 0;
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"start"] = @(_pageStart);
    dict[@"isIndex"] = @"1";
    dict[@"subjectId"] = _subjectID;
    [apiHandler getWithAPIName:API_SUBJECT_ARTICLE_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_SUBJECT_ARTICLE_LIST,dictResponse);
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
    dict[@"start"] = @(_pageStart);
    dict[@"isIndex"] = @"1";
    dict[@"subjectId"] = _subjectID;
    [apiHandler getWithAPIName:API_SUBJECT_ARTICLE_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_SUBJECT_ARTICLE_LIST,dictResponse);
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"UserCenterSegue"]) {
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
@end
