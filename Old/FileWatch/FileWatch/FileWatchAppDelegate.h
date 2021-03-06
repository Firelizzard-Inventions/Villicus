//
//  FileWatchAppDelegate.h
//  FileWatch
//
//  Created by Ethan Reesor on 9/17/11.
//  Copyright 2011 Firelizzard Inventions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileWatchAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSPersistentStoreCoordinator *__persistentStoreCoordinator;
	NSManagedObjectModel *__managedObjectModel;
	NSManagedObjectContext *__managedObjectContext;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
