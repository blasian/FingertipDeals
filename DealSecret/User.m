//
//  User.m
//  DealSecret
//
//  Created by Michael Spearman on 11/21/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "User.h"
#import "Deal.h"
#import "DealCategory.h"
#import "DealSubCategory.h"
#import "DealCategoryManager.h"
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

+ (void)likeDealWithId:(NSString*)dealId withBool:(BOOL)like block:(void (^)(NSDictionary * response))block {
    NSDictionary* params = @{@"dm_no":dealId,
                             @"like":[NSNumber numberWithBool:like]};
    [[NetworkManager sharedInstance] POST:kUserLikeDealEndpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *jsonError;
        NSDictionary* errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:&jsonError];
        if (block) {
            block(errorDict);
        }
    }];
}

+ (void)getDealWithId:(NSString *)dealId block:(void (^)(NSDictionary *))block {
    [[NetworkManager sharedInstance] GET:[NSString stringWithFormat:kUserDealEndpoint, dealId]  parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary* dealDict = [responseObject valueForKey:@"data"][0];
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
        if (block) {
            block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *jsonError;
        NSDictionary* errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:&jsonError];
        if (block) {
            block(errorDict);
        }
    }];
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
                                          block(nil);
                                      }
                                      
                                  }
                                  failure:^(NSURLSessionDataTask* task,
                                            NSError* error) {
                                      NSError *jsonError;
                                      NSDictionary* errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:&jsonError];
                                      if (block) {
                                          block(errorDict);
                                      }
                                  }];
}

+ (void)loginWithEmail:(NSString*)email
          withSource:(NSString*)source
                 block:(void (^_Nullable)(NSDictionary* response))block {
    
    NSDictionary *params = @{@"um_email":email,
                             @"um_source":source};
    
    [[NetworkManager sharedInstance] POST:kUserLoginFromSourceEndpoint
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
                                          block(nil);
                                      }
                                      
                                  }
                                  failure:^(NSURLSessionDataTask* task,
                                            NSError* error) {
                                      NSError *jsonError;
                                      NSDictionary* errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:&jsonError];
                                      if (block) {
                                          block(errorDict);
                                      }
                                  }];
}

+ (void)forgotPasswordWithEmail:(NSString*)email
                      withBlock:(void (^_Nullable)(NSDictionary* response))block {
    NSDictionary* params = @{@"email":email};
    [[NetworkManager sharedInstance] GET:kUserForgotPassword
                               parameters:params
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                      NSLog(@"success");
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      NSLog(@"fail");
                                  }];
}

+ (void)createUserWithEmail:(NSString*)email
                   password:(NSString*)password
                  firstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                   timezone:(NSTimeZone*)timezone
                   deviceId:(NSString*)deviceId
                      block:(void (^_Nullable)(NSDictionary* response))block
{
    if (!deviceId) {
        deviceId = @"";
    }
    NSDictionary* params = @{@"um_email" : email,
                             @"um_upass" : password,
                             @"um_fname" : firstName,
                             @"um_lname" : lastName,
                             @"um_dob"   : @"",
                             @"um_gender": @"",
                             @"um_timezone":timezone,
                             @"um_deviceidios":deviceId};

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
                                      [user save];
                                      if (block) {
                                          block(nil);
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask* task,
                                            NSError* error) {
                                      NSError *jsonError;
                                      NSDictionary* errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:&jsonError];
                                      if (block) {
                                          block(errorDict);
                                      }
                                  }];
}

+ (void)createUserWithEmail:(NSString*)email
                   source:(NSString*)source
                  firstName:(NSString*)firstName
                   lastName:(NSString*)lastName
                   timezone:(NSTimeZone*)timezone
                   deviceId:(NSString*)deviceId
                      block:(void (^_Nullable)(NSDictionary* response))block
{
    NSDictionary* params = @{@"um_email" : email,
                             @"um_source" : source,
                             @"um_fname" : firstName,
                             @"um_lname" : lastName,
                             @"um_dob"   : @"",
                             @"um_gender": @"",
                             @"um_timezone":timezone,
                             @"um_deviceidios":deviceId};
    
    [[NetworkManager sharedInstance] POST:kUserCreateFromSourceEndpoint
                               parameters:params
                                  success:^(NSURLSessionDataTask* task,
                                            id responseObject) {
                                      
                                      NSDictionary* userDict = [responseObject objectForKey:@"data"];
                                      User* user = [[User alloc] initWithAttributes:userDict];
                                      
                                      NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                      [defaults setObject:user.token forKey:kUserAPIToken];
                                      [defaults setBool:YES forKey:kUserPersistenceKey];
                                      [defaults synchronize];
                                      [user save];
                                      if (block) {
                                          block(nil);
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask* task,
                                            NSError* error) {
                                      NSError *jsonError;
                                      NSDictionary* errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:&jsonError];
                                      if (block) {
                                          block(errorDict);
                                      }
                                  }];
}

+ (void)updateUserWithDictionary:(NSDictionary*)params
                           block:(void (^_Nullable )(NSDictionary* response))block {
    [[NetworkManager sharedInstance] POST:kUserUpdateEndpoint
                               parameters:params
                                  success:^(NSURLSessionDataTask * task, id responseObject) {
                                      NSDictionary *userDict = [responseObject objectForKey:@"data"];
                                      NSDictionary *attributes = userDict[@"userm"];
                                      NSLog(@"%@", attributes);
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

+ (void)getDealsWithZip:(NSString*)zip withBlock:(void (^)(NSDictionary* _Nonnull))block {
    NSString *route = [NSString stringWithFormat:kUserDealsZipEndpoint, zip];
    
    [[NetworkManager sharedInstance] GET:route
                              parameters:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     NSDictionary *dealsDict = [responseObject valueForKey:@"data"];
                                     for (NSDictionary *dealDict in dealsDict) {
                                         NSString* dealId = [dealDict valueForKeyPath:@"dm_no"];
                                         NSManagedObjectContext* c = [ManagedObject context];
                                         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                                         NSEntityDescription *entity = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:c];
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



+ (void)getTermsWithBlock:(void (^ _Nullable) (NSString* response))block {
    NSString* route = kTermsEndpoint;
    [[NetworkManager sharedInstance] GET:route parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            NSString* text = [responseObject valueForKey:@"data"];
            block(text);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

+ (void)updateUserWithLocation:(NSArray*)locations
                         block:(void (^_Nullable )(NSDictionary* response))block {
    NSError* error;
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:locations
                                                         options:0
                                                           error:&error];
    NSString* paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    NSDictionary *paramsDict = @{@"locations":paramsString};
    
    [[NetworkManager sharedInstance] POST:kUserUpdateLocationEndpoint parameters:paramsDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(@{});
        }
    }];
}

+ (void)getDealsWithLatitude:(NSString*)lat
                   longitude:(NSString*)lon
                       block:(void (^)(NSDictionary* _Nonnull))block {
    NSString *route = [NSString stringWithFormat:kUserDealsByLocationEndpoint, lat, lon];
    
    [[NetworkManager sharedInstance] GET:route
                              parameters:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     NSDictionary *dealsDict = [responseObject valueForKey:@"data"];
                                     NSMutableArray *deals = [NSMutableArray array];
                                     for (NSDictionary *dealDict in dealsDict) {
                                         Deal* deal = [[Deal alloc] initWithAttributes:dealDict];
                                         [deals addObject:deal];
                                     }
                                     if (block) {
                                         block(@{@"deals":deals});
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     NSLog(@"%@", [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
                                     if (block) {
                                         block(@{@"error":error, @"deals":@[]});
                                     }
                                 }];
}

+ (void)getUserDealsWithCategory:(DealCategory*)category
                    withLatitude:(NSString*)lat
                   withLongitude:(NSString*)lon
                       withBlock:(void (^)(NSDictionary*))block {
    NSString* url = [[NSString stringWithFormat:kUserDealsWithClassEndpoint, category.title, lat, lon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[NetworkManager sharedInstance] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dealsDict = [responseObject valueForKey:@"data"];
        NSMutableArray *deals = [NSMutableArray array];
        for (NSDictionary *dealDict in dealsDict) {
            Deal* deal = [[Deal alloc] initWithAttributes:dealDict];
            [deals addObject:deal];
        }
        if (block) {
            block(@{@"deals":deals});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        if (block) {
            block(@{@"error":error, @"deals":@[]});
        }
    }];
}
@end
