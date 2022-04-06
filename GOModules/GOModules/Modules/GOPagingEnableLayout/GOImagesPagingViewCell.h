//
//  GOImagesPagingViewCell.h
//  GOImagesPagingViewCell
//
//  Created by gaookey on 2021/6/10.
//

#import <UIKit/UIKit.h>
#import "GOImagesPagingOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface GOImagesPagingViewCell : UICollectionViewCell

@property (nonatomic, strong) GOImagesPagingOptions *options;
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
