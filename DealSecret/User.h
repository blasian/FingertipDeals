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
@class DealCategory;
@interface User : ManagedObject

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (User*)getMe;

+ (void)createUserWithEmail:(NSString*)email
                   password:(NSString*)password
                   firstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                   timezone:(NSTimeZone*)timezone
                   deviceId:(NSString*)deviceId
                      block:(void (^_Nullable)(NSDictionary* response))block;

+ (void)createUserWithEmail:(NSString*)email
                     source:(NSString*)source
                  firstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                   timezone:(NSTimeZone*)timezone
                   deviceId:(NSString*)deviceId
                      block:(void (^_Nullable)(NSDictionary* response))block;

+ (void)loginWithEmail:(NSString*)email
          withPassword:(NSString*)password
                 block:(void (^_Nullable)(NSDictionary* response))block;

+ (void)loginWithEmail:(NSString*)email
            withSource:(NSString*)source
                 block:(void (^_Nullable)(NSDictionary* response))block;

+ (void)forgotPasswordWithEmail:(NSString*)email
                      withBlock:(void (^_Nullable)(NSDictionary* response))block;

+ (void)likeDealWithId:(NSString*)dealId withBool:(BOOL)like block:(void (^)(NSDictionary * response))block;

+ (void)updateUserWithDictionary:(NSDictionary*)params
                           block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)updateUserWithLocation:(NSArray*)locations
                         block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)getDealWithId:(NSString*)dealId
                block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)getDealsWithLatitude:(NSString*)lat
                   longitude:(NSString*)lon
                       block:(void (^_Nullable )(NSDictionary* response))block;

+ (void)getUserDealsWithCategory:(DealCategory*)category
                    withLatitude:(NSString*)lat
                   withLongitude:(NSString*)lon
                       withBlock:(void (^)(NSDictionary* response))block;

+ (void)getTermsWithBlock:(void (^ _Nullable) (NSString* response))block;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
