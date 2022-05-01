//
//  ViewController.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "ViewController.h"
#import "GOCategoryViewController.h"
#import "GOImagePreviewView.h"
#import <UIImageView+WebCache.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.lightTextColor;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://picsum.photos/300/300"]];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction)]];
}

- (void)imageViewAction {
    NSArray *images = @[
        @"https://picsum.photos/600/300",
        @"https://ddg-mall-test.obs.cn-north-4.myhuaweicloud.com/dr-test%2Fbusiness%2Ffile%2Fbb0cc146-847d-424a-a9f9-4a5f8576c4d9.mp4",
        @"https://picsum.photos/800/500",
        @"https://picsum.photos/1000/700",
        @"https://picsum.photos/300/300",
        @"https://picsum.photos/300/300"];
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i ++) {
        [views addObject:self.imageView];
    }
    
    [[GOImagePreviewView shared] showImages:images views:views currentIndex:1];
}

- (IBAction)pushCategoryViewController {
    [self.navigationController pushViewController:[[GOCategoryViewController alloc] init] animated:YES];
}

 

@end
