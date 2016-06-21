//
//  HelpCenterViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/29.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HPSegmentView.h"
#import "HelpCenterMenuView.h"
#import "APIHandler.h"
#import "SearchViewController.h"
#import <MBProgressHUD.h>
#import <HexColors.h>

#define DEFAULT_COLOR_ARRAY @[[UIColor colorWithRed:0.992 green:0.655 blue:0.157 alpha:1.000],[UIColor colorWithRed:0.255 green:0.361 blue:0.996 alpha:1.000],[UIColor colorWithRed:0.984 green:0.208 blue:0.035 alpha:1.000],[UIColor colorWithRed:0.275 green:0.580 blue:0.149 alpha:1.000]]

@interface HelpCenterViewController ()<HPSegmentViewDelegate>
@property (weak, nonatomic) IBOutlet HPSegmentView *hpSegmentView; //顶部SegmentView
@property (weak, nonatomic) IBOutlet UIScrollView *scrView; //主ScrollView
@property (strong, nonatomic) HelpCenterMenuView *menuView; //菜单View
@property (strong, nonatomic) NSMutableArray *arrData; //帮助中心首页数据
@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    _menuView = [[HelpCenterMenuView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) dataArray:@[]];
    [_menuView setInvokeViewController:self];
    [_scrView addSubview:_menuView];
    [_hpSegmentView setDelegate:self];
}

- (void)loadData {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    // 获取颜色列表
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_HELP_COLOR_LIST parameters:nil success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_HELP_COLOR_LIST,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            // 获取颜色成功，继续请求首页数据
            NSMutableArray *arrColor = [[NSMutableArray alloc]init];
            for (NSString *strItem in dictResponse[@"extra"]) {
                [arrColor addObject:[UIColor colorWithHexString:strItem]];
            }
            [_menuView setArrTitleColor:arrColor];
            [self loadDetailData];
        } else {
            // 获取颜色失败，采用默认颜色，并继续请求首页数据
            [_menuView setArrTitleColor:DEFAULT_COLOR_ARRAY];
            [self loadDetailData];
        }
    } failed:^(NSString *errorMessage) {
        // 获取颜色失败，采用默认颜色，并继续请求首页数据
        [_menuView setArrTitleColor:DEFAULT_COLOR_ARRAY];
        [self loadDetailData];
    }];
}

- (void)loadDetailData {
    // 获取首页数据
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"parentId"] = @0;
    [apiHandler getWithAPIName:API_HELP_HOME parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_HELP_HOME,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            _arrData = [dictResponse[@"extra"] mutableCopy];
            [_menuView reloadWithFrame:_menuView.frame dataArray:_arrData[0][@"children"]];
            [_scrView setContentSize:CGSizeMake(_scrView.frame.size.width, _menuView.frame.size.height)];
            NSMutableArray *segmentTitle = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in _arrData) {
                [segmentTitle addObject:dict[@"name"]];
            }
            [_hpSegmentView reloadWithFrame:_hpSegmentView.frame titleArray:segmentTitle];
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

- (void)hpSegmentView:(HPSegmentView *)segmentView didClickItemAtIndex:(NSUInteger)index {
    NSArray *array = _arrData[index][@"children"];
    if (array && array.count > 0) {
        [_menuView reloadWithFrame:_menuView.frame dataArray:_arrData[index][@"children"]];
        [_scrView setContentSize:CGSizeMake(_scrView.frame.size.width, _menuView.frame.size.height)];
    } else {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud show:YES];
        APIHandler *apiHandler = [[APIHandler alloc]init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict[@"parentId"] = _arrData[index][@"id"];
        [apiHandler getWithAPIName:API_HELP_HOME parameters:dict success:^(NSDictionary *dictResponse) {
            SALog(@"%@: %@",API_HELP_HOME,dictResponse);
            [hud hide:YES];
            if ([dictResponse[@"retcode"] intValue] == 1) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:_arrData[index]];
                NSArray *arrChildren = dictResponse[@"extra"];
                dict[@"children"] = arrChildren;
                _arrData[index] = dict;
                
                [_menuView reloadWithFrame:_menuView.frame dataArray:_arrData[index][@"children"]];
                [_scrView setContentSize:CGSizeMake(_scrView.frame.size.width, _menuView.frame.size.height)];
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = segue.destinationViewController;
        NSDictionary *dict = @{@"categoryTitle":@"搜索结果",
                               @"categoryID":@"",
                               @"ifHideSearchButton":@YES
                               };
        [viewController setDictExtraParameter:dict];
        [viewController setSearchType:SearchTypeHelpCenterQuestion];
    }
}
@end
