//
//  BaseCategoryViewController.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "BaseCategoryViewController.h"

@interface BaseCategoryViewController ()

@end

@implementation BaseCategoryViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = [NSArray array];
    self.headerViewHeight = 0;
    self.sectionHeaderHeight = 50;
    [self.view addSubview:self.pagingView];
}

#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionHeaderHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryTitleView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

// 子类重写此方法
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return [[BaseCategoryView alloc] init];
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.headerView scrollViewDidScroll:scrollView.contentOffset.y];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)setHeaderViewHeight:(CGFloat)headerViewHeight {
    _headerViewHeight = headerViewHeight;
    [self.pagingView resizeTableHeaderViewHeightWithAnimatable:YES duration:0 curve:UIViewAnimationCurveLinear];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    
    [self.categoryTitleView selectItemAtIndex:0];
    [self.pagingView reloadData];
    self.categoryTitleView.titles = titles;
    [self.categoryTitleView reloadData];
}

#pragma mark - lazy
- (BaseCategoryHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BaseCategoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.headerViewHeight)];
    }
    return _headerView;
}

- (JXCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[JXCategoryTitleView alloc] init];
        _categoryTitleView.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.sectionHeaderHeight);
        _categoryTitleView.titles = self.titles;
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleSelectedFont = [UIFont systemFontOfSize:15];
        _categoryTitleView.titleSelectedColor = UIColor.blackColor;
        _categoryTitleView.titleColor = UIColor.grayColor;
        _categoryTitleView.titleColorGradientEnabled = YES;
        _categoryTitleView.titleFont = [UIFont systemFontOfSize:15];
        _categoryTitleView.titleLabelZoomScrollGradientEnabled = NO;
        _categoryTitleView.indicators = @[self.lineView];
        _categoryTitleView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    }
    return _categoryTitleView;
}

- (JXCategoryIndicatorLineView *)lineView {
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = UIColor.blackColor;
    }
    return _lineView;
}

- (JXPagerView *)pagingView {
    if (!_pagingView) {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.frame = self.view.bounds;
        _pagingView.mainTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _pagingView.mainTableView.sectionHeaderTopPadding = 0;
        }
        _pagingView.pinSectionHeaderVerticalOffset = 44;
    }
    return _pagingView;
}

@end
