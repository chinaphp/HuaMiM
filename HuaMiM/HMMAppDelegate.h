//
//  HMMAppDelegate.h
//  HuaMiM
//
//  Created by Morris on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
@class HMMWindow;

#import <Cocoa/Cocoa.h>

@interface HMMAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet HMMWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction) saveAction:(id)sender;
-(IBAction) showMainWindow:(id)sender;
-(IBAction) showAboutWindow:(id)sender;

@end
