//
//  TaxViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/17.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "TaxViewController.h"
#import "TaxCompanyListCell.h"
#import "LoginedUserHandler.h"
#import "NSString+AES256.h"
#import "LoginedUserHandler.h"
//#import "RequestTools.h"
//#import <CocoaSecurity.h>

// 后期依客户要求不再有密码字段，仅将税号传递到移动办税app内，并不自动授权登录
@interface TaxViewController ()<TaxCompanyListCellDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnFooter;
@property (strong, nonatomic) NSMutableArray *arrData;
//@property (nonatomic, strong) RequestTools *tools;
//@property (strong, nonatomic) NSString *uuid;
//@property (strong, nonatomic) CompanyObject *selectedComapny;
@end

@implementation TaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedDynamicCode:) name:@"bsdt_search" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bsdt_search" object:nil];
}

- (void)initViews {
    [_btnFooter.layer setCornerRadius:6];
    [_btnFooter.layer setMasksToBounds:YES];
}

- (void)loadData {
    _arrData = [LoginedUserHandler loginedUser].userObj.arrCompany;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnFooterClick:(UIButton *)sender {
    NSString *strURL = [(@"banshui://") stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self jumpWithURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaxCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxCompanyListCell"];
    [cell loadDataWithObject:_arrData[indexPath.row]];
    [cell setDelegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)selectCompany:(CompanyObject *)companyObj {
    /*
    _uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    _uuid = [_uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    _tools = [[RequestTools alloc] init];
    [_tools requestWithMethod:@[@"getDTKL", _uuid]];
    _selectedComapny = companyObj;
     */
    NSString *taxNumber = [companyObj.taxID aes256_encrypt:@"12345678"];
    NSString *strURL = [[NSString stringWithFormat:@"banshui://userName:%@",taxNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    [self jumpWithURL:url];
}

/*
- (void)receivedDynamicCode:(NSNotification *)notification {
    if (self.tools.currentMethod.length) {
        NSString *taxNumber = [_selectedComapny.taxID aes256_encrypt:@"12345678"];
        NSString *password = [[CocoaSecurity md5:_selectedComapny.password] hexLower];
        NSString *strURL = [[NSString stringWithFormat:@"banshui://userName:%@,passWord:%@,UUID:%@,Token:%@",taxNumber, password, _uuid, _tools.currentMethod] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strURL];
        [self jumpWithURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取动态口令失败，请稍后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}
*/

- (void)jumpWithURL:(NSURL*)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未安装移动办税服务平台，是否安装？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"App Store", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        // 跳转到办税平台App Store下载页
        NSURL *urlAppStore = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yi-dong-ban-shui-fu-wu-ping-tai/id824071332?mt=8"];
        [[UIApplication sharedApplication] openURL:urlAppStore];
    }
}
@end
