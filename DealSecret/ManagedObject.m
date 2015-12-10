//
//  ManagedObject.m
//  DealSecret
//
//  Created by Michael Spearman on 11/25/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "ManagedObject.h"

@implementation ManagedObject

+ (NSManagedObjectContext*)context
{
    static NSManagedObjectContext* context = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = [self persistentStoreCoordinator];
    });
    
    return context;
}

+ (NSManagedObjectModel *)managedObjectModel
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DealSecret" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}


+ (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DealSecret.sqlite"];
        NSError* error;
        NSDictionary *storeOptions =
        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:storeOptions
                                                         error:&error];
    });
    return persistentStoreCoordinator;
}

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

+ (NSEntityDescription *)entityWithContext:(NSManagedObjectContext *)managedObjectContext
{
    if (!managedObjectContext) {
        managedObjectContext = [self context];
    }
    
    return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:managedObjectContext];
}


- (id)init
{
    return [self initWithContext:nil];
}


- (id)initWithContext:(NSManagedObjectContext*)managedObjectContext
{
    if (!managedObjectContext) {
        managedObjectContext = [[self class] context];
    }
    
    NSEntityDescription *entity = [[self class] entityWithContext:managedObjectContext];
    
    return (self = [self initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext]);
}

- (void)save
{
    NSError *error;
    [[ManagedObject context] save:&error];
    if (error) {
        NSLog(@"Saving failed: %@", error);
    }
}

- (void)delete
{
    [[ManagedObject context] deleteObject:self];
    [self save];
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
