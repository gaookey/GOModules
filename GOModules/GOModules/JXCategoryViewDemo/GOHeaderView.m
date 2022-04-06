//
//  GOHeaderView.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "GOHeaderView.h"

@implementation GOHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
    self.backgroundColor = UIColor.brownColor;
}

@end
