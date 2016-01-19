#import "CrowdsoundService.pbrpc.h"

#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>

static NSString *const kPackageName = @"CrowdSound";
static NSString *const kServiceName = @"CrowdSound";

@implementation CSCrowdSound

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  return (self = [super initWithHost:host packageName:kPackageName serviceName:kServiceName]);
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}


#pragma mark GetQueue(GetQueueRequest) returns (stream GetQueueResponse)

- (void)getQueueWithRequest:(CSGetQueueRequest *)request eventHandler:(void(^)(BOOL done, CSGetQueueResponse *response, NSError *error))eventHandler{
  [[self RPCToGetQueueWithRequest:request eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToGetQueueWithRequest:(CSGetQueueRequest *)request eventHandler:(void(^)(BOOL done, CSGetQueueResponse *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"GetQueue"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CSGetQueueResponse class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
#pragma mark ListTrendingArtists(ListTrendingArtistsRequest) returns (stream ListTrendingArtistsResponse)

- (void)listTrendingArtistsWithRequest:(CSListTrendingArtistsRequest *)request eventHandler:(void(^)(BOOL done, CSListTrendingArtistsResponse *response, NSError *error))eventHandler{
  [[self RPCToListTrendingArtistsWithRequest:request eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToListTrendingArtistsWithRequest:(CSListTrendingArtistsRequest *)request eventHandler:(void(^)(BOOL done, CSListTrendingArtistsResponse *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"ListTrendingArtists"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CSListTrendingArtistsResponse class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
#pragma mark PostSong(stream PostSongRequest) returns (PostSongResponse)

- (void)postSongWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(CSPostSongResponse *response, NSError *error))handler{
  [[self RPCToPostSongWithRequestsWriter:requestWriter handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToPostSongWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(CSPostSongResponse *response, NSError *error))handler{
  return [self RPCToMethod:@"PostSong"
            requestsWriter:requestWriter
             responseClass:[CSPostSongResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark VoteSong(VoteSongRequest) returns (VoteSongResponse)

- (void)voteSongWithRequest:(CSVoteSongRequest *)request handler:(void(^)(CSVoteSongResponse *response, NSError *error))handler{
  [[self RPCToVoteSongWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToVoteSongWithRequest:(CSVoteSongRequest *)request handler:(void(^)(CSVoteSongResponse *response, NSError *error))handler{
  return [self RPCToMethod:@"VoteSong"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CSVoteSongResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
@end
