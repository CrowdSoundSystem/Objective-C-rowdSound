//
//  ConnectionManager.h
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-20.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionDelegate <NSObject>

- (void) messageReceived:(NSString*)message;

@end

@interface ConnectionManager : NSObject

@property (nonatomic, weak) id <ConnectionDelegate> delegate;

+ (ConnectionManager *) sharedManager;

- (void) setServerIP:(NSString *)serverIP;
- (void) setServerPort:(NSString *)serverPort;
- (void) sendMessage:(NSString *)message;
- (void) disconnect;
- (void) connect;

@end

