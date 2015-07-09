//
//  SessionManager.m
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "SessionManager.h"
#import "AFNetworking.h"

NSString *userId;
NSString *userName;
NSString *authToken;
typedef void(^requestFinished)(BOOL);

static NSString * const journeyRoute = @"http://jim-re-source.herokuapp.com/api/snippets/login";

@implementation SessionManager

-(id) initWithUserDetails:(NSString *)responseUserName andId:(NSString *)responseUserId andToken:(NSString *)responseAuthToken {
    self = [super init];
    if (self) {
        userName = responseUserName;
        userId = responseUserId;
        authToken = responseAuthToken;
        NSLog(@"token: %@, name: %@, id: %@", authToken, userName, userId);
    }
    return self;
}



-(void)getDataForUser:(NSString *)atUrl withParams:(NSDictionary *)params waitingOver:(requestFinished)requestLoading {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager GET: atUrl parameters: params success:^(AFHTTPRequestOperation *operation, NSArray *successResponse) {
//        NSLog(@"SUCCESS!  Here's some results: %@", successResponse);
        [self returnDataFromAsyncBlock:successResponse];
        requestLoading(YES);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self returnDataFromAsyncBlock:@[@"error"]];
        NSLog(@"ERROR: %@", error);
        requestLoading(YES);
    }];
}

-(void)returnDataFromAsyncBlock:(NSArray *)array {
//    NSLog(@"from the next method! -- %@", array);
    self.userJourneys = array;
}

-(void)addNewNote:(NSString *)postUrl withParams:(NSDictionary *)params whileWaiting:(objectCreated)requestDone{
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    
    [requestManager POST:postUrl parameters:params success:^(AFHTTPRequestOperation *operation,
                                                             NSDictionary *response) {
        //deal with success
        NSLog(@"success!");
        requestDone(YES);
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        //deal with error
        NSLog(@"failed: %@", [operation responseString]);
        requestDone(YES);
    }];
    
}



+(NSString *)getUserName {
    return userName;
}

+(NSString *)getUserId {
    return userId;
}

+(NSString *)getAuthToken {
    return authToken;
}

-(NSArray *)getUserJourneys {
    return self.userJourneys;
}

+(NSArray *)getUserCategories {
    return nil;
}

@end
