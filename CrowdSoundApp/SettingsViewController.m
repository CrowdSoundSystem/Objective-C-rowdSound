//
//  SettingsViewController.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2015-12-27.
//  Copyright © 2015 CrowdSound. All rights reserved.
//

#import "SettingsViewController.h"
#import "CSServiceInterface.h"

@interface SettingsViewController ()
@property (strong) CSServiceInterface *csInterface;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _csInterface = [CSServiceInterface sharedInstance];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithSpotifyPressed:(id)sender {
    
    [[SPTAuth defaultInstance] setClientID:@"14c86fe3becb4129ba13cc3e9bfc7dd3"];
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"cs://postlogin"]];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthUserLibraryReadScope]];
    
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
                return;
            }
            NSLog(@"Access Token is: %@", session.accessToken);
            NSDate *methodStart = [NSDate date];
            [self fetchAllSavedTracksWithSession:session callback:^(NSError * error, NSArray * savedTracks) {
                if (error) {
                    NSLog(@"There was some sort of error");
                } else {
                    NSDate *methodFinish = [NSDate date];
                    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
                    NSLog(@"executionTime = %f", executionTime);

                    int count = (int)[savedTracks count];
                    
                    NSMutableArray* songObjectList = [[NSMutableArray alloc]init];
                    
                    for (int i = 0; i < count; i++) {
                        NSMutableString *artists = [[NSMutableString alloc]init];
                         
                        NSArray *artistsArray = [[savedTracks objectAtIndex:i] artists];
                        
                        for (int j = 0; j < [artistsArray count]; j++) {
                         [artists appendString:[[[artistsArray objectAtIndex:j] name] stringByAppendingString:@","]];
                        }
                        
                        Song *song = [[Song alloc]init];
                        [song setName:[[savedTracks objectAtIndex:i] name]];
                        [song setGenre:nil];
                        
                        [songObjectList addObject:song];
                        
                        
                     
                     //NSLog(@"Song name: %@, Artist: %@", [[savedTracks objectAtIndex:i] name], artists);
                    }
                    [[CSServiceInterface sharedInstance] sendSongs:songObjectList];

                    
                    NSLog(@"The number of tracks in total is: %d", count);
                    
                }
            }];
            
        }];
        return YES;
    }
    
    return NO;
}

+ (void) fetchAllSavedTracksWithSession:(SPTSession *)session callback:(void (^)(NSError *, NSArray *))callback {
    [SPTYourMusic savedTracksForUserWithAccessToken:session.accessToken callback:^(NSError *error, id object) {
        if (error) {
            NSLog(@"Calling for user's saved tracks threw an error");
            callback(error, nil);
            return;
        }
        
        SPTListPage *page = (SPTListPage *)object;
        
        [self didFetchListPageForSession:session finalCallback:callback error:error page:(SPTListPage *)object allItems:[NSMutableArray array]];
    }];
}

+ (void)didFetchListPageForSession:(SPTSession *)session finalCallback:(void (^)(NSError*, NSArray*))finalCallback error:(NSError *)error page:(SPTListPage *)page allItems:(NSMutableArray *)allItems {
    
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
