//
//  AppTrackerSudoLogger.m
//  AppTracker
//
//  Created by Ethan Reesor on 10/19/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import "AppTrackerSudoLogger.h"


@implementation AppTrackerSudoLogger

#pragma mark -
#pragma mark End Point Methods

- (id)init {
	return nil;
}

- (id)initWithAppDelegate:(AppTrackerAppDelegate *)delegate {
	self = [super init];
	
	if (self) {
		executing = NO;
		finished = NO;
		parent = [delegate retain];
		center = [[parent notificationCenter] retain];
		
		[self status:[self create]];
	}
	
	return self;
}

- (void)dealloc {
	fclose(pipe);
	[self status:[self destroy]];
	
	[center release];
	[parent release];
	[super dealloc];
}

#pragma mark -
#pragma mark KVO Methods

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isExecuting {
	return executing;
}

- (BOOL)isFinished {
	return finished;
}

#pragma mark -
#pragma mark Control Methods

- (void)start {
	if (![self isFinished]) {
		if ([self isCancelled]) {
			[self finish];
		} else {
			[self willChangeValueForKey:@"isExecuting"];
			executing = YES;
			[self didChangeValueForKey:@"isExecuting"];
			[NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
		}
	}
}

- (void)main {
	NSAutoreleasePool *pool;
	@try {
		pool = [[NSAutoreleasePool alloc] init];
		BOOL authorized = NO;
		
		if (![self isCancelled] && [self isExecuting]) {
			authorized = [self status:[self check]];
		}
		
		if (authorized && ![self isCancelled] && [self isExecuting]) {
			char *buffer = calloc(BUFFER_LENGTH, sizeof(char));
			int b_read = 0;
			
			if (!pipe) authorized = [self status:[self execute:&pipe]];
			
			while (authorized && ![self isCancelled] && [self isExecuting]) {
				b_read = read(fileno(pipe), buffer, BUFFER_LENGTH * sizeof(char));
				if (b_read > 0) [center postAppTrackerNotificationName:@"LoggerData" sender:self data:[[[NSString alloc] initWithBytes:buffer length:b_read encoding:NSUTF8StringEncoding] autorelease]];
			}
			
			free(buffer);
		}
	} @catch (NSException * e) {
		[center postAppTrackerNotificationName:@"Exception" sender:self data:e];
	} @finally {
		if ([self isCancelled]) {
			[self finish];
		}
		[pool drain];
	}
}

- (void)stop {
	[self willChangeValueForKey:@"isExecuting"];
	executing = NO;
	[self didChangeValueForKey:@"isExecuting"];
}

- (void)finish {
	if ([self isExecuting]) {
		[self stop];
	}
	[self willChangeValueForKey:@"isFinished"];
	finished = YES;
	[self didChangeValueForKey:@"isFinished"];
}

#pragma mark -
#pragma mark Authentication Methods

- (BOOL)status:(OSStatus)err {
	BOOL success = (err == errAuthorizationSuccess);
	if (!success) {
		[self cancel];
		[center postAppTrackerNotificationName:@"AuthError" sender:self data:[NSNumber numberWithInt:(int)err]];
	}
	return success;
}

- (OSStatus)create {
	AuthorizationRights rights;
	rights.count = 0;
	rights.items = NULL;
	OSStatus s = ntohl(AuthorizationCreate(&rights, kAuthorizationEmptyEnvironment, AUTH_CREATE_FLAGS, &auth));
	return s;
}

- (OSStatus)destroy {
	OSStatus s = ntohl(AuthorizationFree(auth, kAuthorizationFlagDestroyRights));
	auth = NULL;
	return s;
}

- (OSStatus)check {
	AuthorizationRights rights;
	rights.count = 1;
	rights.items = calloc(1, sizeof(AuthorizationItem));
	rights.items[0] = (AuthorizationItem) {
		kAuthorizationRightExecute,
		strlen(COMMAND),
		COMMAND,
		0
	};
	OSStatus s = ntohl(AuthorizationCopyRights(auth, &rights, kAuthorizationEmptyEnvironment, AUTH_COPY_FLAGS, NULL));
	free(rights.items);
	return s;
}

- (OSStatus)execute:(FILE **)pipe {
	char **args = calloc(3, sizeof(char *));
	args[0] = "-c";
	args[1] = (char *)[[[NSBundle mainBundle] pathForResource:@"Logger" ofType:@""] fileSystemRepresentation];
	args[2] = NULL;
	OSStatus s = ntohl(AuthorizationExecuteWithPrivileges(auth, COMMAND, AUTH_EXECUTE_FLAGS, args, pipe));
	free(args);
	return s;
}

@end
