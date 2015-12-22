//
//  User.h
//  DealSecret
//
//  Created by Michael Spearman on 11/21/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : ManagedObject

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (User*)getMe;

+ (void)createUserWithEmail:(NSString*)email
                   password:(NSString*)password
                   firstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                        dob:(NSDate*)dob
                     gender:(NSNumber*)gender
                      block:(void (^_Nullable)(NSDictionary* response))block;


+ (void)loginWithEmail:(NSString*)email
          withPassword:(NSString*)password
                 block:(void (^_Nullable)(NSDictionary* response))block;

+ (void)updateUserWithDictionary:(NSDictionary*)params
                           block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)updateUserWithLocation:(NSArray*)locations
                         block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)getDealsWithLatitude:(NSString*)lat longitude:(NSString*)lon
                         block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)getCategoriesWithLevel:(NSNumber*)lnum
                     withClass:(NSString* _Nullable)cnum
                     withBlock:(void (^)(NSDictionary*))block;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
