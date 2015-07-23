//
//  RSNotesViewController.m
//  Resource
//
//  Created by Jim Joyce on 7/8/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "RSNotesViewController.h"
#import "RSAddNoteViewController.h"
#import "SessionManager.h"
#import "RSShowNoteViewController.h"

@interface RSNotesViewController ()

@end

@implementation RSNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f
                                                     green: 51.0f/255.0f
                                                      blue: 51.0f/255.0f alpha: 1.0f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navBar.title = self.category;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                                              UIBarButtonSystemItemAdd target:self
                                                                        action:@selector(addNewNote)];
    
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
    return self.notes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.notes objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.textLabel.textColor = [UIColor colorWithRed: 90.0f/255.0f green: 204.0f/255.0f blue: 237.0f/255.0f alpha: 1.0f];
    cell.backgroundColor = [UIColor colorWithRed: 51.0f/255.0f green: 51.0f/255.0f blue: 51.0f/255.0f alpha: 1.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f weight: UIFontWeightThin];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *selectedNote = [self.notes objectAtIndex:indexPath.row];
    NSLog(@"you selected: %@", selectedNote);
    [self performSegueWithIdentifier:@"showNoteSegue" sender:selectedNote];
}

#pragma helpers

-(void)addNewNote {
    [self performSegueWithIdentifier:@"addNoteSegue" sender:self];
    
}

-(NSString *)getSynopsisText:(NSString *)apiText {
    if ([apiText isKindOfClass:[NSNull class]]) {
        return @"Synopsis not yet added!";
    }
    return apiText;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addNoteSegue"]) {
        RSAddNoteViewController *destinationViewController = (RSAddNoteViewController *)segue.destinationViewController;
        destinationViewController.postUrl = self.urlBase;
        destinationViewController.session = self.session;
        destinationViewController.categoryId = self.categoryId;
        destinationViewController.journeyId = self.journeyId;
    }
    if ([segue.identifier isEqualToString:@"showNoteSegue"]) {
        RSShowNoteViewController *dvc = (RSShowNoteViewController *)segue.destinationViewController;
        NSDictionary *noteObject = sender;
        dvc.noteTitle = [noteObject valueForKey:@"title"];
        dvc.synopsisText = [self getSynopsisText:[noteObject valueForKey:@"synopsis"]];
        dvc.codeText = [noteObject valueForKey:@"code"];
    }
}


@end
