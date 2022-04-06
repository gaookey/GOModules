//
//  GOCategoryView.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "GOCategoryView.h"

@interface GOCategoryView ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation GOCategoryView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 120);
}

#pragma mark - lazy
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 0; i < 33; i ++) {
            [_datas addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
    }
    return _datas;
}

@end
