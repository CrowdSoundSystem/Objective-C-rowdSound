
#import "CSServiceInterface.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import <CrowdsoundService.pbrpc.h>

@interface CSServiceInterface ()

@property (nonatomic, strong) CSCrowdSound* service;

@end



@implementation CSServiceInterface

static NSString * const kHostAddress = @"cs.ephyra.io:50051";

+ (id)sharedInstance {
    static CSServiceInterface *sharedServiceInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServiceInterface = [[self alloc] init];
    });
    return sharedServiceInterface;
}

- (id)init {
    if (self = [super init]) {
        [GRPCCall useInsecureConnectionsForHost:kHostAddress];
        _service = [[CSCrowdSound alloc] initWithHost:kHostAddress];
    }
    return self;
}

-(BFTask *) getSongQueue {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    NSMutableArray *queue = [[NSMutableArray alloc]init];
    
    [_service listSongsWithRequest:[[CSListSongsRequest alloc]init] eventHandler:^(BOOL done, CSListSongsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"There was an error");
            [task setError:error];
        } else {
            NSLog(@"Name: %@", response.name);
            
            NowPlayingSongItem *song = [[NowPlayingSongItem alloc]init];
            [song setName:response.name];
            [song setIsPlaying:response.isPlaying];
            [queue addObject:song];
        }
        if (done) {
            NSLog(@"Stream complete");
            [task setResult:queue];
        }
    }];
    
    return task.task;
}

@end
