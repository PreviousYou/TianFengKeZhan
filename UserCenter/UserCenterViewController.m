//
//  UserCenterViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/21.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "UserCenterViewController.h"
#import "LoginViewController.h"
#import "LoginedUserHandler.h"
#import "UIStoryboard+SAGetter.h"
#import "BindDetailViewController.h"
#import "LGAlertView.h"
#import "CommonFunction.h"
#import <UIImageView+WebCache.h>

@interface UserCenterViewController ()
@property (strong, nonatomic) NSArray *arrCellHeight;
@property (weak, nonatomic) IBOutlet UIView *viewCompanyList;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblNickname;
@property (weak, nonatomic) IBOutlet UILabel *lblGrade;
@property (weak, nonatomic) IBOutlet UILabel *lblCellphone;
@property (weak, nonatomic) IBOutlet UIImageView *badgeMessage;
@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshDisplay];
    _arrCellHeight = @[ @[@7], @[@80],
                        [[NSMutableArray alloc]initWithArray:@[@7]], [[NSMutableArray alloc]initWithArray:@[@43, @43]],
                        @[@7], @[@47, @47, @47, @47, @47],
                        @[@7], @[@42]
                        ];

    // 由于UI不能接受iOS7风格的TableView分割线，进行特殊处理
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [_lblGrade.layer setCornerRadius:4];
    [_lblGrade.layer setMasksToBounds:YES];
    [_badgeMessage.layer setCornerRadius:_badgeMessage.frame.size.width / 2];
    [_badgeMessage.layer setMasksToBounds:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[LoginedUserHandler loginedUser] refreshUserInfoWithSuccess:^(NSDictionary *dictResponse) {
        [self refreshDisplay];
    } failed:^(NSString *strError) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == tableView.numberOfSections - 1) {
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:nil message:@"\n您确定要退出此帐号吗？\n" buttonTitles:@[@"确认"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [CommonFunction setStyleOfLGAlertView:alertView];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            if (index == 0) {
                // 确定退出帐号，登出并切换回首页
                [[LoginedUserHandler loginedUser] logout];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

- (void)refreshDisplay {
    UserObject *userObj = [LoginedUserHandler loginedUser].userObj;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:userObj.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder_50x50"]];
    [_badgeMessage setHidden:(userObj.unreadMessageCount == 0)];
    
    [_lblNickname setText:userObj.nickName];
    [_lblGrade setText:userObj.grade];
    [_lblCellphone setText:userObj.name];
    
    for (UIView *view in _viewCompanyList.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat perHeight = 43;
    NSArray *arrCompany = userObj.arrCompany;
    if (arrCompany.count == 0) {
        _arrCellHeight[2][0] = @0;
        _arrCellHeight[3][0] = @0;
    }
    _arrCellHeight[3][1] = @(perHeight * arrCompany.count);

    for (int i=0;i<arrCompany.count;i++) {
        CompanyObject *obj = arrCompany[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj.name forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [btn setFrame:CGRectMake(0, i * perHeight, [UIScreen mainScreen].bounds.size.width, perHeight)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btnCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCompanyList addSubview:btn];
        
        UIImageView *imgViewSeperator = [[UIImageView alloc]initWithFrame:CGRectMake(8, (i+1)*perHeight, [UIScreen mainScreen].bounds.size.width - 8, 0.5)];
        [imgViewSeperator setBackgroundColor:[UIColor colorWithWhite:0.780 alpha:1.000]];
        [_viewCompanyList addSubview:imgViewSeperator];
        
        UIImageView *imgViewIndicator = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 24 - 8, i * perHeight + (perHeight - 24)/2, 24,24)];
        [imgViewIndicator setImage:[UIImage imageNamed:@"arrowRight"]];
        [_viewCompanyList addSubview:imgViewIndicator];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_arrCellHeight[indexPath.section][indexPath.row] doubleValue];
}

- (void)btnCompanyClick:(UIButton*)sender {
    BindDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BindDetailViewController"];
    CompanyObject *obj = [LoginedUserHandler loginedUser].userObj.arrCompany[sender.tag];
    [viewController setCompanyObj:obj];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
