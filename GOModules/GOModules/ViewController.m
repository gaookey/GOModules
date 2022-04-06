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
    NSArray *images = @[@"https://picsum.photos/300/300", @"https://picsum.photos/300/300", @"https://picsum.photos/300/300", @"https://picsum.photos/300/300", @"https://picsum.photos/300/300", @"https://picsum.photos/300/300"];
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
