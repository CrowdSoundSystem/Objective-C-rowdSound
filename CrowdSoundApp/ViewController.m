

#import "ViewController.h"
#import <CrowdSoundProto.pbrpc.h>
#import <RxLibrary/GRXWriter+Immediate.h>
#import <RxLibrary/GRXWriter+Transformations.h>
#import <GRPCClient/GRPCCall+Tests.h>

static NSString * const kHostAddress = @"localhost:50051";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // This only needs to be done once per host, before creating service objects for that host.
    [GRPCCall useInsecureConnectionsForHost:kHostAddress];
    
    CSCrowdSound *service = [[CSCrowdSound alloc] initWithHost:kHostAddress];
    
    [service listSongsWithRequest:[[CSListSongsRequest alloc]init] eventHandler:^(BOOL done, CSListSongsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"There was an error");
        } else {
            NSLog(@"Name: %@", response.name);
        }
        if (done) {
            NSLog(@"Stream complete");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
