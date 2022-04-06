//
//  ViewController.m
//  GOModules
//
//  Created by gaookey on 2022/4/6.
//

#import "ViewController.h"
#import "GOCategoryViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.lightTextColor;
}
 
- (IBAction)pushCategoryViewController {
    [self.navigationController pushViewController:[[GOCategoryViewController alloc] init] animated:YES];
}

@end
