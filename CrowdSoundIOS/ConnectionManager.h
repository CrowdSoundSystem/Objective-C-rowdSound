//
//  ConnectionManager.h
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-12.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionDelegate;

@interface ConnectionManager : NSObject <NSStreamDelegate>

@property (nonatomic, weak) id<ConnectionDelegate> delegate;

+(id)sharedManager;

-(void)Connect;
-(void)Disconnect;

-(void)CallConnectionDelegate:(BOOL)success;

-(void)sendMessage:(NSString*)message;


@end

@protocol ConnectionDelegate <NSObject>

-(void)DidConnect:(BOOL)connectionSuccess;

@end