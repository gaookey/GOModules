//
//  GOImagesPagingView.m
//  GOImagesPagingView
//
//  Created by gaookey on 2021/6/10.
//

#import "GOImagesPagingView.h"
#import "GOPagingEnableLayout.h"
#import <Masonry.h>

@interface GOImagesPagingView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) GOImagesPagingOptions *options;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation GOImagesPagingView

- (instancetype)initWithOptions:(GOImagesPagingOptions *)options {
    self = [super init];
    if (self) {
        self.options = options;
        [self initView];
    }
    return self;
}
- (void)scrollToItem:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
- (void)setImageUrls:(NSMutableArray<NSString *> *)imageUrls {
    _imageUrls = imageUrls;
    [self.collectionView reloadData];
    
    if (imageUrls.count > 0) {
        self.pageLable.text = [NSString stringWithFormat:@"%ld / %lu", 1, (unsigned long)self.imageUrls.count];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else {
        self.pageLable.text = [NSString stringWithFormat:@"%ld / %lu", 0, (unsigned long)self.imageUrls.count];
    }
}
- (void)setIsHiddenPageLable:(BOOL)isHiddenPageLable {
    self.pageLable.hidden = isHiddenPageLable;
}
- (void)setIsHiddenSoldOutLable:(BOOL)isHiddenSoldOutLable {
    self.soldOutLable.hidden = isHiddenSoldOutLable;
}
- (void)initView {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageLable];
    [self addSubview:self.soldOutLable];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.pageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(52);
        make.leading.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.soldOutLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.height.mas_equalTo(150);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GOImagesPagingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GOImagesPagingViewCellID" forIndexPath:indexPath];
    cell.options = self.options;
    cell.url = self.imageUrls[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.parameter.count) {
        return;
    }
    
    GOImagesPagingViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *vs = [NSMutableArray array];
    if (cell == nil) {
        for (NSInteger i = 0; i < self.imageUrls.count; i ++) {
            [vs addObject:[[UIView alloc] init]];
        }
    } else {
        for (NSInteger i = 0; i < self.imageUrls.count; i ++) {
            [vs addObject:cell];
        }
    }
    
    if (self.didSelectItem) {
        self.didSelectItem(indexPath.row, vs, self.parameter[indexPath.row]);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagingView:didSelectItem:views:parameter:)]) {
        [self.delegate pagingView:self didSelectItem:indexPath.row views:vs parameter:self.parameter[indexPath.row]];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = self.collectionView.contentOffset.x / self.options.itemSize.width;
    CGFloat maxW = self.options.itemSize.width * self.imageUrls.count + (self.imageUrls.count - 1) * self.options.margin;
    
    if ((int)(self.collectionView.contentOffset.x) >= (int)(maxW - [[UIScreen mainScreen] bounds].size.width)) {
        self.pageLable.text = [NSString stringWithFormat:@"%ld / %ld", self.imageUrls.count, self.imageUrls.count];
        self.currentPage = self.imageUrls.count - 1;
    } else {
        self.pageLable.text = [NSString stringWithFormat:@"%ld / %ld", currentPage + 1, self.imageUrls.count];
        self.currentPage = currentPage;
    }
    
    if (self.didScroll) {
        CGFloat scale = scrollView.contentOffset.x / (maxW - [[UIScreen mainScreen] bounds].size.width);
        self.didScroll(scale);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagingView:didEndDragging:)]) {
        [self.delegate pagingView:self didEndDragging:self.collectionView];
    }
    if (self.didEndDragging) {
        self.didEndDragging();
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagingView:willBeginDragging:)]) {
        [self.delegate pagingView:self willBeginDragging:self.collectionView];
    }
    if (self.willBeginDragging) {
        self.willBeginDragging();
    }
} 

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    _currentPage = currentPage;
    if (self.didScrollToItem) {
        self.didScrollToItem(currentPage);
    }
}
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (NSArray<GOImagesPagingViewCell *> *)visibleCells {
    return self.collectionView.visibleCells;
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GOPagingEnableLayout *layout = [[GOPagingEnableLayout alloc] init];
        layout.pagingItemSize = self.options.itemSize;
        layout.offsetX = self.options.offsetX;
        layout.sectionInset = self.options.edgeInsets;
        layout.minimumLineSpacing = self.options.margin;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[GOImagesPagingViewCell class] forCellWithReuseIdentifier:@"GOImagesPagingViewCellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = self.options.pagingEnabled;
        _collectionView.bounces = self.options.bounces;
    }
    return _collectionView;
}
- (UILabel *)pageLable {
    if (!_pageLable) {
        _pageLable = [[UILabel alloc] init];
        _pageLable.font = [UIFont systemFontOfSize:12];
        _pageLable.textColor = UIColor.whiteColor;
        _pageLable.textAlignment = NSTextAlignmentCenter;
        _pageLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _pageLable.layer.cornerRadius = 14;
        _pageLable.layer.masksToBounds = YES;
    }
    return _pageLable;
}
- (UILabel *)soldOutLable {
    if (!_soldOutLable) {
        _soldOutLable = [[UILabel alloc] init];
        _soldOutLable.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        _soldOutLable.textColor = UIColor.whiteColor;
        _soldOutLable.textAlignment = NSTextAlignmentCenter;
        _soldOutLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _soldOutLable.layer.cornerRadius = 75;
        _soldOutLable.layer.masksToBounds = YES;
        _soldOutLable.hidden = YES;
    }
    return _soldOutLable;
}

@end
