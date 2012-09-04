//
//  AppTrackerProxy.h
//  AppTracker
//
//  Created by Ethan Reesor on 2/14/11.
//  Copyright 2011 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Common.h"
#import "AppTrackerCommunication.h"
#import "AppTrackerProxyDelegate.h"


@interface AppTrackerProxy : NSDistantObject <AppTrackerCommunication> {
	NSObject <AppTrackerProxyDelegate>	*delegate;
	
	BOOL		logging;
	BOOL		*shouldLog;
}

- (AppTrackerProxy *)initWithDelegate:(NSObject <AppTrackerProxyDelegate> *)del;
- (void)stop;
- (void)start;

- (void)status:(BOOL *)status;
- (void)status:(BOOL *)status retain:(BOOL)shouldRetain;
- (void)event:(id)fsevent;

@end
