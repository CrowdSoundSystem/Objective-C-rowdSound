//
//  ConnectionManager.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-12.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

-(void)Connect {
    
    //Sets a timer currently because connection management hasnt been done
    //Sends connection successful message
    
    NSMethodSignature *sig = [ConnectionManager instanceMethodSignatureForSelector:@selector(CallConnectionDelegate:)];
    
    NSInvocation *stopInvocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [stopInvocation setTarget:self];
    [stopInvocation setSelector:@selector(CallConnectionDelegate:)];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 invocation:stopInvocation repeats:NO];

    
    
}

-(void)CallConnectionDelegate:(BOOL)success {
    
    id<ConnectionDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(DidConnect:)]) {
        [strongDelegate DidConnect:YES];
    }

}


-(void)Disconnect {
    
}

@end
