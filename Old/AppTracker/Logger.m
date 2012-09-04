/*
 *  Logger.m
 *  AppTracker
 *
 *  Created by Ethan Reesor on 11/14/10.
 *  Copyright 2010 Ethan Reesor. All rights reserved.
 *
 */

#import "Logger.h"
#import <unistd.h>

#pragma mark Auxiliary Functions

#pragma mark -
#pragma mark Main Function

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//	[[NSRunLoop currentRunLoop] run];
	
	BOOL status = 1;
	
	NSDistantObject<AppTrackerCommunication> *proxy;
	
	NSConnection *con = [NSConnection connectionWithRegisteredName:@"server" host:nil];
	
	if (con==nil) {
//		exit(EXIT_FAILURE);
	}
	
	proxy = [[con rootProxy] retain];
	
	if (proxy==nil) {
//		exit(EXIT_FAILURE);
	}
	
	[proxy setProtocolForProxy:@protocol(AppTrackerCommunication)];
	
	while (1) {
		//[proxy status:(&status)];
		sleep(1);
	}
	//NSLog(@"%d", argc);
	
	[proxy release];
    [pool drain];
    return 0;
}
