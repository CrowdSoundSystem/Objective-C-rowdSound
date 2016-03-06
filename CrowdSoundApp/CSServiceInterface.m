
#import "CSServiceInterface.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import <CrowdsoundService.pbrpc.h>
#import <RxLibrary/GRXWriter+Immediate.h>

@interface CSServiceInterface ()

@property (nonatomic, strong) CSCrowdSound* service;

@end



@implementation CSServiceInterface

static NSString * const kHostAddress = @"192.168.43.118:50051";

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

-(BFTask *) getSessionData {
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    
    [_service getSessionDataWithRequest:[CSGetSessionDataRequest message] handler:^(CSGetSessionDataResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"There was an error: %@", error);
            [task setError:error];
        } else {
            SessionData *data = [[SessionData alloc]init];
            data.numberOfUsers = response.numUsers;
            data.sessionName = response.sessionName;
            [task setResult:data];
        }
    }];
    
    return task.task;
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
                [song setArtist:response.artist];
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
    
    
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* uid = [defaults objectForKey:@"id"];
    
    if (uid) {
        request.userId = uid;
    } else {
        NSString *UUID = [[NSUUID UUID] UUIDString];
        request.userId = UUID;
        [defaults setObject:UUID forKey:@"id"];
    }
    
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

- (BFTask *) getTrendingArtists {
    
    CSListTrendingArtistsRequest *request = [CSListTrendingArtistsRequest message];
    
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    NSMutableArray *trendingArtists = [[NSMutableArray alloc]init];
    
    __block int count = 0;
    
    [_service listTrendingArtistsWithRequest:request eventHandler:^(BOOL done, CSListTrendingArtistsResponse *response, NSError *error) {
        if (done) {
            [task setResult:trendingArtists];
        } else {
            if (error) {
                NSLog(@"There was an error: %@", error);
                [task setError:error];
            } else {
                TrendingArtist *artist = [[TrendingArtist alloc]init];
                artist.name = response.name;
                artist.weight = [[NSNumber alloc]initWithInt:response.score];
                count++;
                [trendingArtists addObject:artist];
                
                if (count <= 20) {
                }
            }
        }
    }];
    
    return task.task;
}



@end
