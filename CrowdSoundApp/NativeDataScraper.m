

#import "NativeDataScraper.h"
#import "Song.h"

@implementation NativeDataScraper

-(NSArray *)scrapeMusicDataWithRealData:(BOOL)useRealData {
    NSLog(@"Scraping");
    
    NSMutableArray* songObjectList = [[NSMutableArray alloc]init];
    
    if (useRealData) {
        NSDate *methodStart = [NSDate date];
        MPMediaQuery *everything = [[MPMediaQuery alloc] init];
        
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
            [song setArtist:[mediaItem valueForProperty:MPMediaItemPropertyArtist]];
            [song setGenre:[mediaItem valueForProperty:MPMediaItemPropertyGenre]];
            
            [songObjectList addObject:song];
        }
    } else {
        Song *song = [[Song alloc]init];
        [song setName:@"Jumpman"];
        [song setArtist:@"Drake"];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"From Time"];
        [song setArtist:@"Drake"];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Started From the Bottom"];
        [song setArtist:@"Drake"];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Take Care"];
        [song setArtist:@"Drake"];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Pour it Up"];
        [song setArtist:@"Rihanna"];
        [song setGenre:@"HipHop"];
        
        [songObjectList addObject:song];
        
        song = [[Song alloc]init];
        [song setName:@"Unfaithful"];
        [song setArtist:@"Rihanna"];
        [song setGenre:@"Stupid"];
        
        [songObjectList addObject:song];

        
        song = [[Song alloc]init];
        [song setName:@"House Party"];
        [song setArtist:@"Meek Mill"];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];

        
        song = [[Song alloc]init];
        [song setName:@"Jesus Walks"];
        [song setArtist:@"Kanye West"];
        [song setGenre:@"Rap"];
        
        [songObjectList addObject:song];

    }
    return songObjectList;
}


@end
