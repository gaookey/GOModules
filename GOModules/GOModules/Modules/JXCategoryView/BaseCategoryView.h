//
//  BaseCategoryView.h
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCategoryView : UIViewController <JXPagerViewListViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
