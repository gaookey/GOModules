//
//  GOPagingEnableLayout.m
//  GOPagingEnableLayout
//
//  Created by gaookey on 2021/6/10.
//

#import "GOPagingEnableLayout.h"
#import <objc/message.h>

@implementation GOPagingEnableLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    CGFloat contentInset = self.collectionView.frame.size.width - self.pagingItemSize.width;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setInterpageSpacing:")]) {
        ((void(*)(id,SEL,CGSize))objc_msgSend)(self.collectionView, NSSelectorFromString(@"_setInterpageSpacing:"), CGSizeMake(-(contentInset - self.minimumLineSpacing), 0));
    }
    if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setPagingOrigin:")]) {
        ((void(*)(id,SEL,CGPoint))objc_msgSend)(self.collectionView, NSSelectorFromString(@"_setPagingOrigin:"), CGPointMake(self.offsetX, 0));
    }
}

@end
