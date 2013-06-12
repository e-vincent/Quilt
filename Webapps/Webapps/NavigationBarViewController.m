//
//  NavigationBarViewController.m
//  Webapps
//
//  Created by Richard Jones on 10/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NavigationBarViewController.h"
#import "NDTrie.h"
#import "BookmarkDataController.h"

@implementation NavigationBarViewController

#define NUMBER_OF_STATIC_CELLS 1
NSArray *tableData;

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarTexture.png"]];
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = (id)self;
    tableData = [[BookmarkDataController instantiate].tagTrie everyObject];
    [[BookmarkDataController instantiate]registerUpdate:^(void)
        {
            tableData = [[BookmarkDataController instantiate].tagTrie everyObject];
            [self.tableView reloadData];
        }];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect newRect = self.tableView.frame;
    newRect.size.width = 268;
    self.tableView.frame = newRect;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        tableData = [[BookmarkDataController instantiate].tagTrie everyObject];
        [self.tableView reloadData];
    }
    else
    {
        NSString *searchItem;
        NDTrie *tagTrie = [BookmarkDataController instantiate].tagTrie;
        
        NSMutableArray *searchItems = [[NSMutableArray alloc] init];
        
        if([tagTrie containsObjectForKeyWithPrefix:text])
        {
            NSEnumerator *itemsEnumerator = [tagTrie objectEnumeratorForKeyWithPrefix:text];

            while (searchItem = [itemsEnumerator nextObject])
            {
                [searchItems addObject:searchItem];
            }
        }
        
        tableData = searchItems;
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count] + NUMBER_OF_STATIC_CELLS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellNum = indexPath.row;
    UITableViewCell *cell;
    
    if (cellNum < NUMBER_OF_STATIC_CELLS)
    {
        NSString *staticCellID;
        
        if (cellNum == 0)
            staticCellID = @"TableName";
        
        cell = [tableView dequeueReusableCellWithIdentifier:staticCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticCellID];
        }
    } else {
        NSString *dynamicCellID = @"TableItem";
        cell = [tableView dequeueReusableCellWithIdentifier:dynamicCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCellID];
        }
    
        cell.textLabel.text = [tableData objectAtIndex:cellNum - NUMBER_OF_STATIC_CELLS];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [[BookmarkDataController instantiate] showTag:selectedCell.textLabel.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end