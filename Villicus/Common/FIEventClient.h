//
//  FIEventClient.h
//  Villicus
//
//  Created by Ethan Reesor on 11/24/12.
//  Copyright (c) 2012 Ethan Reesor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FIEventClient <NSObject>

- (oneway void)event:(NSString *)description;

@end
