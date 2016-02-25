//
//  SettingsViewController.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2015-12-27.
//  Copyright © 2015 CrowdSound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Spotify/Spotify.h>

@interface SettingsViewController : BaseViewController
- (IBAction)loginWithSpotifyPressed:(id)sender;

+ (BOOL) openSpotifyURL:(NSURL *)url;

+ (void) fetchAllSavedTracksWithSession:(SPTSession *)session callback:(void (^)(NSError *, NSArray *))callback;

+ (void)didFetchListPageForSession:(SPTSession *)session finalCallback:(void (^)(NSError*, NSArray*))finalCallback error:(NSError *)error page:(SPTListPage *)page allItems:(NSMutableArray *)allItems;

@property(strong, nonatomic) SPTSession *session;

@end
