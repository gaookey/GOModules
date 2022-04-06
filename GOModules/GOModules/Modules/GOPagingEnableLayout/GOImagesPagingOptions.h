//
//  GOImagesPagingOptions.h
//  GOModules
//
//  Created by gaookey on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GOImagesPagingOptions : NSObject

@property (nonatomic, assign) CGSize itemSize;
/// 间距。默认5
@property (nonatomic, assign) CGFloat margin;
/// 占位图
@property (nonatomic, copy) NSString *placeholderImage;
/// 偏移量
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, assign) BOOL bounces;

@end

NS_ASSUME_NONNULL_END
