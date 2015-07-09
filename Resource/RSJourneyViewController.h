//
//  RSJourneyViewController.h
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SessionManager;

@interface RSJourneyViewController : UITableViewController

@property (strong, nonatomic) NSArray *journeys;
@property (strong, nonatomic) SessionManager *session;

@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
typedef void(^requestFinished)(BOOL);

@end
