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

+(SessionManager *)sharedInstance {
    static SessionManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SessionManager alloc]init];
    });
    
    return instance;
}

-(void)setUserConstants:(NSString *)responseUserName andId:(NSString *)responseUserId andToken:(NSString *)responseAuthToken {
    userName = responseUserName;
    userId = responseUserId;
    authToken = responseAuthToken;
//    JOURNEY = 1;
//    CATEGORY = 2;
//    NOTES = 3;
    NSLog(@"token: %@, name: %@, id: %@", authToken, userName, userId);
}

-(void)getDataForUser:(NSString *)atUrl forType:(int)queryType withParams:(NSDictionary *)params waitingOver:(requestFinished)requestLoading {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager GET: atUrl parameters: params success:^(AFHTTPRequestOperation *operation, NSArray *successResponse) {
//        NSLog(@"SUCCESS!  Here's some results: %@", successResponse);
        [self returnDataFromAsyncBlock:successResponse forData:queryType];
        requestLoading(YES);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self returnDataFromAsyncBlock:@[@"error"] forData:queryType];
        NSLog(@"ERROR: %@", error);
        requestLoading(YES);
    }];
}

-(void)returnDataFromAsyncBlock:(NSArray *)array forData:(int)queryType {
//    NSLog(@"from the next method! -- %@", array);
    switch (queryType) {
        case 1:
            self.journeys = array;
            break;
        case 2:
            self.categories = array;
            break;
        case 3:
            self.notes = array;
            break;
        default:
            nil;
            break;
    }
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

-(void)addNewJourney:(NSString *)postUrl withParams:(NSDictionary *)params whileWaiting:(objectCreated)requestDone{
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
    return self.journeys;
}

+(NSArray *)getUserCategories {
    return nil;
}

@end
