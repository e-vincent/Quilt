//
//  BookmarkDataController.h
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIBookmark;
@class NDMutableTrie;
@class BookmarkViewController;

@interface BookmarkDataController : NSObject

@property (nonatomic) NSMutableArray *bookmarksArray;
@property (nonatomic) NSMutableArray *bookmarkDisplayArray;
@property BookmarkViewController *bookmarkVC;
@property NSMutableOrderedSet *mostUsedTags;
@property NDMutableTrie *tagTrie;
@property NSString *sharingTag;

+ (void)setViewController:(BookmarkViewController*)newVC;
+ (BookmarkDataController*)instantiate;
+ (void)deleteInstance;

- (BookmarkDataController*)initWithViewController:(BookmarkViewController*)bookmarkVC;
- (void)registerUpdate:(void (^)(void))updateMethod;
- (NSUInteger)countOfBookmarks;
- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index;


- (void)addBookmark:(UIBookmark *)bookmark;
- (void)deleteBookmark:(UIBookmark *)bookmark;

- (void)updateOnBookmarkInsertion;
- (void)updateOnBookmarkDeletion:(NSIndexPath *)indexPath;

- (void)emptyBookmarkArray;
- (void)emptyTagTrie;

- (void)showTag:(NSString*)tag;
- (void)showAll;

@end
