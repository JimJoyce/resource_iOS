//
//  RSCategoriesViewController.h
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SessionManager;

@interface RSCategoriesViewController : UITableViewController

@property (strong, nonatomic) NSString * journeyTitle;
@property (strong, nonatomic) NSArray * categories;
@property (strong, nonatomic) SessionManager * session;
@property (strong, nonatomic) NSString * journeyId;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
