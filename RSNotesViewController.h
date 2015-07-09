//
//  RSNotesViewController.h
//  Resource
//
//  Created by Jim Joyce on 7/8/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SessionManager;

@interface RSNotesViewController : UITableViewController
@property (strong, nonatomic)NSArray *notes;
@property(strong, nonatomic)NSString *category;
@property(strong, nonatomic)NSString *urlBase;
@property(strong, nonatomic)NSString *categoryId;
@property(strong, nonatomic)NSString *journeyId;
@property(strong, nonatomic)SessionManager *session;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
