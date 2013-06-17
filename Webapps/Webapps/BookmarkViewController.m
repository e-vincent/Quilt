//
//  BookmarkViewController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BookmarkDataController.h"
#import "WebViewController.h"
#import "ViewDeckController.h"
#import "NavigationBarViewController.h"
#import "UIBookmark.h"
#import <QuartzCore/QuartzCore.h>
#import "AccountViewController.h"
#import "NetworkClient.h"
#import "RFQuiltLayout.h"
#import "ShareViewController.h"

@interface BookmarkViewController ()

@property UIBookmark *pinchBookmark;
@property NSUInteger initialPinchWidth;
@property NSUInteger initialPinchHeight;
@property RFQuiltLayout *layout;
@property UIBookmark *pinchDisplayBookmark;

@end

@implementation BookmarkViewController

- (IBAction)menuButtonClicked:(id)sender {
    [self.viewDeckController openLeftViewAnimated:YES];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [BookmarkDataController setViewController:self];
    self.pinchGestureRecogniser.delegate = (id)self;
    [self.view addGestureRecognizer:self.pinchGestureRecogniser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"QuiltTexture.png"]];
    self.layout = (id)[self.collectionView collectionViewLayout];
    self.layout.direction = UICollectionViewScrollDirectionVertical;
    self.layout.blockPixels = CGSizeMake(150, 150);
    self.layout.delegate = (id)self;
}

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIBookmark *bookmarkAtIndex = [[BookmarkDataController instantiate] bookmarkInListAtIndex:indexPath.row];
    return CGSizeMake(bookmarkAtIndex.width, bookmarkAtIndex.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[BookmarkDataController instantiate] countOfBookmarks];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"BookmarkCell";
    
    UIBookmark *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    UIBookmark *bookmarkAtIndex = [[BookmarkDataController instantiate] bookmarkInListAtIndex:indexPath.row];
    
    cell.titleLabel.text = bookmarkAtIndex.title;
    
    if(bookmarkAtIndex.image == nil)
        [NetworkClient getBookmarkPicture:bookmarkAtIndex];
    else
        cell.imageView.image = bookmarkAtIndex.image;
    
    cell.dataBookmark = bookmarkAtIndex;
    bookmarkAtIndex.viewBookmark = cell;
    
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:15];
    [cell.imageView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.layer.opaque = YES;
    cell.imageView.backgroundColor = [UIColor whiteColor];
    
    //for loop through tags and append to NSString for text
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIBookmark *bookmark = [[BookmarkDataController instantiate] bookmarkInListAtIndex:indexPath.row];
    NSString *url = bookmark.url;
    [self performSegueWithIdentifier:@"webSegue" sender:url];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.url = sender;
    }
    else if ([segue.identifier isEqualToString:@"myAccountSegue"])
    {
        //AccountViewController *accountViewController = segue.destinationViewController;
        //accountViewController.username.text = @"Test";
    }
    else if ([segue.identifier isEqualToString:@"friendsSegue"])
    {
        
    }
}

- (IBAction)pinchDetected:(id)sender {
    if(!self.pinchBookmark)
    {
        CGPoint point = [self.pinchGestureRecogniser locationInView:self.view];
        NSIndexPath *ip = [self.layout indexPathForPosition:point];
        self.pinchBookmark = [[BookmarkDataController instantiate] bookmarkInListAtIndex:ip.row];
        self.initialPinchWidth = self.pinchBookmark.width;
        self.initialPinchHeight = self.pinchBookmark.height;
    }
    
    self.pinchBookmark.width = self.initialPinchWidth * self.pinchGestureRecogniser.scale;
    self.pinchBookmark.height = self.initialPinchHeight * self.pinchGestureRecogniser.scale;
    
    if(self.pinchBookmark.width < 1)
        self.pinchBookmark.width = 1;
    else if(self.pinchBookmark.width > 4)
        self.pinchBookmark.width = 4;
    
    if(self.pinchBookmark.height < 1)
        self.pinchBookmark.height = 1;
    else if(self.pinchBookmark.height > 4)
        self.pinchBookmark.height = 4;
    
    if(UIGestureRecognizerStateEnded == [self.pinchGestureRecogniser state])
    {
        [self.view setNeedsDisplay];
        NSLog(@"Ended");
    }
    
    NSLog(@"%u, %u", self.pinchBookmark.width, self.pinchBookmark.height);
}

- (IBAction)shareButtonClicked:(id)sender {
    BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
    bookmarkDC.sharingTag = bookmarkDC.bookmarkVC.navigationItem.title;
	[bookmarkDC.bookmarkVC performSegueWithIdentifier:@"shareSegue" sender:self];
}
@end
