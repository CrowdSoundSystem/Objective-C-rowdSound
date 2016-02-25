//
//  SpotifyDataScraper.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-02-24.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>
#import "Bolts.h"

@interface SpotifyDataScraper : NSObject

- (void)authenticateSpotify;

+ (BOOL) openSpotifyURL:(NSURL *)url;

- (BFTask*) scrapeAllSpotifyFavourites;

- (void) fetchAllSavedTracksWithSession:(SPTSession *)session callback:(void (^)(NSError *, NSArray *))callback;

- (void)didFetchListPageForSession:(SPTSession *)session finalCallback:(void (^)(NSError*, NSArray*))finalCallback error:(NSError *)error page:(SPTListPage *)page allItems:(NSMutableArray *)allItems;

@property(strong, nonatomic) SPTSession *session;

@end
