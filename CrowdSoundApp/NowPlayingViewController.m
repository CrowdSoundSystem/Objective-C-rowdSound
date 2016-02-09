//
//  CurrentQueueViewController.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "CSServiceInterface.h"
#import "MMMaterialDesignSpinner.h"
#import "NativeDataScraper.h"
#import "NowPlayingCell.h"

@interface NowPlayingViewController ()

@property (strong) CSServiceInterface *csInterface;
@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, self.view.frame.size.height, 40, 40)];
    
    spinnerView.lineWidth = 3.0f;
    spinnerView.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:spinnerView];
    [self.view bringSubviewToFront:spinnerView];
    [spinnerView startAnimating];*/
    
    _csInterface = [CSServiceInterface sharedInstance];
    
    NativeDataScraper *scraper = [[NativeDataScraper alloc]init];
    
    NSArray *songs = [scraper scrapeMusicData:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(getQueuePeriodically) userInfo:nil repeats:YES];
    
    [_csInterface sendSongs:songs]; /* continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            return [self getQueuePeriodically];
        }
        return nil;
    }];*/
    
    
    
    // Do any additional setup after loading the view.
}

- (BFTask *) getQueuePeriodically {
    return [[_csInterface getSongQueue] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            self.sections = @[task.result];
            [self.collectionView reloadData];
        }
        return nil;
    }];
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NowPlayingSongItem *item = self.sections[indexPath.section][indexPath.row];
    
    NowPlayingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];

    cell.textLabel.text = item.song.name;
    cell.likeButton.accessibilityIdentifier = [@"like" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    cell.dislikeButton.accessibilityIdentifier = [@"dislike" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    return cell;
}


@end
