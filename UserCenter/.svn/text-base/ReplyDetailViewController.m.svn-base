//
//  ReplyDetailViewController.m
//  TianFengKeZhan
//
//  Created by StoneArk on 15/9/19.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "ReplyDetailViewController.h"
#import "APIHandler.h"
#import "MPAlertView.h"
#import "LoginedUserHandler.h"
#import "CommonFunction.h"
#import "WebpageAdvancedViewController.h"
#import "UIStoryboard+SAGetter.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>

@interface ReplyDetailListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeight;
@end

@implementation ReplyDetailListCell
- (void)awakeFromNib {
    [_cellSeparatorHeight setConstant: 1.0 / [UIScreen mainScreen].scale];
}
@end

@interface ReplyDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBrief;
@property (weak, nonatomic) IBOutlet UILabel *lblGrade;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerSeparatorHeight;

@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) NSString *pageStart;
@property (strong, nonatomic) NSString *contentID;
@end

@implementation ReplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [[NSMutableArray alloc]init];
    [self initViews];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViews {
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    [_headerSeparatorHeight setConstant: 1.0 / [UIScreen mainScreen].scale];
    [_lblGrade.layer setCornerRadius:4];
    [_lblGrade.layer setMasksToBounds:YES];
    // TableView 上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (void)loadData {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    [apiHandler getWithAPIName:API_REPLY_INFO parameters:@{@"replyId":_replyID} success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_REPLY_INFO,dictResponse);
        if ([dictResponse[@"retcode"]intValue] == 1) {
            NSDictionary *dict = dictResponse[@"extra"];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"headerImg"]] placeholderImage:[UIImage imageNamed:@""]];
            [_lblName setText:dict[@"nick"]];
            [_lblGrade setText:dict[@"grade"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [_lblTime setText:[NSString stringWithFormat:@"%@楼   %@",dict[@"floor"] ,[CommonFunction compareCurrentTime:[formatter dateFromString:dict[@"createDate"]]]]];
            [_lblBrief setText:dict[@"content"]];
            _contentID = [dict[@"contentId"] copy];
            [self.navigationItem setTitle:[NSString stringWithFormat:@"%@楼",dict[@"floor"]]];
            CGRect rect = _viewHeader.frame;
            rect.size.height = [dict[@"content"] boundingRectWithSize:CGSizeMake(_lblBrief.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 80;
            [_viewHeader setFrame:rect];
            [self.tableView reloadData];
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
    }];
}

#pragma mark - TableView Refresh/Load
- (void)refreshTableView {
    [self loadData];
    _pageStart = @"0";
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"replyId"] = _replyID;
    dict[@"start"] = _pageStart;
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    [apiHandler getWithAPIName:API_REPLY_DETAIL parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_REPLY_DETAIL,dictResponse);
        if ([dictResponse[@"retcode"]intValue] == 1) {
            [_arrData removeAllObjects];
            [_arrData addObjectsFromArray: dictResponse[@"extra"]];
            _pageStart = dictResponse[@"start"];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer resetNoMoreData];
            // 无数据背景图
            /*
            if (_arrData.count == 0) {
                [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]]];
                [self.tableView.backgroundView setContentMode:UIViewContentModeCenter];
            } else {
                [self.tableView setBackgroundView:nil];
            }
             */
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
            [self.tableView.header endRefreshing];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
        [self.tableView.header endRefreshing];
        [_arrData removeAllObjects];
        [self.tableView reloadData];
        // 网络请求失败背景图
        [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"networkfail"]]];
        [self.tableView.backgroundView setContentMode:UIViewContentModeCenter];
    }];
}

- (void)loadNextPage {
    APIHandler *apiHandler = [[APIHandler alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"replyId"] = _replyID;
    dict[@"start"] = _pageStart;
    dict[@"memberId"] = [LoginedUserHandler loginedUser].userObj.objectID;
    [apiHandler getWithAPIName:API_REPLY_DETAIL parameters:dict success:^(NSDictionary *dictResponse) {
        SALog(@"%@: %@",API_REPLY_DETAIL,dictResponse);
        if ([dictResponse[@"retcode"] intValue] == 1) {
            [_arrData addObjectsFromArray: dictResponse[@"extra"]];
            _pageStart = dictResponse[@"start"];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            if (((NSArray*)dictResponse[@"extra"]).count == 0) {
                [self.tableView.footer noticeNoMoreData];
            }
        } else {
            [MPAlertView showAlertView:dictResponse[@"retmsg"]];
            [self.tableView.footer endRefreshing];
        }
    } failed:^(NSString *errorMessage) {
        [MPAlertView showAlertView:errorMessage];
        [self.tableView.footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _arrData[indexPath.row];
    NSString *brief = [NSString stringWithFormat:@"%@：%@ %@",dict[@"nick"], dict[@"content"], dict[@"createDate"]];
    CGRect rect = [brief boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10 - 56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height + 10;  // 20 is the height besides the brief content.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReplyDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyDetailListCell"];
    NSDictionary *dict = _arrData[indexPath.row];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]init];
    [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:dict[@"nick"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.984 green:0.302 blue:0.000 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"：%@ ",dict[@"content"]] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.145 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dict[@"createDate"]];
    [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:[CommonFunction compareCurrentTime:date] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.569 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
    
    [cell.lblTitle setAttributedText:attributedStr];
    return cell;
}

- (IBAction)btnNavRightClick:(UIBarButtonItem *)sender {
    WebpageAdvancedViewController *viewController = [[UIStoryboard webStoryboard] instantiateViewControllerWithIdentifier:@"WebpageAdvancedViewController"];
    [viewController setSourceType:WebpageSourceTypeDiscussID];
    [viewController setWebpageID:_contentID];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
