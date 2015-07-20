//
//  ConnectingViewController.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-20.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "ConnectingViewController.h"

@interface ConnectingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *IPandPortField;

@property (weak, nonatomic) IBOutlet UIButton *ConnectButton;
@end

@implementation ConnectingViewController

- (IBAction)ConnectButtonBressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowTableView" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewLoaded");
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Delimit Text Field to get IP and Port
    NSArray *serverandPort = [self.IPandPortField.text componentsSeparatedByString: @":"];
    NSString *server = serverandPort[0];
    NSString *port = serverandPort[1];
    
    //Make connection with server if segue is correct
    if ([[segue identifier] isEqualToString:@"ShowTableView"]) {
        
        [[ConnectionManager sharedManager] setServerIP:server];
        [[ConnectionManager sharedManager] setServerPort:port];
        [[ConnectionManager sharedManager] connect];
    }
}



@end
