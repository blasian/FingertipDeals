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

+ (void)getCategoriesWithLevel:(NSNumber*)lnum
                     withClass:(NSString* _Nullable)cnum
                     withBlock:(void (^)(NSDictionary*))block {
    [[NetworkManager sharedInstance] GET:[NSString stringWithFormat:kUserCategoriesEndpoint, lnum, cnum] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray *catDicts = responseObject[@"data"];
        for (NSDictionary* section in catDicts) {
            if (lnum.intValue == 1) {
                NSString *categoryTitle = section[@"c1_type"];
                
                NSManagedObjectContext* c = [ManagedObject context];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory"
                                                          inManagedObjectContext:c];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", categoryTitle]];
                [fetchRequest setEntity:entity];
                NSError* error;
                DealCategory* category = nil;
                if ([c countForFetchRequest:fetchRequest
                                      error:&error] == 0) {
                    category = [[DealCategory alloc] initWithTitle:categoryTitle];
                    [category save];
                }
            }
            if (lnum.intValue == 2) {
                
                NSManagedObjectContext* c = [ManagedObject context];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory"
                                                          inManagedObjectContext:c];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", cnum]];
                [fetchRequest setEntity:entity];
                NSError *error;
                if ([c countForFetchRequest:fetchRequest
                                      error:&error] == 1) {
                    DealCategory *category = [[[DealCategory context] executeFetchRequest:fetchRequest error:&error] firstObject];
                    NSString *subCategoryTitle = section[@"c2_type"];
                    entity = [NSEntityDescription entityForName:@"DealSubCategory"
                                         inManagedObjectContext:c];
                    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@ AND belongsTo.title LIKE %@",
                                                subCategoryTitle, category.title]];
                    [fetchRequest setEntity:entity];
                    
                    NSError* error;
                    if ([c countForFetchRequest:fetchRequest
                                          error:&error] == 0) {
                        DealSubCategory* subCategory = [[DealSubCategory alloc] initWithTitle:subCategoryTitle];
                        subCategory.belongsTo = category;
                        [subCategory save];
                    }
                }
            }
        }
        if (block) {
            block(@{});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to retrieve sections");
        if (block) {
            block(@{@"error":error});
        }
    }];
}

+ (void)getUserClassesWithBlock:(void (^)(NSDictionary*))block {
    [[NetworkManager sharedInstance] GET:kUserClassesEndpoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary* dict = responseObject[@"data"];
        for (NSDictionary* section in dict[@"user_class"]) {
            NSString *categoryTitle = section[@"c1_type"];
            NSString *subCategoryTitle = section[@"c2_type"];
            
            // check if c1_type exists
            // if no: create category with c1_type
            // check if c2_type exists with c1_type as belongsTo
            // if no: create subcategory with c2_type
            //        add category as belongsTo for subcategory
            
            NSManagedObjectContext* c = [ManagedObject context];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealCategory"
                                                      inManagedObjectContext:c];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", categoryTitle]];
            [fetchRequest setEntity:entity];
            NSError* error;
            DealCategory* category = nil;
            if ([c countForFetchRequest:fetchRequest
                                  error:&error] == 0) {
                DealCategory* category = [[DealCategory alloc] initWithTitle:categoryTitle];
                [category save];
            } else {
                category = [[c executeFetchRequest:fetchRequest error:&error] firstObject];
            }
            entity = [NSEntityDescription entityForName:@"DealSubCategory" inManagedObjectContext:c];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@ and belongsTo.title LIKE %@", subCategoryTitle, categoryTitle]];
            [fetchRequest setEntity:entity];
            DealSubCategory* subCategory = nil;
            if ([c countForFetchRequest:fetchRequest
                                  error:&error] == 0) {
                subCategory = [[DealSubCategory alloc] initWithTitle:subCategoryTitle];
                subCategory.belongsTo = category;
            }
            subCategory.preferred = @YES;
            [subCategory save];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to retrieve user classes");
        if (block) {
            block(@{@"error":error});
        }
    }];
}

+ (void)getUserDealsWithCategory:(DealCategory*)category
                    withLatitude:(NSString*)lat
                   withLongitude:(NSString*)lon
                       withBlock:(void (^)(NSDictionary*))block {
    [[NetworkManager sharedInstance] GET:[NSString stringWithFormat:kUserDealsWithClassEndpoint, category.title, lat, lon] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (void)setUserClassesWithBlock:(void (^)(NSDictionary*))block {
    NSManagedObjectContext* c = [ManagedObject context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DealSubCategory"
                                              inManagedObjectContext:c];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"preferred == YES"]];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSArray* results = [c executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *paramsArray = [NSMutableArray array];
    for (DealSubCategory* subCat in results) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"c1_type"] = subCat.belongsTo.title;
        param[@"c2_type"] = subCat.title;
        [paramsArray addObject:param];
    }
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:paramsArray
                                                           options:0
                                                             error:&error];
    NSString* paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    NSDictionary *paramsDict = @{@"class":paramsString};
    
    [[NetworkManager sharedInstance] POST:kUserSetClassesEndpoint
                               parameters:paramsDict
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"updated user classes");
        NSLog(@"%@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:4]);
        if (block) {
            block(@{});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to update user classes");
        NSLog(@"%@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:4]);
        if (block) {
            block(@{@"error":error});
        }
    }];
}

@end
