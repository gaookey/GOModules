//
//  GOImagesPagingOptions.m
//  BrandUIKit
//
//  Created by gaookey on 2021/6/10.
//

#import "GOImagesPagingOptions.h"

@implementation GOImagesPagingOptions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.margin = 5;
        self.placeholderImage = @"";
        self.offsetX = 0;
        self.cellBackgroundColor = UIColor.clearColor;
        self.edgeInsets = UIEdgeInsetsZero;
        self.pagingEnabled = YES;
        self.bounces = YES;
    }
    return self;
}
 
@end
