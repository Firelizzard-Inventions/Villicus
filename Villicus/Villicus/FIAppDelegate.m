//
//  FIAppDelegate.m
//  Villicus
//
//  Created by Ethan Reesor on 9/6/12.
//  Copyright (c) 2012 Firelizzard Inventions. All rights reserved.
//

#import "FIAppDelegate.h"

#import "definitions.h"

@implementation FIAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:FSEvents_IPC_Notification object:FSEvents_Daemon suspensionBehavior:NSNotificationSuspensionBehaviorHold];
}

- (void)notification:(NSNotification *)theNote
{
	NSLog(@"%@", theNote);
}

@end
