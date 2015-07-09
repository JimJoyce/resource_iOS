//
//  SessionManager.h
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject
extern NSString *userId;
extern NSString *userName;
extern NSString *authToken;
@property (strong, nonatomic) NSArray *userJourneys;
typedef void(^requestFinished)(BOOL);
typedef void(^objectCreated)(BOOL);
-(void)getDataForUser:(NSString *)atUrl withParams:(NSDictionary *)params waitingOver:(requestFinished)requestLoading;
-(void)addNewNote:(NSString *)postUrl withParams:(NSDictionary *)params whileWaiting:(objectCreated)requestDone;

+(NSString *)getUserId;
+(NSString *)getUserName;
+(NSString *)getAuthToken;
-(NSArray *)getUserJourneys;
+(NSArray *)getUserCategories;

-(id) initWithUserDetails:(NSString *)userName andId:(NSString *)userId andToken:(NSString *)userToken;
@end
