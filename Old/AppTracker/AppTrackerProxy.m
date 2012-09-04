//
//  AppTrackerProxy.m
//  AppTracker
//
//  Created by Ethan Reesor on 2/14/11.
//  Copyright 2011 Ethan Reesor. All rights reserved.
//

#import "AppTrackerProxy.h"


@implementation AppTrackerProxy

- (AppTrackerProxy *)initWithDelegate:(NSObject <AppTrackerProxyDelegate> *)del {
	delegate = del;
	return self;
}

- (void)stop {
	
}

- (void)start {
	
}

#pragma mark Protocol Functions

- (void)status:(BOOL *)status {
	exit(EXIT_SUCCESS);
}

- (void)status:(BOOL *)status retain:(BOOL)shouldRetain {
	
}

- (void)event:(id)fsevent {
	[delegate event:fsevent];
}

@end
