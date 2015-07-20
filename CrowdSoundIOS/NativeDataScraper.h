//
//  NativeDataScraper.h
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-18.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"
@import MediaPlayer;

@interface NativeDataScraper : NSObject

@property (strong) ConnectionManager* connManager;

-(void)scrapeDataAndSendMessage;

@end
