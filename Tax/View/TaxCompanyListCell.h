//
//  TaxCompanyListCell.h
//  TianFengKeZhan
//
//  Created by StoneArk on 15/8/19.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CompanyObject.h"

@protocol TaxCompanyListCellDelegate <NSObject>
- (void)selectCompany:(CompanyObject*)companyObj;
@end

@interface TaxCompanyListCell : BaseTableViewCell
@property (strong, nonatomic) id<TaxCompanyListCellDelegate> delegate;
- (void)loadDataWithObject:(CompanyObject*)obj;
@end
