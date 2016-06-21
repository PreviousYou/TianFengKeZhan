//
//  ReportViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/8.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@property (copy, nonatomic) NSMutableArray *contentArr;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"举报";

    _contentArr = [NSMutableArray array];
    
    [self creatUI];
}

- (void)creatUI {
    
    [_submitBtn.layer setCornerRadius:3];
    
    [_submitBtn.layer setMasksToBounds:YES];
    
    NSString *contentStr = [NSString stringWithFormat:@"举报@%@的帖子",_nativeObject.authorNickName];
    
    int length = (int)_nativeObject.authorNickName.length;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:89.0f/255.0f green:169.0f/255.0f blue:54.0f/255.0f alpha:1] range:NSMakeRange(2, length +1 )];
    
    [_titleLabel setAttributedText:att];

}


- (IBAction)btnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    int imageViewTag = (int)sender.tag-UIButtonBasicTagNumber + UIImageViewBasicTagNumber;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:imageViewTag];
    
    if (sender.selected) {
        
        UIImage *image= [UIImage imageNamed:@"checkbox_yes"];
        
        imageView.image = image;
        
        NSString *btnTitle = [sender currentTitle];
        
        [_contentArr addObject:btnTitle];
        
    }else {
    
        UIImage *image= [UIImage imageNamed:@"checkbox_no"];
        
        imageView.image = image;
        
        NSString *btnTitle = [sender currentTitle];
        
        [_contentArr removeObject:btnTitle];
        
    }
}

- (IBAction)submitBtnAction:(UIButton *)sender {
  
    NSString *contentStr = nil;
    
    if (_contentArr.count ) {
        
        contentStr = [_contentArr componentsJoinedByString:@","];
    }
    
     [self submitReportWithContent:contentStr];
}

- (void)submitReportWithContent:(NSString*)content {
    // 调用举报的js方法
    NSString *jsMethod = [_nativeObject.reportMethod stringByAppendingFormat:@"({\"memberId\":\"%@\",\"reportContent\":\"%@\",\"token\":\"%@\"});",[LoginedUserHandler loginedUser].userObj.objectID, content, [LoginedUserHandler loginedUser].userObj.token];
    
    [_webView stringByEvaluatingJavaScriptFromString:jsMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
