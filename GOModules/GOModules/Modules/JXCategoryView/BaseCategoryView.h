//
//  BaseCategoryView.h
//  Soulmia
//
//  Created by gaookey on 2021/5/20.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCategoryView : UIViewController <JXPagerViewListViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
