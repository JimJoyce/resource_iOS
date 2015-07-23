//
//  JJPopupForm.m
//  Popuptest
//
//  Created by Jim Joyce on 7/23/15.
//  Copyright (c) 2015 Jim Joyce. All rights reserved.
//

#import "JJPopupForm.h"
#import "SessionManager.h"

@interface JJPopupForm () {
    CGRect popupFrame;
    UIButton *submitButton;
    UIButton *cancelButton;
    UILabel *titleLabel;
    UITextField *textField;
    CAKeyframeAnimation *bounceInAnim;
    BOOL isJourney;
}
@end

@implementation JJPopupForm

-(id)initWithView:(UIView *)view withTitle:(NSString *)title andSubmitTitle:(NSString *)submitTitle andCancelTitle:(NSString *)cancelTitle {
    self = [super initWithFrame:view.frame];
    if (self) {
        if ([title isEqualToString:@"Journey"]) {
            isJourney = true;
        }else {
            isJourney = false;
        }
        self.titleText = title;
        self.submitButtonText = submitTitle;
        self.cancelButtonText = cancelTitle;
        self.backgroundColor = [UIColor colorWithRed:80/255.0f
                                               green:80/255.0f
                                                blue:80/255.0f
                                               alpha:1.0f];
        [self.layer setCornerRadius:15.0];
        self.session = [SessionManager sharedInstance];
        [self setFrameSizing:view];
    }
    return self;
}




-(void)setFrameSizing:(UIView *)view {
    popupFrame = CGRectMake(0,0,
                            view.frame.size.width * 0.7,
                            view.frame.size.height * 0.5);
    popupFrame.origin.x = CGRectGetMidX(view.frame) * 0.3;
    popupFrame.origin.y = CGRectGetMidY(view.frame) * 0.4;
    self.frame = popupFrame;
    self.alpha = 0;
    self.transform = CGAffineTransformMakeTranslation(0, -100.0f);
    
    [view addSubview:self];
    [self setClipsToBounds:YES];
    [self addToSuperView:view];
    [self setUpButtons]; [self setUpTextField]; [self setUpTitle];
}

-(void)setUpTitle {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                          self.frame.size.height * 0.4)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = [NSString stringWithFormat:@"New %@", self.titleText];
    titleLabel.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightLight];
    titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:titleLabel];
}

-(void)setUpTextField {
    textField = [[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.075,
                                                             CGRectGetMinY(self.frame) - self.frame.size.height * 0.125,
                                                            self.frame.size.width * 0.85,
                                                            self.frame.size.height * 0.15)];
    [textField setBackgroundColor:[UIColor colorWithRed:50/255.0f
                                                  green:50/255.0f
                                                   blue:50/255.0f
                                                  alpha:1.0]];
    textField.layer.cornerRadius = 10.0f;
    [textField setTextColor:[UIColor whiteColor]];
    textField.font = [UIFont systemFontOfSize:20];
    [textField setTextAlignment:NSTextAlignmentCenter];
    NSAttributedString *placeHolder = [[NSAttributedString alloc]
                                       initWithString:@"Title"
                                       attributes:@{NSFontAttributeName:
                                                        [UIFont systemFontOfSize:15.0f],
                                                    NSForegroundColorAttributeName: [UIColor grayColor]
                                                    }];
    [textField setAttributedPlaceholder:placeHolder];
    [textField setPlaceholder:@"Title"];
    [self addSubview:textField];
    [textField addTarget:self action:@selector(adjustViewForKeyboard:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void)adjustViewForKeyboard:(id)selector {
    [UIView animateWithDuration:0.3 animations:^{
        [self setTransform:CGAffineTransformMakeTranslation(0, (CGRectGetHeight(self.frame) * (-0.33))
                                                            )];
    }];
    
}

-(void)setUpButtons {
    submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                             self.frame.size.height - self.frame.size.height * 0.2,
                                                             self.frame.size.width,
                                                             self.frame.size.height * 0.2)];
    [submitButton setTitle:self.submitButtonText forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:20.0f weight:UIFontWeightLight];
    submitButton.backgroundColor = [UIColor colorWithRed:0/255.0f
                                                   green:219.0/255.0f blue:40.0/255.0f alpha:1];
    submitButton.titleLabel.textColor = [UIColor whiteColor];
    [submitButton addTarget:self action:@selector(removeFromSuperview:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                             self.frame.size.height -
                                                             self.frame.size.height * 0.4,
                                                             self.frame.size.width,
                                                             self.frame.size.height * 0.2)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0f weight:UIFontWeightLight];
    cancelButton.backgroundColor = [UIColor colorWithRed:201/255.0f
                                                   green:0.0/255.0f blue:0.0/255.0f alpha:1];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeFromSuperview:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    [self addSubview:cancelButton];
}

#pragma mark - methods to override
-(void)userTappedSubmitButton {
    NSString *postUrl = @"http://jim-re-source.herokuapp.com/api/journeys";
    NSDictionary *params;
    
    if (isJourney == true) {
        params = @{@"user_id": userId,
                   @"token": authToken,
                   @"journey": @{@"title": textField.text,
                                 @"description": @"none",
                                 @"public_bool": @"0"}};
    } else {
        params = @{@"user_id": userId,
                   @"token": authToken,
                   @"journey_id": self.journeyId,
                   @"category": @{@"title": textField.text,
                                 @"description": @"none",
                                  @"public_bool": @"0"}};
        postUrl = [postUrl stringByAppendingString:[NSString
                                                    stringWithFormat:
                                                    @"/%@/categories", self.journeyId]];
    }
    
    [self.session addNewJourney:postUrl
                     withParams: params
                   whileWaiting:^(BOOL waitingOver) {
        NSLog(@"done");
    }];
}





#pragma mark - Animations

-(void)addToSuperView:(UIView *)view {
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alpha = 1;
    }];
}

-(void)removeFromSuperview:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 100);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([button.titleLabel.text isEqualToString:@"Submit"]) {
            [self userTappedSubmitButton];
            NSLog(@"hit submit!");
        }else {
            NSLog(@"Cancelled it");
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
