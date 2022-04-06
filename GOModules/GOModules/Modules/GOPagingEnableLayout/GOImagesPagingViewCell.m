//
//  GOImagesPagingViewCell.m
//  GOImagesPagingViewCell
//
//  Created by gaookey on 2021/6/10.
//

#import "GOImagesPagingViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <SDWebImageWebPCoder.h>

@interface GOImagesPagingViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *placeholder;

@end

@implementation GOImagesPagingViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];
        
        [self initView];
    }
    return self;
}
- (void)setOptions:(GOImagesPagingOptions *)options {
    self.contentView.backgroundColor = options.cellBackgroundColor;
    self.placeholder = options.placeholderImage;
}
- (void)setUrl:(NSString *)url {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:self.placeholder]];
}
- (void)initView {
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
