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
        //self.connManager = [ConnectionManager sharedManager];
    }
    
    return self;
}

-(void)scrapeDataAndSendMessage {
    NSLog(@"Scraping");
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSArray *itemsFromGenericQuery = [everything items];
    
    NSArray *songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    
    //Mutable string appends all the data to be sent in one giant string
    
    NSMutableString* allMediaItems = [[NSMutableString alloc]init];
    [allMediaItems setString:@""];
    
    for (int i = 0; i < songsList.count; i++) {
        
        MPMediaItem *song = [songsList objectAtIndex:i];
        
        //Appending song title, artist, and genre for each media item to one giant string
        /*
        [allMediaItems appendString:[NSString stringWithFormat:@";%@,%@,%@;",[song valueForProperty:MPMediaItemPropertyTitle], [song valueForProperty:MPMediaItemPropertyArtist], [song valueForProperty:MPMediaItemPropertyGenre]]];*/
        
        // Sending song title, artist, and genre for each media item
        [self constructAndSendMessagewithSongTitle:[song valueForProperty:MPMediaItemPropertyTitle] Artist:[song valueForProperty:MPMediaItemPropertyArtist] Genre:[song valueForProperty:MPMediaItemPropertyGenre]];
    }
    
    //Sending One giant string instead of sets of strings
    /*
    NSString *message = [NSString stringWithString:allMediaItems];
    [self SendMessage:message];*/
    
}

- (void)SendMessage: (NSString *) message {
    [[ConnectionManager sharedManager] sendMessage:message];
}

-(void)constructAndSendMessagewithSongTitle:(NSString*)songTitle Artist:(NSString*)artist Genre:(NSString*)genre {
    
    [self SendMessage:[NSString stringWithFormat:@"%@;%@;%@", songTitle, artist, genre]];
    
    
    
}

@end
