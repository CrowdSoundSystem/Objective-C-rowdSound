
#import "SpotifyDataScraper.h"
#import "Song.h"
#import "CSServiceInterface.h"

@implementation SpotifyDataScraper

- (void)authenticateSpotify {
    
    SPTAuth *authInstance = [SPTAuth defaultInstance];
    
    [authInstance setClientID:@"14c86fe3becb4129ba13cc3e9bfc7dd3"];
    [authInstance setRedirectURL:[NSURL URLWithString:@"cs://postlogin"]];
    [authInstance setRequestedScopes:@[SPTAuthUserLibraryReadScope]];
    
    // Construct a login URL and open it
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:loginURL];
    
}

// Handle auth callback
+ (BOOL) openSpotifyURL:(NSURL *)url {
    
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
            } else {
                NSLog(@"Successfully authenticated, access Token is: %@", session.accessToken);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticatedSpotify" object:nil];
        }];
        return YES;
    }
    
    return NO;
}

- (BFTask*) scrapeAllSpotifyFavourites {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    SPTSession *session = [[SPTAuth defaultInstance] session];
    
    if (!session) {
        NSLog(@"Session is nil and need to authenticate again");
        [task setError:[[NSError alloc] initWithDomain:@"Spotify-Auth" code:1 userInfo:nil]];
        return task.task;
    }
    
    [self fetchAllSavedTracksWithSession:session callback:^(NSError * error, NSArray * savedTracks) {
        if (error) {
            NSLog(@"There was some sort of error");
            [task setError:error];
        } else {
            
            int count = (int)[savedTracks count];
            
            NSMutableArray* songObjectList = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < count; i++) {
                NSArray *artistsArray = [[savedTracks objectAtIndex:i] artists];
                NSMutableArray *artistsNames = [[NSMutableArray alloc]init];
                
                Song *song = [[Song alloc]init];
                [song setName:[[savedTracks objectAtIndex:i] name]];
                
                for (int j = 0; j < [artistsArray count]; j++) {
                    [artistsNames addObject:[[artistsArray objectAtIndex:j] name]];
                }
                if (!artistsArray) {
                    [song setArtists:nil];
                } else {
                    [song setArtists:[[NSMutableArray alloc]initWithArray:artistsNames]];
                }
                [song setGenre:nil];
                
                [songObjectList addObject:song];
            }
            [task setResult:songObjectList];
            
            NSLog(@"The number of tracks in total is: %d", count);
        }
    }];
    
    return task.task;
}

 - (void) fetchAllSavedTracksWithSession:(SPTSession *)session callback:(void (^)(NSError *, NSArray *))callback {
    [SPTYourMusic savedTracksForUserWithAccessToken:session.accessToken callback:^(NSError *error, id object) {
        if (error) {
            NSLog(@"Calling for user's saved tracks threw an error");
            callback(error, nil);
            return;
        }
        
        [self didFetchListPageForSession:session finalCallback:callback error:error page:(SPTListPage *)object allItems:[NSMutableArray array]];
    }];
}

 - (void)didFetchListPageForSession:(SPTSession *)session finalCallback:(void (^)(NSError*, NSArray*))finalCallback error:(NSError *)error page:(SPTListPage *)page allItems:(NSMutableArray *)allItems {
    
    for (SPTSavedTrack *track in page.items) {
        [allItems addObject:track];
    }
    if (page.hasNextPage) {
        [page requestNextPageWithAccessToken:session.accessToken callback:^(NSError *error, id object) {
            [self didFetchListPageForSession:session finalCallback:finalCallback error:error page: (SPTListPage *)object allItems:allItems];
        }];
    } else {
        finalCallback(nil, [allItems copy]);
    }
    
}


@end
