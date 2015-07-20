//
//  ConnectionManager.m
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-20.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager () <NSStreamDelegate>

@property (nonatomic, strong) NSString *serverIP;
@property (nonatomic, strong) NSString *serverPort;

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSInputStream *iStream;
@property (nonatomic, strong) NSOutputStream *oStream;

@end

@implementation ConnectionManager

static ConnectionManager *_sharedInstance = nil;
CFReadStreamRef readStream = NULL;
CFWriteStreamRef writeStream = NULL;

+ (void) initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        _sharedInstance = [[ConnectionManager alloc] init];
    }
}

+ (ConnectionManager *)sharedManager {
    return _sharedInstance;
}

- (void) setServerIP:(NSString *)serverIP {
    _serverIP = serverIP;
}

- (void) setServerPort:(NSString *)serverPort {
    _serverPort = serverPort;
}

- (void) writeToServer:(const uint8_t *) buffer {

    [self.oStream write:buffer maxLength:strlen((char*)buffer)];
}

- (void) sendIDMessage {
    NSString *message = @"iam:nish";
    const uint8_t *str = (uint8_t*) [message cStringUsingEncoding:NSASCIIStringEncoding];
    [self writeToServer:str];
}

- (void) sendMessage:(NSString *)message {
    NSString *formattedMessage  = [NSString stringWithFormat:@"msg:%@", message];
    const uint8_t *str = (uint8_t *) [formattedMessage cStringUsingEncoding:NSASCIIStringEncoding];
    if (str != NULL)
        [self writeToServer:str];
    else
        NSLog(@"THIS WAS NULL: %@", message);
}

- (void) connect {
    [self connectToServerUsingCFStream:self.serverIP portNo:[self.serverPort intValue]];
    [self sendIDMessage];
}

- (void) connectToServerUsingCFStream:(NSString *) urlStr portNo: (uint) portNo {
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (__bridge CFStringRef) urlStr,
                                       portNo,
                                       &readStream,
                                       &writeStream);
    
    if (readStream && writeStream) {
        CFReadStreamSetProperty(readStream,
                                kCFStreamPropertyShouldCloseNativeSocket,
                                kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream,
                                 kCFStreamPropertyShouldCloseNativeSocket,
                                 kCFBooleanTrue);
        
        self.iStream = (__bridge NSInputStream *)readStream;
        [self.iStream setDelegate:self];
        [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
        [self.iStream open];
        
        self.oStream = (__bridge NSOutputStream *)writeStream;
        [self.oStream setDelegate:self];
        [self.oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
        [self.oStream open];
    }
}

//Stream handler for incoming events
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            if (self.data == nil) {
                self.data = [[NSMutableData alloc] init];
            }
            uint8_t buf[1024];
            unsigned long len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            if(len) {
                [self.data appendBytes:(const void *)buf length:len];
                int bytesRead = 0;
                bytesRead += len;
            } else {
                NSLog(@"No data.");
            }
            
            NSString *str = [[NSString alloc] initWithData:self.data
                                                  encoding:NSUTF8StringEncoding];
            
            if (nil != str) {
                NSLog(@"server said: %@", str);
            }
            self.data = nil;
            break;
        }
        case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
        case NSStreamEventErrorOccurred:
			
			NSLog(@"Can not connect to the host!");
			break;
			
		case NSStreamEventEndEncountered:
            
            [self disconnect];
			
			break;
		default:
			NSLog(@"Unknown event");
    }
}


-(void) disconnect {
    [self.iStream close];
    [self.oStream close];
}

- (void) dealloc {
    [self disconnect];
    if (readStream) CFRelease(readStream);
    if (writeStream) CFRelease(writeStream);
}



@end
