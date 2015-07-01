//
//  RSJourneyViewController.m
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "RSJourneyViewController.h"
#import "SessionManager.h"
#import "RSCategoriesViewController.h"

@interface RSJourneyViewController () <UINavigationControllerDelegate, UINavigationBarDelegate> {
    BOOL categoriesGrabbed;
}

@end

@implementation RSJourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f
                                                     green: 51.0f/255.0f
                                                     blue: 51.0f/255.0f alpha: 1.0f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    categoriesGrabbed = FALSE;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.journeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.journeys objectAtIndex:indexPath.row] valueForKey: @"title"];
    cell.textLabel.textColor = [UIColor colorWithRed: 90.0f/255.0f green: 204.0f/255.0f blue: 237.0f/255.0f alpha: 1.0f];
    cell.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f green: 51.0f/255.0f blue: 51.0f/255.0f alpha: 1.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f weight: UIFontWeightThin];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)getCategoriesForJourney:(SessionManager *)session forId:(NSInteger)journeyId{
    NSString *idForRoute =  [[self.journeys objectAtIndex: journeyId] valueForKey: @"id"];
    NSLog(@"%@", [self.journeys objectAtIndex: journeyId]);
    NSString *catUrl = [NSString stringWithFormat:
                        @"http://jim-re-source.herokuapp.com/api/journeys/%@/categories",  idForRoute];
    [session getDataForUser: catUrl withParams: @{ @"journey_id" : idForRoute }
        waitingOver:^(BOOL doneLoading) {
        if (doneLoading && session.userJourneys.count > 0 ) {
            categoriesGrabbed = TRUE;
//             [self performSegueWithIdentifier:@"categorySegue" sender: session];
        }
        else {
            categoriesGrabbed = TRUE;
                //deal with errors
            }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categorySegue"] && categoriesGrabbed == TRUE) {
        UINavigationController *navigationController = segue.destinationViewController;
        RSCategoriesViewController *dvc = (RSCategoriesViewController *)navigationController.topViewController;
        dvc.categories = [NSArray arrayWithArray: self.session.userJourneys];
        dvc.journeyTitle = [[self.journeys objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"title"];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        UITableViewCell *cell = sender;
        [self getCategoriesForJourney:self.session forId:indexPath.row];
    }
}


@end
