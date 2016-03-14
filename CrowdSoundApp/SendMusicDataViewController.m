
#import "SendMusicDataViewController.h"
#import "NativeDataScraper.h"
#import "SpotifyDataScraper.h"
#import "CSServiceInterface.h"
#import "TWMessageBarManager.h"

@interface SendMusicDataViewController ()
@property BOOL spotifyDataSent;
@property BOOL phoneDataSent;

@end

@implementation SendMusicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrapeAndSendSpotifyData) name:@"AuthenticatedSpotify" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonHandler:(id)sender {
    [self performSegueWithIdentifier:@"dataNextSegue" sender:self];
}

- (IBAction)sendButtonHandler:(id)sender {
    if (_musicAppSwitch.on & !_phoneDataSent) {
        [self scrapeAndSendNativeMusicData];
    }
    if (_spotifyAppSwitch.on && !_spotifyDataSent) {
        [self authenticateWithSpotify];
    }
}

- (void) authenticateWithSpotify {
    SpotifyDataScraper *scraper = [[SpotifyDataScraper alloc]init];
    [scraper authenticateSpotify];
}

- (void) scrapeAndSendSpotifyData {
    SpotifyDataScraper *scraper = [[SpotifyDataScraper alloc]init];
    [[[scraper scrapeAllSpotifyFavourites] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            return [[CSServiceInterface sharedInstance] sendSongs:task.result];
        }
        return task;
    }] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Error sending spotify music data" type:TWMessageBarMessageTypeError];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Sent spotify music data" type:TWMessageBarMessageTypeSuccess];
                self.spotifyDataSent = true;
            });
        }
        return nil;
    }];
}

- (void) scrapeAndSendNativeMusicData {
    NativeDataScraper *scraper = [[NativeDataScraper alloc]init];
    NSArray *songs = [scraper scrapeMusicDataWithRealData:YES];
    
    [[[CSServiceInterface sharedInstance] sendSongs:songs] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Error sending phone music data" type:TWMessageBarMessageTypeError];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Sent phone music data" type:TWMessageBarMessageTypeSuccess];
                self.phoneDataSent = true;
            });
        }
        return nil;
    }];
}


@end
