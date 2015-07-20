//
//  NativeDataScraper.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-18.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "NativeDataScraper.h"

@implementation NativeDataScraper

-(id)init {
    if (self = [super init]) {
        self.connManager = [ConnectionManager sharedManager];
    }
    
    return self;
}

-(void)scrapeDataAndSendMessage {
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSArray *itemsFromGenericQuery = [everything items];
    
    NSArray *songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    
    for (int i = 0; i < songsList.count; i++) {
        MPMediaItem *song = [songsList objectAtIndex:i];
        [self constructAndSendMessagewithSongTitle:[song valueForProperty:MPMediaItemPropertyTitle] Artist:[song valueForProperty:MPMediaItemPropertyArtist] Genre:[song valueForProperty:MPMediaItemPropertyGenre]];
        
    }
}

-(void)constructAndSendMessagewithSongTitle:(NSString*)songTitle Artist:(NSString*)artist Genre:(NSString*)genre {
    
    [self.connManager sendMessage:[NSString stringWithFormat:@"%@:%@:%@", songTitle, artist, genre]];
    
    
    
}

@end
