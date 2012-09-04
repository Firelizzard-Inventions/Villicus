//
//  AppTrackerAppDelegate.h
//  AppTracker
//
//  Created by Ethan Reesor on 8/10/10.
//  Copyright 2010 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppTrackerSudoLogger.h"
#import "AppTrackerNotificationCenter.h"


@interface AppTrackerAppDelegate : NSObject <NSApplicationDelegate> {
	NSButton						*ctrlbtn;
    NSWindow						*window;
    NSTextView						*output;
	AppTrackerSudoLogger			*logger;
	AppTrackerNotificationCenter	*center;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *output;
@property (assign) IBOutlet NSButton *ctrlbtn;
@property (readonly, getter=notificationCenter) AppTrackerNotificationCenter *center;

- (AppTrackerNotificationCenter *)notificationCenter;
- (void)handleException:(NSException *)exception;

- (IBAction)stopstart:(id)sender;

@end

@interface NSTextView(AppTrackerAppDelegate)
- (void)appendString:(NSString *)str;
@end
