//
//  RetractInputView.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/7.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "RetractInputView.h"

@implementation RetractInputView

- (IBAction)btnRetractClick:(UIButton *)sender {
    if (_editingView) [_editingView endEditing:YES];
}
@end
