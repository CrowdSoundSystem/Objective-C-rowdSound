//
//  ConnectionManager.h
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-20.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject

+ (ConnectionManager *) sharedManager;

- (void) setServerIP:(NSString *)serverIP;
- (void) setServerPort:(NSString *)serverPort;
- (void) sendMessage:(NSString *)message;
- (void) disconnect;
- (void) connect;

@end
