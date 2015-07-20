//
//  ViewController.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-12.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    //ConnectionManager* connManager;
    BOOL connected;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner startAnimating];
    connected = NO;
    
    /*[self initNetworkCommunication];
    [self nameSelf];
    [self sendMessage];*/

    
    /*// Talk to a server via socket, using a binary protocol
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"nish_pi" port:9091];
    TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    server = [[AddClient alloc] initWithProtocol:protocol];
    
    int num1 = 5;
    int num2 = 6;
    NSLog(@"num1: %d, num2: %d\n", num1, num2);
    
    int result = [server add:num1 num2:num2];
    
    NSLog(@"Result of addition: %d", result);*/

    
    //[self CallConnectionDelegate:true];
    
    
   //Form Connection
    self.connManager = [ConnectionManager sharedManager];
    
    self.connManager.delegate = self;
    
    [self.connManager Connect];

    
    // Do any additional setup after loading the view, typically from a nib.
}

//Check Connection Status
-(void)DidConnect:(BOOL)connectionSuccess {
    [self.spinner stopAnimating];
    
    if (connectionSuccess && !connected) {
        connected = YES;
        [self performSegueWithIdentifier:@"ShowTableView" sender:self];
        
        
    }
    /*WordCloudViewController *wcViewController = [[WordCloudViewController alloc]init];
    [self.navigationController pushViewController: wcViewController animated:YES];*/
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    /*[self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTableView"]) {
        UINavigationController *navController = (UINavigationController*)segue.destinationViewController;
        TableViewController *tableController = (TableViewController*)navController;
        tableController.connManager = self.connManager;
        
    }
}

/*- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.0.21", 80, &readStream, &writeStream);
    inputStream = objc_unretainedObject(readStream);
    outputStream = objc_unretainedObject(writeStream);
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}

-(void)nameSelf {
    NSString *response  = [NSString stringWithFormat:@"iam:%@", @"nish"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}
- (void)sendMessage {
    NSString *response  = [NSString stringWithFormat:@"msg:%@", @"niggas in paris"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}*/

@end
