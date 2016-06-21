//
//  BindCompanyViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/25.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BindCompanyViewController.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "LoginedUserHandler.h"
#import <MBProgressHUD.h>

/// 后期依据客户要求，绑定纳税人不再有密码字段，此处将密码相关视图隐藏
@interface BindCompanyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTaxID;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation BindCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [_btnSubmit.layer setCornerRadius:6];
    [_btnSubmit.layer setMasksToBounds:YES];
}

- (void)loadData {
    if (_companyObj) {
        [_textFieldName setText:_companyObj.name];
//        [_textFieldPassword setText:_companyObj.password];
        [_textFieldTaxID setText:_companyObj.taxID];
        [self setTitle:@"编辑绑定纳税号"];
        [_btnSubmit setTitle:@"确认修改" forState:UIControlStateNormal];
    } else {
        [self setTitle:@"添加绑定纳税人"];
        [_btnSubmit setTitle:@"确认绑定" forState:UIControlStateNormal];
    }
}

- (IBAction)btnSubmitClick:(UIButton *)sender {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud show:YES];
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSString *strApiName;
    if (_companyObj) {
        strApiName = API_COMPANY_EDIT;
        dict[@"company"] = _textFieldName.text;
        dict[@"taxNo"] = _textFieldTaxID.text;
//        dict[@"password"] = _textFieldPassword.text;
        dict[@"id"] = _companyObj.objectID;
    } else {
        strApiName = API_COMPANY_BIND;
        dict[@"company"] = _textFieldName.text;
        dict[@"taxNo"] = _textFieldTaxID.text;
//        dict[@"password"] = _textFieldPassword.text;
        dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    }
    
    [apiHandler getWithAPIName:strApiName parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",strApiName,dictResponse);
        [hud hide:YES];
        if ([dictResponse[@"retcode"] intValue] == 1) {
            CompanyObject *obj;
            if (_companyObj) {
                obj = _companyObj;
                [MPAlertView showAlertView:@"修改成功"];
            } else {
                obj = [[CompanyObject alloc]init];
                [[LoginedUserHandler loginedUser].userObj.arrCompany addObject:obj];
                [MPAlertView showAlertView:@"绑定成功"];
            }
            obj.name = _textFieldName.text;
            obj.taxID = _textFieldTaxID.text;
//            obj.password = _textFieldPassword.text;

            [self.navigationController popViewControllerAnimated:YES];
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
@end
