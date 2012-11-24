//
//  FIEventClientImpt.m
//  Villicus
//
//  Created by Ethan Reesor on 11/24/12.
//  Copyright (c) 2012 Ethan Reesor. All rights reserved.
//

#import "FIEventClientImpt.h"

#import "definitions.h"

@implementation FIEventClientImpt

- (oneway void)event:(NSString *)description
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:FSEvents_IPC_Notification object:FSEvents_Daemon userInfo:@{@"data" : description} deliverImmediately:YES];
}

@end
