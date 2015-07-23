//
//  RSCategoriesViewController.m
//  Resource
//
//  Created by Jim Joyce on 6/30/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "RSCategoriesViewController.h"
#import "SessionManager.h"
#import "RSNotesViewController.h"

@interface RSCategoriesViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RSCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDelegate: self];
    [self.tableView setDataSource: self];
    self.tableView.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f
                                                     green: 51.0f/255.0f
                                                      blue: 51.0f/255.0f alpha: 1.0f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navBar.title = self.journeyTitle;
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
    return self.categories.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"categoryCell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.categories objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.textLabel.textColor = [UIColor colorWithRed: 90.0f/255.0f green: 204.0f/255.0f blue: 237.0f/255.0f alpha: 1.0f];
    cell.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f green: 51.0f/255.0f blue: 51.0f/255.0f alpha: 1.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f weight: UIFontWeightThin];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idForRoute =  [[self.categories objectAtIndex: indexPath.row] valueForKey: @"id"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.session getDataForUser: [self getRouteBase: indexPath] forType:3
                      withParams: @{ @"category_id" : idForRoute } waitingOver:^(BOOL doneLoading) {
                          
                         if (doneLoading && self.session.notes.count > 0 ) {
                             [self performSegueWithIdentifier:@"noteSegue" sender: cell];
                         }
                         else if (doneLoading && self.session.notes.count == 0){
//                             [self alertUserThereAreNoCategories:[self.categories
//                                                                  objectAtIndex:indexPath.row]];
                         }
                         else {
//                             [self alertUserOfError];
                         }
                     }];
}

-(NSString *)getRouteBase:(NSIndexPath *)indexPath {
    NSString *route = [NSString stringWithFormat:
                       @"http://jim-re-source.herokuapp.com/api/journeys/%@/categories/%@/notes",
                       self.journeyId,
                       [[self.categories objectAtIndex:indexPath.row] valueForKey:@"id"]];
    return route;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"noteSegue"]) {
        UITableViewCell *cell = sender;
        UINavigationController *navigationController = segue.destinationViewController;
        RSNotesViewController *dvc = (RSNotesViewController *)navigationController.topViewController;
        dvc.notes = [NSArray arrayWithArray: self.session.notes];
        dvc.category = cell.textLabel.text;
        dvc.urlBase = [self getRouteBase:[self.tableView indexPathForSelectedRow]];
        dvc.session = self.session;
        dvc.journeyId = self.journeyId;
        dvc.categoryId = [[self.categories objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"id"];
    }
}


@end
