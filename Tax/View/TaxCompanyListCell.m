//
//  TaxCompanyListCell.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/19.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "TaxCompanyListCell.h"


@interface TaxCompanyListCell()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) CompanyObject *companyObj;

@end

@implementation TaxCompanyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_button.layer setCornerRadius:6];
    [_button.layer setMasksToBounds:YES];
}

- (void)loadDataWithObject:(CompanyObject *)obj {
    _companyObj = obj;
    [_button setTitle:obj.name forState:UIControlStateNormal];
}

- (IBAction)btnClick:(UIButton *)sender {
    [_delegate selectCompany:_companyObj];
}




@end
