//
//  TMBAppDelegate.h
//  Tumblrbot
//
//  Created by Matthew Bischoff on 12/6/13.
//  Copyright (c) 2013 Matthew Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMBDashboardViewController.h"

@interface TMBAppDelegate : UIResponder <UIApplicationDelegate, NSCoding, NSCopying>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
