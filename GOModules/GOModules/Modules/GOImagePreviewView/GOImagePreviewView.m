//
//  GOImagePreviewView.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "GOImagePreviewView.h"
#import <UIImageView+WebCache.h>

@interface GOImagePreviewView ()

@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;

@property(nonatomic, strong) NSArray <NSString*>*images;
@property (nonatomic, strong) NSArray <UIView*>*views;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation GOImagePreviewView

static GOImagePreviewView *instance = nil;

static dispatch_once_t onceToken;

+ (instancetype)shared {
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance initView];
    });
    return instance;
}

- (void)showImages:(NSArray<NSString *> *)images views:(NSArray<UIView *> *)views currentIndex:(NSUInteger)currentIndex {
    if (images.count != views.count || images.count <= currentIndex) {
        return;
    }
    instance.images = [NSArray array];
    instance.views = [NSArray array];
    instance.images = images;
    instance.views = views;
    instance.currentIndex = currentIndex;
    
    [instance showImage];
}

- (void)showImage {
    instance.imagePreviewViewController.imagePreviewView.currentImageIndex = instance.currentIndex;
    instance.imagePreviewViewController.sourceImageView = ^UIView *{
        if (instance.currentIndex >= instance.views.count) {
            return [[UIView alloc] init];
        }
        return instance.views[instance.currentIndex];
    };
    
    UIViewController *rootVC = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    [rootVC presentViewController:instance.imagePreviewViewController animated:YES completion:nil];
}

#pragma mark - <QMUIImagePreviewViewDelegate>
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return instance.images.count;
}
- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:instance.images[index]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image != nil) {
            zoomImageView.image = image;
        }
    }];
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView didScrollToIndex:(NSUInteger)index {
    instance.imagePreviewViewController.sourceImageView = ^UIView *{
        if (instance.currentIndex >= instance.views.count) {
            return [[UIView alloc] init];
        }
        return instance.views[index];
    };
    if (instance.didScrollToItem) {
        instance.didScrollToItem(index);
    }
}
#pragma mark - <QMUIZoomImageViewDelegate>
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    UIViewController *rootVC = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView {
    
}

#pragma mark - lazy
- (QMUIImagePreviewViewController *)imagePreviewViewController {
    if (!_imagePreviewViewController) {
        _imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        _imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;
        _imagePreviewViewController.imagePreviewView.delegate = instance;
        
        _imagePreviewViewController.qmui_visibleStateDidChangeBlock = ^(QMUIImagePreviewViewController *viewController, QMUIViewControllerVisibleState visibleState) {
            if (visibleState == QMUIViewControllerWillDisappear) {
                NSInteger exitAtIndex = viewController.imagePreviewView.currentImageIndex;
                if (instance.exitBlock) {
                    instance.exitBlock(exitAtIndex);
                }
            }
        };
    }
    return _imagePreviewViewController;
}

@end
