//
//  AppTrackerNotificationCenter.m
//  AppTracker
//
//  Created by Ethan Reesor on 10/17/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import "AppTrackerNotificationCenter.h"


@implementation AppTrackerNotificationCenter

- (id)init {
	self = [super init];
	if (self) {
		threads = [[NSMutableArray alloc] init];
		lock = [[NSLock alloc] init];
	}
	return self;
}

- (void)dealloc {
	[threads release];
	[lock release];
	[super dealloc];
}

- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)sender {
	[lock lock];
	if (![threads containsObject:[NSThread currentThread]]) {
		
		[threads addObject:[NSThread currentThread]];
	}
	[super addObserver:observer selector:selector name:name object:sender];
	[lock unlock];
}

- (void)_postNotificationFromDictionary:(NSDictionary *)note {
	[super postNotificationName:[note objectForKey:@"name"] object:[note objectForKey:@"object"] userInfo:[note objectForKey:@"userInfo"]];
}

- (void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
	[lock lock];
	NSDictionary *note;
	for (NSThread *thread in threads) {
		note = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", object, @"object", userInfo, @"userInfo", nil];
		[self performSelector:@selector(_postNotificationFromDictionary:) onThread:thread withObject:note waitUntilDone:NO];
	}
	[lock unlock];
}

- (void)postAppTrackerNotificationName:(NSString *)name sender:(id)sender data:(id)data {
	NSDictionary *info = [NSDictionary dictionaryWithObject:data forKey:@"Data"];
	[self postNotificationName:name object:sender userInfo:info];
}

@end
