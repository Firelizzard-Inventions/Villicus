//
//  AppTrackerCommunication.h
//  AppTracker
//
//  Created by Ethan Reesor on 2/14/11.
//  Copyright 2011 Ethan Reesor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Common.h"


@protocol AppTrackerCommunication

- (oneway void)status:(out BOOL *)status;
- (oneway void)status:(out BOOL *)status retain:(BOOL)shouldRetain;
- (oneway void)event:(bycopy id)fsevent;

@end
