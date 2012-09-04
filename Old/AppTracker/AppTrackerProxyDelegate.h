//
//  AppTrackerProxyDelegate.h
//  AppTracker
//
//  Created by Ethan Reesor on 2/14/11.
//  Copyright 2011 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Common.h"


@protocol AppTrackerProxyDelegate

- (void)event:(id)fsevent;

@end
