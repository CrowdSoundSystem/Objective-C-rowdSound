
#import "CSServiceInterface.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import <CrowdsoundService.pbrpc.h>
#import <RxLibrary/GRXWriter+Immediate.h>
#import "Helper.h"

@interface CSServiceInterface ()

@property (nonatomic, strong) CSCrowdSound* service;

@end



@implementation CSServiceInterface

static NSString * const defaultHostAddress = @"cs.ephyra.io:50051";
static CSServiceInterface *sharedServiceInterface;

+ (id)sharedInstance {
    if (sharedServiceInterface == nil) {
        sharedServiceInterface = [[CSServiceInterface alloc]initWithHostAddress:defaultHostAddress];
    }
    return sharedServiceInterface;
}

+ (id)sharedInstanceWithDynamicHostAddr: (NSString *) hostAddr {
    if (sharedServiceInterface == nil) {
        sharedServiceInterface = [[CSServiceInterface alloc]initWithHostAddress:hostAddr];
    }
    return sharedServiceInterface;
}

- (id)initWithHostAddress: (NSString *)hostAddr {
    if (self = [super init]) {
        [GRPCCall useInsecureConnectionsForHost:hostAddr];
        _service = [[CSCrowdSound alloc] initWithHost:hostAddr];
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
    
    CSGetQueueRequest *request = [CSGetQueueRequest message];
    request.userId = [Helper getUserId];
    
    [_service getQueueWithRequest:request eventHandler:^(BOOL done, CSGetQueueResponse *response, NSError *error) {
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
                [song setArtists:[[NSMutableArray alloc]initWithArray:@[response.artist]]];
                [item setSong:song];
                [item setIsPlaying:response.isPlaying];
                [item setIsBuffered:response.isBuffered];
                [queue addObject:item];
            }
        }
    }];
    
    return task.task;
}

- (BFTask *) getIsPlaying {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    CSGetPlayingRequest *request = [CSGetPlayingRequest message];
    request.userId = [Helper getUserId];
    
    [_service getPlayingWithRequest:[CSGetPlayingRequest message] handler:^(CSGetPlayingResponse *response, NSError *error) {
        if (!error) {
            NowPlayingSongItem *item = [[NowPlayingSongItem alloc]init];
            Song *song = [[Song alloc]init];
            [song setName:response.name];
            [song setArtists:[[NSMutableArray alloc]initWithArray:@[response.artist]]];
            [item setSong:song];
            [task setResult:item];
        } else {
            [task setError:error];
            NSLog(@"There was an error: %@", error);
        }
    }];
    
    return task.task;
}

-(BFTask *) sendSongs:(NSArray *)songs {
    NSMutableArray *postSongRequests = [[NSMutableArray alloc]init];
    for (int i = 0; i < songs.count; i++) {
        CSPostSongRequest *request = [CSPostSongRequest message];
        request.name = ((Song *)songs[i]).name;
        request.artistArray = ((Song *)songs[i]).artists;
        request.genre = ((Song *)songs[i]).genre;
        request.userId = [Helper getUserId];
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
    request.userId = [Helper getUserId];
    request.like = like;
    
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
}

- (BFTask *)voteToSkip {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    CSVoteSkipRequest *request = [CSVoteSkipRequest message];
    request.userId = [Helper getUserId];
    
    [_service voteSkipWithRequest:request handler:^(CSVoteSkipResponse *response, NSError *error) {
        if (error) {
            [task setError:error];
            NSLog(@"Error with vote skip, %@", error);
        } else {
            [task setResult:response];
        }
    }];
    return task.task;
}

- (BFTask *)voteForArtist:(NSString *)artist withValue: (BOOL)value {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    CSVoteArtistRequest *request = [CSVoteArtistRequest message];
    
    request.userId = [Helper getUserId];
    request.artist = artist;
    request.like = value;
    
    [_service voteArtistWithRequest:request handler:^(CSVoteArtistResponse *response, NSError *error) {
        if (error) {
            [task setError:error];
            NSLog(@"Error with vote for artist, %@", error);
        } else {
            [task setResult:response];
        }
    }];
    
    return task.task;
    
    
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
