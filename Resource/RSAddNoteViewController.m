//
//  RSAddNoteViewController.m
//  Resource
//
//  Created by Jim Joyce on 7/9/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "RSAddNoteViewController.h"
#import "SessionManager.h"

@interface RSAddNoteViewController ()

@end

@implementation RSAddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f
                                                     green: 51.0f/255.0f
                                                      blue: 51.0f/255.0f alpha: 1.0f];
    NSLog(@"%@", self.postUrl);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma buttons

- (IBAction)submitNewNote:(id)sender {
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"category_id" : self.categoryId,
                                 @"auth_token" : authToken,
                                 @"note" : @{@"title": self.titleText.text,
                                             @"synopsis": self.descriptionText.text,
                                             @"code": @"null",
                                             @"public_bool": @0}
                                 };
    [self.session addNewNote:self.postUrl withParams:params whileWaiting:^(BOOL requestResponded) {
        if (requestResponded) {
            NSLog(@"done with request.");
            [weakSelf closeView];
        }
    }];
}


- (IBAction)cancelNote:(id)sender {
    [self closeView];
}

-(void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
