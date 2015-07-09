//
//  RSAddNoteViewController.h
//  Resource
//
//  Created by Jim Joyce on 7/9/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SessionManager;

@interface RSAddNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@property(strong, nonatomic)SessionManager *session;
@property(strong, nonatomic)NSString *postUrl;
@property(strong, nonatomic)NSString *categoryId;
@property(strong, nonatomic)NSString *journeyId;


@end
