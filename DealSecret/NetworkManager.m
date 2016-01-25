//
//  NetworkManager.m
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "NetworkManager.h"
#import "Constants.h"

NSString* const kBaseUrl = @"http://api.fingertipdeals.com/api/v1/";
NSString* const kUserEndpoint = @"users";
NSString* const kUserLoginEndpoint = @"users/login";
NSString* const kUserUpdateEndpoint = @"users/update";
NSString* const kUserLocationEndpoint = @"users/location";
NSString* const kUserDealsByLocationEndpoint = @"users/getdealsbylocation?um_lat=%@&um_lon=%@";
NSString* const kUserCategoriesEndpoint = @"users/getclass?level=%@&class1=%@";
NSString* const kUserClassesEndpoint = @"users/getuserclass";
NSString* const kUserSetClassesEndpoint = @"users/setuserclassarray";
NSString* const kUserDealsWithClassEndpoint = @"users/getdealsbyclass1?c1_type=%@&um_lat=%@&um_lon=%@";
NSString* const kUserDealsZipEndpoint = @"users/getdealsbyzip?um_zip=%@";
NSString* const kUserUpdateLocationEndpoint = @"users/location";

@implementation NetworkManager

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"close" forHTTPHeaderField:@"Connection"];
    
    return self;
}

+ (NetworkManager*)sharedInstance {
    static NetworkManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,  ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    });
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:kUserAPIToken];
    
    if (token != nil)
        [sharedInstance.requestSerializer setValue:token forHTTPHeaderField:@"um_token"];
    
    return sharedInstance;
}

@end
