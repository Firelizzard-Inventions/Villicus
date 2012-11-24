//
//  main.m
//  Daemon
//
//  Created by Ethan Reesor on 9/6/12.
//  Copyright (c) 2012 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "definitions.h"
#import "FIEventClientImpt.h"


#pragma mark Prototypes

void catch(int signal);


#pragma mark Code

int exitnow = 0;
NSTask *logger = nil;

int main(int argc, const char * argv[])
{
	signal(SIGHUP, &catch);
	signal(SIGINT, &catch);
	signal(SIGABRT, &catch);
	signal(SIGTERM, &catch);
	
	@autoreleasepool {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Logger" ofType:nil];
		logger = [[NSTask alloc] init];
		[logger setLaunchPath:path];
		if (!exitnow)
			[logger launch];
		
		if (!exitnow) {
			NSConnection * con = [NSConnection new];
			[con setRootObject:[NSProtocolChecker protocolCheckerWithTarget:[FIEventClientImpt new] protocol:@protocol(FIEventClient)]];
			if (![con registerName:FSEvents_IPC_Port]) {
				NSLog(@"Connection Error");
				exitnow = 1;
			}
		}
		
		while (!exitnow && [[NSRunLoop currentRunLoop] runMode:NSConnectionReplyMode beforeDate:[NSDate distantFuture]]);
	}
	
	if ([logger isRunning])
		[logger terminate];
	[logger release];
	
    return 0;
}

void catch(int signal) {
	if (!exitnow) {
		switch (signal) {
			case SIGHUP:
			case SIGINT:
			case SIGABRT:
			case SIGTERM:
				printf("Terminating\n");
				exitnow = 1;
				break;
		}
	}
}