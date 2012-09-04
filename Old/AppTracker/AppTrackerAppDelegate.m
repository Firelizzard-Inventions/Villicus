//
//  AppTrackerAppDelegate.m
//  AppTracker
//
//  Created by Ethan Reesor on 11/14/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import "AppTrackerAppDelegate.h"

@implementation AppTrackerAppDelegate

@synthesize window;

#pragma mark Initialization Functions

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	printf("%08p\n", (void *)stdout);
	//NSLog(@"%p", self);
	
	[self vend];
}

- (void)vend {
	proxy = [[AppTrackerProxy alloc] initWithDelegate:self];
	NSConnection *con = [NSConnection serviceConnectionWithName:@"server" rootObject:proxy];
	
	if (con == nil) {
		NSLog(@"FAIL");
		exit(EXIT_FAILURE);
	}
}

- (void)event:(id)fsevent {
	
}

- (IBAction)omg:(id)sender {
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"Logger" ofType:@""]];
	[task launch];
}


@end
