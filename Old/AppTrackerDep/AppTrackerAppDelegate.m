//
//  AppTrackerAppDelegate.m
//  AppTracker
//
//  Created by Ethan Reesor on 8/10/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import "AppTrackerAppDelegate.h"

@implementation AppTrackerAppDelegate

@synthesize window;
@synthesize output;
@synthesize ctrlbtn;
@synthesize center;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	center = [[AppTrackerNotificationCenter alloc] init];
	logger = [[AppTrackerSudoLogger alloc] initWithAppDelegate:self];

	[output setEditable:NO];
	
	[center addObserver:self selector:@selector(gotData:) name:@"LoggerData" object:logger];
	[center addObserver:self selector:@selector(handleAuthError:) name:@"AuthError" object:logger];
	[center addObserver:self selector:@selector(handleExceptionNotification:) name:@"Exception" object:logger];
}

- (AppTrackerNotificationCenter *)notificationCenter {
	return center;
}

- (IBAction)stopstart:(id)sender {
	if (logger) {
		if ([logger isExecuting]) {
			[logger stop];
			[ctrlbtn setTitle:@"Start"];
		} else {
			[logger start];
			[ctrlbtn setTitle:@"Stop"];
		}
	}
}

- (void)gotData:(NSNotification *)note
{
    NSString    *str;
	
    str = [[note userInfo] objectForKey:@"Data"];
	
    [output appendString:str];
    [output scrollRangeToVisible:NSMakeRange([[output textStorage] length], 0)];
}

- (void)handleAuthError:(NSNotification *)note {
	NSLog(@"AuthError: %@", [[note userInfo] objectForKey:@"Data"]);
}

- (void)handleExceptionNotification:(NSNotification *)note {
	[self handleException:[[note userInfo] objectForKey:@"Data"]];
}

- (void)handleException:(NSException *)exception {
	NSLog(@"Exception: %@", exception);
}

- (void)dealloc {
	[logger cancel];
	[logger release];
	[center release];
	[super dealloc];
}

@end


@implementation NSTextView(AppTrackerAppDelegate)

- (void)appendString:(NSString *)str
{
	
    int len = [ [self textStorage] length];
	
    [self replaceCharactersInRange:NSMakeRange(len,0)
						withString:str];
}

@end
