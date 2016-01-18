#import "CrowdsoundService.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>


@protocol CSCrowdSound <NSObject>

#pragma mark ListSongs(ListSongsRequest) returns (stream ListSongsResponse)

- (void)listSongsWithRequest:(CSListSongsRequest *)request eventHandler:(void(^)(BOOL done, CSListSongsResponse *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToListSongsWithRequest:(CSListSongsRequest *)request eventHandler:(void(^)(BOOL done, CSListSongsResponse *response, NSError *error))eventHandler;


#pragma mark ListTrendingArtists(ListTrendingArtistsRequest) returns (stream ListTrendingArtistsResponse)

- (void)listTrendingArtistsWithRequest:(CSListTrendingArtistsRequest *)request eventHandler:(void(^)(BOOL done, CSListTrendingArtistsResponse *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToListTrendingArtistsWithRequest:(CSListTrendingArtistsRequest *)request eventHandler:(void(^)(BOOL done, CSListTrendingArtistsResponse *response, NSError *error))eventHandler;


#pragma mark PostSong(stream PostSongRequest) returns (PostSongResponse)

- (void)postSongWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(CSPostSongResponse *response, NSError *error))handler;

- (ProtoRPC *)RPCToPostSongWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(CSPostSongResponse *response, NSError *error))handler;


#pragma mark VoteSong(VoteSongRequest) returns (VoteSongResponse)

- (void)voteSongWithRequest:(CSVoteSongRequest *)request handler:(void(^)(CSVoteSongResponse *response, NSError *error))handler;

- (ProtoRPC *)RPCToVoteSongWithRequest:(CSVoteSongRequest *)request handler:(void(^)(CSVoteSongResponse *response, NSError *error))handler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface CSCrowdSound : ProtoService<CSCrowdSound>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
@end
