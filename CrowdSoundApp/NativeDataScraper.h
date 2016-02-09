//
//  NativeDataScraper.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;

@interface NativeDataScraper : NSObject

-(NSArray *)scrapeMusicData:(BOOL)sendFakeData;

@end
