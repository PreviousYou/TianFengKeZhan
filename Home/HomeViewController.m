//
//  HomeViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HomeViewController.h"
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
#import "SubjectYGZViewController.h"
#import "SearchViewController.h"
#import "YGZQuestionListViewController.h"
#import "SAImageUtility.h"
#import "UIImage+DeviceSpecificMedia.h"
#import <MJRefresh.h>
#import <UIButton+WebCache.h>
#import <EAIntroView.h>

#define HomeMetroDataFilePath [NSString stringWithFormat:@"%@/HomeMetroData.plist", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define GUIDE_VIEW_TAG 9000

@interface HomeViewController ()<HPAdViewDelegate,EAIntroDelegate>


@property (weak, nonatomic) IBOutlet UIButton *btnNavLeft;
@property (strong, nonatomic) NSMutableArray *arrMetro;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) HPAdView *hpAdView;
@property (strong, nonatomic) UITableViewCell *adCell;
@property (strong, nonatomic) UITableViewCell *metroCell;
@property (strong, nonatomic) NSMutableArray *arrAdObject; //广告数据
@property (assign, nonatomic) int pageStart;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [[NSMutableArray alloc]init];
    [self initViews];
    [self.tableView.header beginRefreshing];
    _arrMetro = [[NSMutableArray alloc]init];
    
    // 若未显示过教学页，监听由引导页播放结束后发送的通知，来显示教学页
    NSString *strDisplayed = [[NSUserDefaults standardUserDefaults]valueForKey:@"guideDisplayed"];
    if (!(strDisplayed && [strDisplayed boolValue])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectToShowIntroView) name:@"ShowGuideNotification" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    
    if ([LoginedUserHandler loginedUser].logined) {
        [[LoginedUserHandler loginedUser] refreshUserInfoWithSuccess:^(NSDictionary *dictResponse) {
            [self refreshUserHead];
        } failed:^(NSString *strError) {
            [self refreshUserHead];
        }];
    } else {
        [_btnNavLeft setImage:[UIImage imageNamed:@"nav_btnUserCenter"] forState:UIControlStateNormal];
    }
}


- (void)refreshUserHead {
    [_btnNavLeft sd_setImageWithURL:[NSURL URLWithString:[LoginedUserHandler loginedUser].userObj.imagePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_50x50_round"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_btnNavLeft setImage:[SAImageUtility ellipseImage:image] forState:UIControlStateNormal];
            if ([LoginedUserHandler loginedUser].userObj.unreadMessageCount > 0) {
                UIImage *imgScaled = [SAImageUtility scaleImage:_btnNavLeft.imageView.image toSize:CGSizeMake(44, 44)];
                [_btnNavLeft setImage:[SAImageUtility addPointToImage:imgScaled pointColor:[UIColor redColor] pointRadius:6] forState:UIControlStateNormal];
            }
        });
    }];
}

- (void)initViews {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleListCell" bundle:nil] forCellReuseIdentifier:@"ArticleListCell"];
    _adCell = [self.tableView dequeueReusableCellWithIdentifier:@"HomeAdCell"];
    _hpAdView = [[HPAdView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 5 / 16) adObjectArray:@[]];
    [_hpAdView setDelegate:self];
    [_hpAdView setPlaceholderImage:[UIImage imageNamed:@"placeholder_320x100"]];
    [_adCell addSubview:_hpAdView];
    
    _metroCell = [self.tableView dequeueReusableCellWithIdentifier:@"HomeMetroCell"];
    
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
                return [UIScreen mainScreen].bounds.size.width * 5 / 16 + 6 / [UIScreen mainScreen].scale;    //广告区域，320x100，额外的6为UI要求增加6px空隙
            }
        } else if (indexPath.row == 1) {
            if (_arrMetro.count == 0) {
                return 0;
            } else {
                return [UIScreen mainScreen].bounds.size.width * 13 / 64 + 4;   //Metro区域，640x130
            }
        }
    } else {
        return 85 * [UIScreen mainScreen].bounds.size.width / 320;  //列表区域
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
    NSString *strUrl = adObj.adID;
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeURL];
    [viewController setWebpageURL:[NSURL URLWithString:strUrl]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSArray*)getMetroData {
    [CommonFunction copyFileIfNeed:[[NSBundle mainBundle] pathForResource:@"HomeMetroData" ofType:@"plist"] copyFilePath:HomeMetroDataFilePath];
    NSArray *arrData = [[NSArray alloc] initWithContentsOfFile:HomeMetroDataFilePath];
    return arrData;
}

- (void)saveMetroData:(NSArray *)arrData {
    if (arrData && [arrData count]>0) {
        [arrData writeToFile:HomeMetroDataFilePath atomically:YES];
    }
}

- (void)btnMetroClick:(UIButton*)sender {
    NSDictionary *dictItem = _arrMetro[sender.tag];
    int type = [dictItem[@"type"] intValue];
    if (type == 0) {
        NSString *strCode = dictItem[@"code"];
        if ([strCode isEqualToString:@"bzzx"]) {
            UIViewController *viewController = [[UIStoryboard helpCenterStoryboard] instantiateViewControllerWithIdentifier:@"HelpCenterViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([strCode isEqualToString:@"ygzzl"]) {
            SubjectYGZViewController *viewController = [[UIStoryboard subjectYGZStoryboard] instantiateViewControllerWithIdentifier:@"SubjectYGZViewController"];
            [viewController setSubjectID:dictItem[@"subjectId"]];
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

- (void)loadMetro {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_MENU_LIST parameters:@{@"position":@"1"} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_MENU_LIST,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            NSArray *arrData = dictResponse[@"extra"];
            if (arrData && arrData.count > 0) {
                [self saveMetroData:arrData];
                _arrMetro = [arrData mutableCopy];
                [self refreshMetroDisplay];
            } else {
                [_arrMetro removeAllObjects];
                for (UIView *view in _metroCell.subviews) {
                    [view removeFromSuperview];
                }
            }
        } else {
            _arrMetro = [[self getMetroData] mutableCopy];
            [self refreshMetroDisplay];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMessage) {
        SALog(errorMessage);
        _arrMetro = [[self getMetroData] mutableCopy];
        [self refreshMetroDisplay];
        [self.tableView reloadData];
    }];
}

- (void)refreshMetroDisplay {
    NSMutableArray *arrPendingRemove = [[NSMutableArray alloc]init];
    for (NSDictionary *dictItem in _arrMetro) {
        int type = [dictItem[@"type"] intValue];
        if (type == 0) {
            NSString *strCode = dictItem[@"code"];
            if (!([strCode isEqualToString:@"bzzx"] || [strCode isEqualToString:@"ygzzl"])) {
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
    
    for (UIView *view in _metroCell.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat perWidth = [UIScreen mainScreen].bounds.size.width / _arrMetro.count;
    CGFloat height = [UIScreen mainScreen].bounds.size.width * 13 / 64 + 4;   //640x130
    for (int i=0;i<_arrMetro.count;i++) {
        NSDictionary *dictItem = _arrMetro[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i*perWidth, 0, perWidth, height)];
        NSString *imagePath = dictItem[@"imgUrl"];
        if ([imagePath hasPrefix:@"bundle://"]) {
            [button setBackgroundImage:[UIImage imageNamed:[imagePath substringFromIndex:9]] forState:UIControlStateNormal];
        } else {
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal];
        }
        [button.imageView setContentMode:UIViewContentModeScaleToFill];
        [button setContentMode:UIViewContentModeScaleToFill];
        [button setTag:i];
        [button addTarget:self action:@selector(btnMetroClick:) forControlEvents:UIControlEventTouchUpInside];
        [_metroCell addSubview:button];
    }
}

- (void)loadAdvertisement {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_ADVERTISE_LIST parameters:nil success:^(NSDictionary *dictResponse) {
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
    [self loadMetro];
    _pageStart = 0;
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"start"] = @(_pageStart);
    dict[@"isIndex"] = @"1";
    dict[@"subjectId"] = @"";
    [apiHandler getWithAPIName:API_ARTICLE_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_ARTICLE_LIST,dictResponse);
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
    dict[@"subjectId"] = @"";    
    [apiHandler getWithAPIName:API_ARTICLE_LIST parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_ARTICLE_LIST,dictResponse);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"title":@"搜索结果",
                               @"ifHideSearchButton":@YES,
                               @"questionType":@(SubjectQuestionTypeHomepage)
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeHomeQuestion];
    }
}

#pragma mark - 教学页
- (void)detectToShowIntroView {
    NSString *strDisplayed = [[NSUserDefaults standardUserDefaults]valueForKey:@"guideDisplayed"];
    if (!(strDisplayed && [strDisplayed boolValue])) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageForDeviceWithName:@"guide1"]];
        [imgView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [imgView setUserInteractionEnabled:YES];
        [imgView setTag:GUIDE_VIEW_TAG];
        [[UIApplication sharedApplication].delegate.window addSubview:imgView];
        
        
        UIButton *btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSkip setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2)];
        [btnSkip setTag:1];
        [btnSkip addTarget:self action:@selector(btnSkipClick:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].delegate.window addSubview:btnSkip];
        
    }
}

- (void)btnSkipClick:(UIButton*)sender {
    
    sender.tag++;
    if (sender.tag <= 4) {
        UIImageView *imgView = (UIImageView*)[[UIApplication sharedApplication].delegate.window viewWithTag:GUIDE_VIEW_TAG];
        [imgView setImage:[UIImage imageForDeviceWithName:[NSString stringWithFormat:@"guide%ld",sender.tag]]];
    } else {
        UIImageView *imgView = (UIImageView*)[[UIApplication sharedApplication].delegate.window viewWithTag:GUIDE_VIEW_TAG];
        [imgView removeFromSuperview];
        [sender removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"guideDisplayed"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowGuideNotification" object:nil];
    }
}

@end 
