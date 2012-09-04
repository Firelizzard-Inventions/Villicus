//
//  AppTrackerSudoLogger.h
//  AppTracker
//
//  Created by Ethan Reesor on 10/19/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Security/Security.h>

#import "AppTrackerNotificationCenter.h"


#define MAX_PATH_LENGTH 1024
#define BUFFER_LENGTH 1024

#define AUTH_ENV_ITEM_COUNT 1
#define AUTH_RIGHTS_ITEM_COUNT 1

#define AUTH_CREATE_FLAGS (kAuthorizationFlagDefaults)
#define AUTH_COPY_FLAGS (kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights)
#define AUTH_EXECUTE_FLAGS (kAuthorizationFlagDefaults)

#define COMMAND "/bin/sh"

#define PLIST_PREFIX @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n"
#define PLIST_SUFFIX @"</plist>\n"

@class AppTrackerAppDelegate;

@interface AppTrackerSudoLogger : NSOperation {
	AppTrackerAppDelegate			*parent;
	AppTrackerNotificationCenter	*center;
	
	BOOL	executing;
	BOOL	finished;
	
	FILE				*pipe;
	AuthorizationRef	auth;
}

- (id)initWithAppDelegate:(AppTrackerAppDelegate *)delegate;

- (void)start;
- (void)main;
- (void)stop;
- (void)finish;

- (BOOL)status:(OSStatus)err;
- (OSStatus)create;
- (OSStatus)destroy;
- (OSStatus)check;
- (OSStatus)execute:(FILE **)pipe;

@end
