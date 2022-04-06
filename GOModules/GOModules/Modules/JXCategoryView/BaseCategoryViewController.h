//
//  BaseCategoryViewController.h
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXPagerView.h>
#import "BaseCategoryHeaderView.h"
#import "BaseCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCategoryViewController : UIViewController <JXPagerViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;

@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) BaseCategoryHeaderView *headerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) NSArray <NSString *> *titles;


@end

NS_ASSUME_NONNULL_END
