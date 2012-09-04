//
//  AppTrackerAppDelegate.h
//  AppTracker
//
//  Created by Ethan Reesor on 11/14/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Common.h"
#import "AppTrackerProxyDelegate.h"
#import "AppTrackerProxy.h"


@interface AppTrackerAppDelegate : NSObject <NSApplicationDelegate, AppTrackerProxyDelegate> {
	AppTrackerProxy	*proxy;
    NSWindow		*window;
}

@property (assign) IBOutlet NSWindow *window;

- (void)vend;
- (void)event:(id)fsevent;

- (IBAction)omg:(id)sender;

@end
