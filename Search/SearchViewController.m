//
//  SearchViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/8.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "SearchViewController.h"
#import "KeywordListView.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "AnnounceViewController.h"
#import "DiscussViewController.h"
#import "YGZQuestionListViewController.h"
#import "HCEndQuestionListViewController.h"
#import "HCEndVideoListViewController.h"
#import "UIStoryboard+SAGetter.h"
#import <MBProgressHUD.h>

@interface SearchViewController ()<UITextFieldDelegate,KeywordListViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldKeyword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet UILabel *lblCloudTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLineHeight;
@property (strong, nonatomic) KeywordListView *keywordListView;
@property (strong, nonatomic) NSArray *arrData;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_seperatorLineHeight setConstant:0.5];
    
    switch (_searchType) {
        case SearchTypeQuestion:
        case SearchTypeVideo:
            [_lblCloudTitle setText:@"关键词"];
            break;
        case SearchTypeArticle:
        case SearchTypeDiscuss:
            [_lblCloudTitle setText:@"近期热点"];
            break;
        default:
            break;
    }
    
    _keywordListView = [[KeywordListView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 32, 0) dataArray:@[] backgroundColor:[UIColor whiteColor]];
    [_keywordListView setDelegate:self];
    [_scrView addSubview:_keywordListView];
}

- (void)loadData {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSInteger keywordType;
    if (_searchType == SearchTypeHomeQuestion || _searchType == SearchTypeHelpCenterQuestion) {
        keywordType = SearchTypeQuestion;
    } else if (_searchType == SearchTypeHelpCenterVideo) {
        keywordType = SearchTypeVideo;
    } else {
        keywordType = _searchType;
    }
    [apiHandler getWithAPIName:API_KEYWORD_LIST parameters:@{@"type":@(keywordType)} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_KEYWORD_LIST,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            _arrData = dictResponse[@"extra"];
            [_keywordListView reloadWithFrame:_keywordListView.frame dataArray:_arrData backgroundColor:[UIColor whiteColor]];
            [_scrView setContentSize:CGSizeMake(_scrView.frame.size.width, _keywordListView.frame.size.height)];
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
        }
    } failed:^(NSString *errorMessage) {
        [hud hide:YES];
        [MPAlertView showAlertView:errorMessage];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_textFieldKeyword.text.length > 0) {
        [self submitSearch:_textFieldKeyword.text];
    }
    [self.view endEditing:YES];
    return YES;
}

- (void)keywordSelected:(NSString *)keyword {
    [self submitSearch:keyword];
}

- (void)submitSearch:(NSString*)keyword {
    switch (_searchType) {
        case SearchTypeArticle: {
            AnnounceViewController *viewController = [[UIStoryboard announceStoryboard] instantiateViewControllerWithIdentifier:@"AnnounceViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case SearchTypeDiscuss: {
            DiscussViewController *viewController = [[UIStoryboard discussStoryboard] instantiateViewControllerWithIdentifier:@"DiscussViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case SearchTypeQuestion: {
            YGZQuestionListViewController *viewController = [[UIStoryboard subjectYGZStoryboard] instantiateViewControllerWithIdentifier:@"YGZQuestionListViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case SearchTypeHelpCenterQuestion: {
            HCEndQuestionListViewController *viewController = [[UIStoryboard helpCenterStoryboard] instantiateViewControllerWithIdentifier:@"HCEndQuestionListViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case SearchTypeHelpCenterVideo: {
            HCEndVideoListViewController *viewController = [[UIStoryboard helpCenterStoryboard] instantiateViewControllerWithIdentifier:@"HCEndVideoListViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case SearchTypeHomeQuestion: {
            YGZQuestionListViewController *viewController = [[UIStoryboard subjectYGZStoryboard] instantiateViewControllerWithIdentifier:@"YGZQuestionListViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case SearchTypeVideo: {
            HCEndVideoListViewController *viewController = [[UIStoryboard helpCenterStoryboard] instantiateViewControllerWithIdentifier:@"HCEndVideoListViewController"];
            [viewController setValuesForKeysWithDictionary:_dictExtraParameter];
            [viewController setKeyword:keyword];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
