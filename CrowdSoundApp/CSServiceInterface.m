
#import "CSServiceInterface.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import <CrowdsoundService.pbrpc.h>
#import <RxLibrary/GRXWriter+Immediate.h>

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
    
    [_service getQueueWithRequest:[CSGetQueueRequest message] eventHandler:^(BOOL done, CSGetQueueResponse *response, NSError *error) {
        if (done) {
            NSLog(@"Stream complete");
            if (!error)
                [task setResult:queue];
        } else {
            if (error) {
                NSLog(@"There was an error: %@", error);
                [task setError:error];
            } else {
                NSLog(@"Name: %@", response.name);
                
                NowPlayingSongItem *item = [[NowPlayingSongItem alloc]init];
                Song *song = [[Song alloc]init];
                [song setName:response.name];
                [item setSong:song];
                [item setIsPlaying:response.isPlaying];
                [queue addObject:item];
            }
        }
    }];
    
    return task.task;
}

-(BFTask *) sendSongs:(NSArray *)songs {
    NSMutableArray *postSongRequests = [[NSMutableArray alloc]init];
    for (int i = 0; i < songs.count; i++) {
        CSPostSongRequest *request = [CSPostSongRequest message];
        request.name = ((Song *)songs[i]).name;
        request.artist = ((Song *)songs[i]).artist;
        request.genre = ((Song *)songs[i]).genre;
        request.userId = @"nish";
        [postSongRequests addObject:request];
    }
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    GRXWriter *songsWriter = [GRXWriter writerWithContainer:postSongRequests];
    
    [_service postSongWithRequestsWriter:songsWriter handler:^(CSPostSongResponse *response, NSError *error) {
        if (error) {
            NSLog(@"There was an error: %@", error);
            [task setError:error];
        } else {
            [task setResult:response];
        }
    }];
    
    return task.task;
}

-(BFTask *) voteForSong:(NSString *)songName withArtist:(NSString *)artist withValue:(BOOL)like {
    
    CSVoteSongRequest *request = [CSVoteSongRequest message];
    request.name = songName;
    request.artist = artist;
    request.like = like;
    request.userId = @"nish";
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    [_service voteSongWithRequest:request handler:^(CSVoteSongResponse *response, NSError *error) {
        
        if (error) {
            [task setError:error];
            NSLog(@"Error with vote song, %@", error);
        } else {
            [task setResult:response];
        }
    }];
    
    return task.task;
    
    return nil;
}



@end
