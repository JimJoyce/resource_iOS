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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@""
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:nil
                                                                           action:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idForRoute =  [[self.journeys objectAtIndex: indexPath.row] valueForKey: @"id"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *catUrl = [NSString stringWithFormat:
                        @"http://jim-re-source.herokuapp.com/api/journeys/%@/categories",  idForRoute];
    [self.session getDataForUser: catUrl forType:2 withParams: @{ @"journey_id" : idForRoute }
                waitingOver:^(BOOL doneLoading) {
                    if (doneLoading && self.session.categories.count > 0 ) {
                        [self performSegueWithIdentifier:@"categorySegue" sender: cell];
                    }
                    else if (doneLoading && self.session.categories.count == 0){
                        [self alertUserThereAreNoCategories:[self.journeys
                                                             objectAtIndex:indexPath.row]];
                    }
                    else {
                        [self alertUserOfError];
                    }
                }];
}

-(void)alertUserThereAreNoCategories:(NSDictionary *)journey{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                   message:@"Looks like there are no Categories for this journey. Do you want to add one?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"No, thanks"
                                                        style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             [self.tableView deselectRowAtIndexPath:
                                                              [self.tableView indexPathForSelectedRow]
                                                                                        animated:YES];
                                                        }];
    [alert addAction:cancelButton];
    [alert addAction:yesButton];
    [self presentViewController:alert
                        animated:YES
                      completion:nil];
}


-(void)alertUserOfError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                   message:@"Looks like there are no Categories for this journey. Do you want to add one?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Okay"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                            [self.tableView deselectRowAtIndexPath:
                                                            [self.tableView indexPathForSelectedRow]
                                                                                          animated:YES];
                                                        }];
    [alert addAction:yesButton];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categorySegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RSCategoriesViewController *dvc = (RSCategoriesViewController *)navigationController.topViewController;
        UITableViewCell *cell = sender;
        dvc.categories = [NSArray arrayWithArray: self.session.categories];
        dvc.journeyTitle = [[self.journeys objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"title"];
        dvc.journeyId = [[self.journeys objectAtIndex:[self.tableView indexPathForCell:cell].row] valueForKey:@"id"];
        dvc.session = self.session;
    }
}


@end
