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

@property(nonatomic, strong)  NSArray <NSString*> *images;
@property (nonatomic, strong) NSArray <UIView*> *views;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation GOImagePreviewView

static GOImagePreviewView *instance = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return instance;
}

- (void)showImages:(NSArray<NSString *> *)images views:(NSArray<UIView *> *)views currentIndex:(NSUInteger)currentIndex {
    
    instance.images = [NSArray arrayWithArray:images];
    instance.views = [NSArray arrayWithArray:views];
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
    zoomImageView.reusedIdentifier = @(index);
    zoomImageView.image = [UIImage imageNamed:@"placeholder_image"];
    
    NSString *url = instance.images[index];
    
    if ([url hasSuffix:@".mp4"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([zoomImageView.reusedIdentifier isEqual:@(index)]) {
                AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
                zoomImageView.videoPlayerItem = item;
            }
        });
    } else {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            zoomImageView.image = image;
        }];
    }
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    if ([instance.images[index] hasSuffix:@".mp4"]) {
        return QMUIImagePreviewMediaTypeVideo;
    }
    return QMUIImagePreviewMediaTypeImage;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView didScrollToIndex:(NSUInteger)index {
    instance.imagePreviewViewController.sourceImageView = ^UIView *{
        if (index >= instance.views.count) {
            return [[UIView alloc] init];
        }
        return instance.views[index];
    };
    if (instance.didScrollToIndex) {
        instance.didScrollToIndex(index);
    }
    
    //    if ([instance.images[index] hasSuffix:@".mp4"]) {
    //        QMUIZoomImageView *zoomImageView = [imagePreviewView zoomImageViewAtIndex:index];
    //        [zoomImageView.videoPlayerLayer.player play];
    //        zoomImageView.videoCenteredPlayButton.hidden = YES;
    //    }
}

#pragma mark - <QMUIZoomImageViewDelegate>
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    UIViewController *rootVC = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
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
                if (instance.currentImageIndex) {
                    instance.currentImageIndex(exitAtIndex);
                }
            }
        };
    }
    return _imagePreviewViewController;
}

@end
