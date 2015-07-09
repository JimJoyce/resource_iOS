//
//  RSShowNoteViewController.m
//  Resource
//
//  Created by Jim Joyce on 7/9/15.
//  Copyright (c) 2015 JimJoyce. All rights reserved.
//

#import "RSShowNoteViewController.h"

@interface RSShowNoteViewController () {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *synopsisLabel;
    __weak IBOutlet UITextView *codeArea;
}

@end

@implementation RSShowNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleLabel.text = self.noteTitle;
    synopsisLabel.text = self.synopsisText;
    codeArea.text = self.codeText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeNote:(id)sender {
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
