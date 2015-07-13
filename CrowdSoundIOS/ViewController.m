//
//  ViewController.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-12.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.spinner startAnimating];
    
    //Form Connection
    ConnectionManager *connManager = [[ConnectionManager alloc]init];
    
    connManager.delegate = self;
    
    [connManager Connect];

    
    // Do any additional setup after loading the view, typically from a nib.
}

//Check Connection Status
-(void)DidConnect:(BOOL)connectionSuccess {
    [self.spinner stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
