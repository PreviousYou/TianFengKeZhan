//
//  BindDetailViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/25.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BindDetailViewController.h"
#import "MPAlertView.h"
#import "BindCompanyViewController.h"

/// 后期依据客户要求，绑定纳税人不再有密码字段，此处将密码相关视图隐藏
@interface BindDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTaxID;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@end

@implementation BindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    if (_companyObj) {
        [_textFieldName setText:_companyObj.name];
//        [_textFieldPassword setText:_companyObj.password];
        [_textFieldTaxID setText:_companyObj.taxID];
    } else {
        [MPAlertView showAlertView:@"未传入数据"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnNavRightClick:(UIBarButtonItem *)sender {
    BindCompanyViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BindCompanyViewController"];
    [viewController setCompanyObj:_companyObj];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
