//
//  ViewController.m
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SessionManager.h"
#import "RSJourneyViewController.h"

static NSString * const loginRoute = @"http://jim-re-source.herokuapp.com/api/snippets/login";

@interface ViewController () {
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    NSDictionary *requestParams;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    requestParams = [NSDictionary dictionaryWithObjects:@[emailField.text, passwordField.text] forKeys: @[@"email", @"password"]];
    [self sendRequestForUserAuth: requestParams];
    return YES;
}

- (void)sendRequestForUserAuth:(NSDictionary *)jsonData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:loginRoute parameters:jsonData success:^(AFHTTPRequestOperation * operation, id responseObject) {

        NSLog(@"JSON RESPONSE: %@", [[responseObject objectForKey:@"user_id"] class]);
        
        SessionManager *session = [[SessionManager alloc]initWithUserDetails:
                                   
                                                                                        [responseObject objectForKey:@"username"]
                                   
                                                                           andId:     [responseObject objectForKey: @"user_id"]
                                   
                                                                        andToken:  [responseObject objectForKey:@"auth_token"]];
        [self getJourneys:session];
    }
    failure:^(AFHTTPRequestOperation * operation, NSError *error)
    {
        //handle failure.
        NSLog(@"FAILED WITH: %@", error);
    }];
}

-(void)getJourneys:(SessionManager *)session{
    [session getDataForUser:@"http://jim-re-source.herokuapp.com/api/journeys" withParams:@{@"user_id" : userId}  waitingOver:^(BOOL doneLoading) {
        
        if (doneLoading) {
            [self performSegueWithIdentifier:@"loginSegue" sender: session];
//            if ([session.userJourneys[0] isKindOfClass: [NSDictionary class]]) {
//                
//            }
//            else {
//                //deal with errors
//            }
        }
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SessionManager *)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RSJourneyViewController *dvc = (RSJourneyViewController *)navigationController.topViewController;
        dvc.journeys = [NSArray arrayWithArray: sender.userJourneys];
        dvc.session = sender;
//        NSLog(@"array at the bottom %@", [dvc.journeys class]);
    }
}




@end
