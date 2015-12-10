//
//  User.m
//  DealSecret
//
//  Created by Michael Spearman on 11/21/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "User.h"
#import "Deal.h"
#import "NetworkManager.h"
#import "Constants.h"

@implementation User

// Insert code here to add functionality to your managed object subclass
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.token     = [attributes valueForKeyPath:@"um_token"];
    self.userId    = [attributes valueForKeyPath:@"um_id"];
    self.email     = [attributes valueForKeyPath:@"um_email"];
    self.password  = [attributes valueForKeyPath:@"um_upass"];
    //    self.firstName = [attributes valueForKeyPath:@"um_fname"];
    //    self.lastName  = [attributes valueForKeyPath:@"um_lname"];
    //    self.gender    = [attributes valueForKeyPath:@"um_gender"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdate = [formatter dateFromString:[attributes valueForKeyPath:@"user_dob"]];
    
    return self;
}

+ (User*)getMe {
    User* user = nil;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:kUserAPIToken];
    NSError* error;
    
    NSManagedObjectContext* c = [ManagedObject context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:c];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"token == %@",
                                token]];
    [fetchRequest setEntity:entity];
    
    if ([c countForFetchRequest:fetchRequest
                          error:&error] != 0) {
        NSArray *fetchedObjects = [c executeFetchRequest:fetchRequest error:&error];
        user = [fetchedObjects firstObject];
        return user;
    }
    else {
        return nil;
    }
}

+ (void)loginWithEmail:(NSString*)email
          withPassword:(NSString*)password
                 block:(void (^_Nullable)(NSDictionary* response))block {
    
    NSDictionary *params = @{@"um_email":email,
                             @"um_upass":password};
    
    [[NetworkManager sharedInstance] POST:kUserLoginEndpoint
                               parameters:params
                                  success:^(NSURLSessionDataTask* task,
                                            id responseObject) {
                                      
                                      NSDictionary* userDict = [responseObject objectForKey:@"data"];
                                      User *user = [[User alloc] initWithAttributes:userDict[@"userm"]];
                                      [user save];
                                      
                                      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                      [defaults setObject:user.token forKey:kUserAPIToken];
                                      [defaults setBool:YES forKey:kUserPersistenceKey];
                                      [defaults synchronize];
                                      
                                      if (block) {
                                          NSDictionary* dict = @{};
                                          block(dict);
                                      }
                                      
                                  }
                                  failure:^(NSURLSessionDataTask* task,
                                            NSError* error) {
                                      NSLog(@"%@", [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
                                      if (block) {
                                          block([NSDictionary dictionaryWithObject:error forKey:@"error"]);
                                      }
                                  }];
}

+ (void)createUserWithEmail:(NSString*)email
                   password:(NSString*)password
                  firstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                        dob:(NSDate*)dob
                     gender:(NSNumber*)gender
                      block:(void (^_Nullable)(NSDictionary* response))block
{
    NSDictionary* params = @{@"um_email" : email,
                             @"um_upass" : password,
                             @"um_fname" : firstName,
                             @"um_lname" : lastName,
                             @"um_dob"   : dob,
                             @"um_gender": gender};

    [[NetworkManager sharedInstance] POST:kUserEndpoint
                               parameters:params
                                  success:^(NSURLSessionDataTask* task,
                                            id responseObject) {
                                      
                                      NSDictionary* userDict = [responseObject objectForKey:@"data"];
                                      User* user = [[User alloc] initWithAttributes:userDict];
                                      
                                      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                      [defaults setObject:user.token forKey:kUserAPIToken];
                                      [defaults setBool:YES forKey:kUserPersistenceKey];
                                      [defaults synchronize];
                                      if (block) {
                                          NSDictionary* dict = @{};
                                          block(dict);
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask* task,
                                            NSError* error) {
                                      NSLog(@"%@", [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
                                      if (block) {
                                          block([NSDictionary dictionaryWithObject:error forKey:@"error"]);
                                      }
                                  }];
}

+ (void)updateUserWithDictionary:(NSDictionary*)params
                           block:(void (^_Nullable )(NSDictionary* response))block {
    [[NetworkManager sharedInstance] POST:kUserUpdateEndpoint
                               parameters:params
                                  success:^(NSURLSessionDataTask * task, id responseObject) {
                                      User *user = [self getMe];
                                      NSDictionary *userDict = [responseObject objectForKey:@"data"];
                                      NSDictionary *attributes = userDict[@"userm"];
                                      
                                      user.email     = [attributes valueForKeyPath:@"um_email"];
                                      user.password  = [attributes valueForKeyPath:@"um_upass"];
                                      user.firstName = [attributes valueForKeyPath:@"um_fname"];
                                      user.lastName  = [attributes valueForKeyPath:@"um_lname"];
                                      user.gender    = [attributes valueForKeyPath:@"um_gender"];
                                      NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                      [formatter setDateFormat:@"yyyy-MM-dd"];
                                      user.birthdate = [formatter dateFromString:[attributes valueForKeyPath:@"user_dob"]];
                                      [user save];
                                      
                                      if (block) {
                                          block([NSDictionary dictionary]);
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task,
                                            NSError * _Nonnull error) {
                                      NSLog(@"%@", [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
                                      if (block) {
                                          block([NSDictionary dictionaryWithObject:error forKey:@"error"]);
                                      }
                                  }];
}

+ (void)getDealsWithLatitude:(NSString*)lat
                   longitude:(NSString*)lon
                       block:(void (^)(NSDictionary* _Nonnull))block {
    NSString *route = [NSString stringWithFormat:kUserDealsEndpoint, lat, lon];
    
    [[NetworkManager sharedInstance] GET:route
                              parameters:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     NSDictionary *dealsDict = [responseObject valueForKey:@"data"];
                                     for (NSDictionary *dealDict in dealsDict) {
                                         NSString* dealId = [dealDict valueForKeyPath:@"dm_no"];
                                         NSManagedObjectContext* c = [ManagedObject context];
                                         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                                         NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deal"
                                                                                   inManagedObjectContext:c];
                                         [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dealId == %@",
                                                                     dealId]];
                                         [fetchRequest setEntity:entity];
                                         NSError* error;
                                         Deal* deal = nil;
                                         if ([c countForFetchRequest:fetchRequest
                                                               error:&error] != 0) {
                                             NSArray *fetchedObjects = [c executeFetchRequest:fetchRequest error:&error];
                                             deal = [fetchedObjects firstObject];
                                         }
                                         else {
                                             deal = [[Deal alloc] initWithAttributes:dealDict];
                                         }
                                         [deal save];
                                     }
                                     if (block) {
                                         block([NSDictionary dictionary]);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     NSLog(@"%@", [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
                                     if (block) {
                                         block([NSDictionary dictionaryWithObject:error forKey:@"error"]);
                                     }
                                 }];
}

+ (void)updateUserWithLocation:(NSArray*)locations
                         block:(void (^_Nullable )(NSDictionary* response))block {
    // fig'ur some shit out to handle this.
}



@end
