//
//  BaseViewController.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2015-12-27.
//  Copyright © 2015 CrowdSound. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+RESideMenu.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"menu"];
    //image.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showMenuViewController)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void) showMenuViewController {
    [self presentLeftMenuViewController:@"MenuTableViewController"];
    
}


@end

@interface BaseCollectionViewController()

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuViewController)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void) showMenuViewController {
    [self presentLeftMenuViewController:@"MenuTableViewController"];
    
}

@end
