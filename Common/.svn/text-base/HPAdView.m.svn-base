//
//  HPAdView.m
//  DiDiBaoBiao
//
//  Created by StoneArk on 15/4/14.
//  Copyright (c) 2015年 StoneArk. All rights reserved.
//

#import "HPAdView.h"
#import "AdObject.h"
#import "UIImageView+WebCache.h"

@interface HPAdView ()
/// scrollView
@property (strong, nonatomic) UIScrollView *scrollView;
/// 存放 imageView 的数组
@property (strong, nonatomic) NSMutableArray *imgViewArray;
/// pageControl
@property (strong, nonatomic) UIPageControl *pageControl;
/// 当前页面的 index
@property (assign, nonatomic) int currentPageIndex;
/// 存放初始化时传入的 frame
@property (assign, nonatomic) CGRect viewRect;
/// 定时器
@property (strong, nonatomic) NSTimer *timer;
/// page 的页数
@property (assign, nonatomic) NSUInteger pageCount;
@end

@implementation HPAdView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame adObjectArray:nil];
}

- (id)initWithFrame:(CGRect)frame adObjectArray:(NSArray *)adObjectArr
{
    self = [super initWithFrame:frame];
    _imgViewArray = [NSMutableArray array];
    
    if (self)
    {
        _viewRect = frame;
        
        //scrollView初始化
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, _viewRect.size.width, _viewRect.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        //pageControl初始化
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(32, frame.size.height - 12, frame.size.width , 8)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = [adObjectArr count];
        [self addSubview:_pageControl];
        
        //加载数据
        [self reloadAdObjectArr:adObjectArr];
        
    }
    return self;
}

- (void)reloadAdObjectArr:(NSArray *)adObjectArr
{
    if ([adObjectArr count] == 0)
    {
        _scrollView.frame = CGRectZero;
        self.frame = CGRectZero;
        [_timer invalidate];
        return;
    }
    else if ([adObjectArr count] == 1)
    {
        self.frame = _viewRect;
        _scrollView.frame = CGRectMake(0, 0, _viewRect.size.width, _viewRect.size.height);
        [_timer invalidate];
        _scrollView.scrollEnabled = NO;
    }
    else
    {
        self.frame = _viewRect;
        _scrollView.frame = CGRectMake(0, 0, _viewRect.size.width, _viewRect.size.height);
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(changePic) userInfo:nil repeats:YES];
        _scrollView.scrollEnabled = YES;
    }
    
    float pageControlWidth = ([adObjectArr count] - 1) * 8.0;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = [adObjectArr count];
    [_pageControl setFrame:CGRectMake(32 + pageControlWidth/2, _viewRect.size.height - 12, pageControlWidth, 8.0)];
    
    
    for (UIImageView *imgView in _imgViewArray)
    {
        [imgView removeFromSuperview];
    }
    [_imgViewArray removeAllObjects];
    
    [_imgViewArray addObject:[self imageViewWithFrame:CGRectMake(0, 0, _viewRect.size.width, _viewRect.size.height) tag:0 adObject:[adObjectArr lastObject]]];
    for (AdObject *adObj in adObjectArr)
    {
        int index = [adObjectArr indexOfObject:adObj] + 1;
        [_imgViewArray addObject:[self imageViewWithFrame:CGRectMake(_viewRect.size.width * index, 0, _viewRect.size.width, _viewRect.size.height) tag:index adObject:adObj]];
    }
    [_imgViewArray addObject:[self imageViewWithFrame:CGRectMake(_viewRect.size.width * (adObjectArr.count + 1), 0, _viewRect.size.width, _viewRect.size.height) tag:(adObjectArr.count + 1) adObject:[adObjectArr firstObject]]];
    
    _pageCount = [_imgViewArray count];
    _scrollView.contentSize = CGSizeMake(_viewRect.size.width * _pageCount, _viewRect.size.height);
    
    [_scrollView setContentOffset:CGPointMake(_viewRect.size.width, 0)];
    
}

- (UIImageView *)imageViewWithFrame:(CGRect)frame tag:(int)tag adObject:(AdObject *)adObj
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.tag = tag;
    [imageView sd_setImageWithURL:[NSURL URLWithString:adObj.imagePath] placeholderImage:_placeholderImage];
    [_scrollView addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    
    return imageView;
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(hpAdView:clickedAtIndex:)])
    {
        [_delegate hpAdView:self clickedAtIndex:sender.view.tag -1];
    }
}

- (void)changePic
{
    if (_currentPageIndex == [_imgViewArray count] - 1)
    {
        _currentPageIndex = 0;
    }
    else
    {
        _currentPageIndex++;
    }
    _pageControl.currentPage = _currentPageIndex - 1;
    if (_currentPageIndex == 0)
    {
        [_scrollView setContentOffset:CGPointMake(([_imgViewArray count] -2) * _viewRect.size.width, 0)];
    }
    else if (_currentPageIndex == ([_imgViewArray count] -1))
    {
        [_scrollView setContentOffset:CGPointMake(_viewRect.size.width, 0)];
    }
    
    [_scrollView setContentOffset:CGPointMake(_viewRect.size.width * _currentPageIndex, 0) animated:YES];
}

#pragma mark -
#pragma mark -- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPageIndex = page;
    
    _pageControl.currentPage = page-1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_currentPageIndex == 0)
    {
        [_scrollView setContentOffset:CGPointMake(([_imgViewArray count] -2) *_viewRect.size.width, 0)];
    }
    else if(_currentPageIndex == ([_imgViewArray count] -1))
    {
        [_scrollView setContentOffset:CGPointMake(_viewRect.size.width, 0)];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //手动滑动，当手指离开页面时重新开启定时器
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(changePic) userInfo:nil repeats:YES];
}

@end
