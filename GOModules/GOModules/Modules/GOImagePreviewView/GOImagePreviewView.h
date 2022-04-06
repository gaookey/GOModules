//
//  GOImagePreviewView.h
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import <Foundation/Foundation.h>
#import <QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GOImagePreviewView : NSObject <QMUIImagePreviewViewDelegate>

+ (instancetype)shared ;

- (void)showImages:(NSArray <NSString*>*)images views:(NSArray <UIView *>*)views currentIndex:(NSUInteger)currentIndex ;

@property (nonatomic, copy) void (^exitBlock)(NSUInteger index);
@property (nonatomic, copy) void (^didScrollToItem)(NSUInteger index);

@end

NS_ASSUME_NONNULL_END
