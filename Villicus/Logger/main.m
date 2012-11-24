//
//  main.m
//  Logger
//
//  Created by Ethan Reesor on 9/6/12.
//  Copyright (c) 2012 Ethan Reesor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>
#import <unistd.h>
#import <signal.h>
#import <pthread.h>

#import "definitions.h"
#import "types.h"
#import "FIEventClient.h"


#pragma mark Definitions

#define EXIT_NORMAL			0
#define EXIT_SIG			1
#define EXIT_NO_CONNECTION	2


#pragma mark Prototypes

void catch(int signal);


#pragma mark Code

int exitnow = 0, exitcode = EXIT_NORMAL;

int main(int argc, const char * argv[])
{
	signal(SIGHUP, &catch);
	signal(SIGINT, &catch);
	signal(SIGABRT, &catch);
	signal(SIGTERM, &catch);
	
	@autoreleasepool {
		while (!exitnow) {
			NSConnection *con;
			while (!exitnow && !(con = [NSConnection connectionWithRegisteredName:FSEvents_IPC_Port host:nil])) usleep(1000*1000);
			@try {
				NSDistantObject * proxy;
				@try {
					proxy = [con rootProxy];
					[proxy setProtocolForProxy:@protocol(FIEventClient)];
				} @catch (NSException *exception) {
					NSLog(@"Exception: %@", exception);
					exitnow = 1;
				}
				
				int i;
				for (i = 0; !exitnow && !usleep(250*1000); i++) {
					char *str = NULL;
					asprintf(&str, "Hello world %d!", i);
					[proxy event:[NSString stringWithCString:str encoding:NSASCIIStringEncoding]];
				}
			}
			@catch (NSException *exception) {
				NSLog(@"Oops!");
			}
		}
	}
	
    return exitcode;
}

void catch(int signal) {
	if (!exitnow) {
		switch (signal) {
			case SIGHUP:
			case SIGINT:
			case SIGABRT:
			case SIGTERM:
				printf("Terminating\n");
				exitnow = EXIT_SIG;
				break;
		}
	}
}

