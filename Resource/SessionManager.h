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
extern int JOURNEY;
extern int CATEGORY;
extern int NOTES;
@property (strong, nonatomic) NSArray *journeys;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *notes;
typedef void(^requestFinished)(BOOL);
typedef void(^objectCreated)(BOOL);
-(void)getDataForUser:(NSString *)atUrl forType:(int)queryType withParams:(NSDictionary *)params waitingOver:(requestFinished)requestLoading;
-(void)addNewNote:(NSString *)postUrl withParams:(NSDictionary *)params whileWaiting:(objectCreated)requestDone;
-(void)addNewJourney:(NSString *)postUrl withParams:(NSDictionary *)params whileWaiting:(objectCreated)requestDone;

+(SessionManager *)sharedInstance;
-(void)setUserConstants:(NSString *)responseUserName andId:(NSString *)responseUserId andToken:(NSString *)responseAuthToken;

+(NSString *)getUserId;
+(NSString *)getUserName;
+(NSString *)getAuthToken;
-(NSArray *)getUserJourneys;
+(NSArray *)getUserCategories;

@end
