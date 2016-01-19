//
//  CurrentQueueViewController.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "CSServiceInterface.h"

@interface NowPlayingViewController ()

@property (strong) CSServiceInterface *csInterface;
@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _csInterface = [CSServiceInterface sharedInstance];
    
    [[_csInterface getSongQueue] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        self.sections = @[task.result];
        [self.collectionView reloadData];
        return nil;
    }];

    // Do any additional setup after loading the view.
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NowPlayingSongItem *song = self.sections[indexPath.section][indexPath.row];
    
    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];
    cell.textLabel.text = song.name;
    
    return cell;
}


@end
