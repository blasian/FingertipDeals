//
//  ManagedObject.h
//  DealSecret
//
//  Created by Michael Spearman on 11/25/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ManagedObject : NSManagedObject

+ (NSManagedObjectContext*)context;
+ (NSPersistentStoreCoordinator*)persistentStoreCoordinator;
+ (NSString *)entityName;

- (id)init;
- (void)save;
- (void)delete;

@end
