//
//  GOCategoryViewController.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "GOCategoryViewController.h"
#import "GOHeaderView.h"
#import "GOCategoryView.h"
#import "GOModules-Swift.h"

@interface GOCategoryViewController ()

@property (nonatomic, strong) GOHeaderView *homeHeaderView;

@end

@implementation GOCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self config];
}

- (void)config {
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.categoryTitleView.backgroundColor = UIColor.lightGrayColor;
    self.pagingView.frame = CGRectMake(0, SafeAreaInsetsOC.safeAreaInsetsTop, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - SafeAreaInsetsOC.safeAreaInsetsTop);
    self.pagingView.mainTableView.backgroundColor = UIColor.lightGrayColor;
    
    self.titles = @[@"标题01", @"标题02", @"标题02", @"标题03", @"标题04", @"标题05", @"标题06", @"标题07", @"标题08", @"标题09"];
    self.headerViewHeight = 500;
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.homeHeaderView;
}
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    GOCategoryView *view = [[GOCategoryView alloc] init];
    view.index = index;
    return view;
}

#pragma mark - lazy
- (GOHeaderView *)homeHeaderView {
    if (!_homeHeaderView) {
        _homeHeaderView = [[GOHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.headerViewHeight)];
    }
    return _homeHeaderView;
}

@end
