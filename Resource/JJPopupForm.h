//
//  JJPopupForm.h
//  Popuptest
//
//  Created by Jim Joyce on 7/23/15.
//  Copyright (c) 2015 Jim Joyce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SessionManager;
@interface JJPopupForm : UIView

@property(strong, nonatomic)NSString *titleText;
@property(strong, nonatomic)NSString *submitButtonText;
@property(strong, nonatomic)NSString *cancelButtonText;
@property(strong, nonatomic)SessionManager *session;
@property(strong, nonatomic)NSString *journeyId;

-(id)initWithView:(UIView *)view withTitle:(NSString *)title andSubmitTitle:(NSString *)submitTitle andCancelTitle:(NSString *)cancelTitle;

-(void)userTappedSubmitButton;

@end
