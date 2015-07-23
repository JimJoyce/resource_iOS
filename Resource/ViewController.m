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
    UIView *loadingScreen;
    UIView *darkenBgScreen;
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
    [self setUpLoadingScreen];
    [self sendRequestForUserAuth: requestParams];
    return YES;
}

- (void)sendRequestForUserAuth:(NSDictionary *)jsonData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:loginRoute parameters:jsonData success:^(AFHTTPRequestOperation * operation, id responseObject) {

        NSLog(@"JSON RESPONSE: %@", [[responseObject objectForKey:@"user_id"] class]);
        SessionManager *session = [SessionManager sharedInstance];
        [session setUserConstants:[responseObject objectForKey:@"username"]
                            andId:[responseObject objectForKey:@"user_id"]
                         andToken:[responseObject objectForKey:@"auth_token"]];
        [self getJourneys:session];
    }
    failure:^(AFHTTPRequestOperation * operation, NSError *error)
    {
        //handle failure.
        NSLog(@"FAILED WITH: %@", error);
    }];
}

-(void)getJourneys:(SessionManager *)session{
    [session getDataForUser:@"http://jim-re-source.herokuapp.com/api/journeys"
                    forType:1
                 withParams:@{@"user_id" : userId}
                waitingOver:^(BOOL doneLoading) {
        if (doneLoading) {
            [self animateLoadingScreenOff:session];
        }else {
            //deal with errors
        }
    }];
}

#pragma mark - loading screens

-(void)setUpLoadingScreen {
    CGRect loadingFrame = CGRectMake(CGRectGetMidX(self.view.frame) * 0.70f,
                                     CGRectGetMidY(self.view.frame) * 0.70f,
                                     self.view.frame.size.width * 0.3f,
                                     self.view.frame.size.width * 0.3f);
    loadingScreen = [[UIView alloc]initWithFrame:loadingFrame];
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) * 0.175f,
                                                                     CGRectGetMidY(self.view.frame) * 0.1,50,50)];
    loadingLabel.text = @"Loading...";
    loadingLabel.font = [UIFont systemFontOfSize:10.0f weight:0.1f];
    loadingLabel.textColor = [UIColor whiteColor];
    
    darkenBgScreen = [[UIView alloc]initWithFrame:self.view.frame];
    darkenBgScreen.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.6f];
    loadingScreen.layer.cornerRadius = 10.0f;
    loadingScreen.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.8f];
    [loadingScreen setTransform:CGAffineTransformMakeScale(0.0f, 0.0f)];
    [self.view addSubview:darkenBgScreen];
    [darkenBgScreen addSubview:loadingScreen];
    [loadingScreen addSubview:loadingLabel];
    [self animateLoadingScreenOn];
}

-(void)animateLoadingScreenOn {
    [UIView animateWithDuration:0.2 animations:^{
        [loadingScreen setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    }];
}

-(void)animateLoadingScreenOff:(SessionManager *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        [loadingScreen setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
        [darkenBgScreen setAlpha:0];
    } completion:^(BOOL finished) {
        [darkenBgScreen removeFromSuperview];
        [self performSegueWithIdentifier:@"loginSegue" sender: sender];
    }];
}


#pragma mark - storyboard stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SessionManager *)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RSJourneyViewController *dvc = (RSJourneyViewController *)navigationController.topViewController;
        dvc.journeys = [NSArray arrayWithArray: sender.journeys];
        dvc.session = sender;
//        NSLog(@"array at the bottom %@", [dvc.journeys class]);
    }
}




@end
