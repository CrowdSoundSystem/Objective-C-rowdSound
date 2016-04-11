

#import "NativeDataScraper.h"
#import "Song.h"

@implementation NativeDataScraper

-(NSArray *)scrapeMusicDataWithRealData:(BOOL)useRealData {
    NSLog(@"Scraping");
    
    NSMutableArray* songObjectList = [[NSMutableArray alloc]init];
    
    if (useRealData) {
        NSDate *methodStart = [NSDate date];
        MPMediaQuery *everything = [MPMediaQuery songsQuery];
        
        NSArray *itemsFromGenericQuery = [everything items];
        
        NSArray *songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        NSLog(@"executionTime = %f", executionTime);
        
        for (int i = 0; i < songsList.count; i++) {
            
            MPMediaItem *mediaItem = [songsList objectAtIndex:i];
            
            NSLog(@"%@:%@:%@", [mediaItem valueForProperty:MPMediaItemPropertyTitle], [mediaItem valueForProperty:MPMediaItemPropertyArtist], [mediaItem valueForProperty:MPMediaItemPropertyGenre]);
            
            Song *song = [[Song alloc]init];
            [song setName:[mediaItem valueForProperty:MPMediaItemPropertyTitle]];
            
            if (![mediaItem valueForProperty:MPMediaItemPropertyArtist]) {
                [song setArtists:nil];
            } else {
                [song setArtists:[[NSMutableArray alloc]initWithArray:@[[mediaItem valueForProperty:MPMediaItemPropertyArtist]]]];
            }
            [song setGenre:[mediaItem valueForProperty:MPMediaItemPropertyGenre]];
            
            [songObjectList addObject:song];
        }
    } else {
        Song *song = [[Song alloc]init];
        [song setName:@"Jumpman"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Drake"]]];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"From Time"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Drake"]]];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Started From the Bottom"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Drake"]]];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Take Care"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Drake"]]];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Pour it Up"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Rihanna"]]];
        [song setGenre:@"HipHop"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Unfaithful"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Rihanna"]]];
        [song setGenre:@"Stupid"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"House Party"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Meek Mill"]]];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];

        
        song = [[Song alloc]init];
        [song setName:@"Jesus Walks"];
        [song setArtists:[[NSMutableArray alloc]initWithArray:@[@"Kanye West"]]];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];

    }
    return songObjectList;
}


@end
