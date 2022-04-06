//
//  GOImagesPagingView.h
//  GOImagesPagingView
//
//  Created by gaookey on 2021/6/10.
//

#import <UIKit/UIKit.h>
#import "GOImagesPagingOptions.h"
#import "GOImagesPagingViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class GOImagesPagingView;
@protocol GOImagesPagingViewDelegate <NSObject>

@optional
- (void)pagingView:(GOImagesPagingView *)pagerView didEndDragging:(UIScrollView *)scrollView ;
- (void)pagingView:(GOImagesPagingView *)pagerView willBeginDragging:(UIScrollView *)scrollView ;
- (void)pagingView:(GOImagesPagingView *)pagerView didScrollToItem:(NSInteger)index ;
- (void)pagingView:(GOImagesPagingView *)pagerView didSelectItem:(NSInteger)index views:(NSArray *)views parameter:(id)parameter;

@end

@interface GOImagesPagingView : UIView

@property (nonatomic, weak, nullable) id <GOImagesPagingViewDelegate> delegate;

- (instancetype)initWithOptions:(GOImagesPagingOptions *)options ;

@property (nonatomic, strong) NSMutableArray <NSString*>*imageUrls;
/// 点击事件需要传出去的参数。个数需要和图片数组相等
@property (nonatomic, strong) NSArray *parameter;
@property (nonatomic, strong) UILabel *pageLable;
@property (nonatomic, assign) BOOL isHiddenPageLable;
@property (nonatomic, strong) UILabel *soldOutLable;
@property (nonatomic, assign) BOOL isHiddenSoldOutLable;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;


@property (nonatomic, copy) void (^didSelectItem)(NSInteger index, NSArray *views, id parameter);
@property (nonatomic, copy) void (^didScrollToItem)(NSInteger index);
@property (nonatomic, copy) void (^didScroll)(CGFloat scale);
@property (nonatomic, copy) void (^didEndDragging)(void);
@property (nonatomic, copy) void (^willBeginDragging)(void);

- (void)scrollToItem:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
