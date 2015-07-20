//
//  ConnectionManager.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-12.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager() {
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@end

@implementation ConnectionManager
   
+ (id)sharedManager {
    static ConnectionManager *sharedConnManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnManager = [[self alloc] init];
    });
    return sharedConnManager;
}


-(void)Connect {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.0.21", 80, &readStream, &writeStream);
    inputStream = objc_unretainedObject(readStream);
    outputStream = objc_unretainedObject(writeStream);
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
    [self nameSelf];
    
    
    
    
    /*
    //Sets a timer currently because connection management hasnt been done
    //Sends connection successful message
    
    NSMethodSignature *sig = [ConnectionManager instanceMethodSignatureForSelector:@selector(CallConnectionDelegate:)];
    
    NSInvocation *stopInvocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [stopInvocation setTarget:self];
    [stopInvocation setSelector:@selector(CallConnectionDelegate:)];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 invocation:stopInvocation repeats:NO];*/

    
    
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            [self CallConnectionDelegate:true];
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}

-(void)nameSelf {
    NSString *response  = [NSString stringWithFormat:@"iam:%@", @"nish"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

- (void)sendMessage:(NSString*)message {
    NSString *response  = [NSString stringWithFormat:@"msg:%@", message];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
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
