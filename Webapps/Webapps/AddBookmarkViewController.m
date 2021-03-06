//
//  AddBookmarkViewController.m
//  Webapps
//
//  Created by Richard on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "AddBookmarkViewController.h"
#import "UIBookmark.h"
#import "BookmarkDataController.h"

@interface AddBookmarkViewController ()

@end

@implementation AddBookmarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.titleInput) || (textField == self.urlInput) || (textField == self.tagsInput))
    {
        [textField resignFirstResponder];
    }
    return YES;
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.urlInput.text = self.url;
    [self.label1 setHidden:YES];
    [self.label2 setHidden:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoButtonClicked:(id)sender
{
    [self.label1 setHidden:!(self.label1.isHidden)];
    [self.label2 setHidden:!(self.label2.isHidden)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        if ([self.titleInput.text length] || [self.urlInput.text length] || [self.tagsInput.text length])
        {
            NSMutableArray *tags = [[NSMutableArray alloc] init];
            NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:@", "];
            [tags addObjectsFromArray:([self.tagsInput.text componentsSeparatedByCharactersInSet:chars])];
            UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:self.titleInput.text URL:self.urlInput.text Tags:tags Width:1 Height:1 ID:-1 Image:nil];
            self.bookmark = bookmark;
        }
    }
}

@end
