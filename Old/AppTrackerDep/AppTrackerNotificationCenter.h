//
//  AppTrackerNotificationCenter.h
//  AppTracker
//
//  Created by Ethan Reesor on 10/17/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppTrackerNotificationCenter : NSNotificationCenter {
	NSMutableArray	*threads;
	NSLock			*lock;
}

- (void)postAppTrackerNotificationName:(NSString *)name sender:(id)sender data:(id)data;

@end
