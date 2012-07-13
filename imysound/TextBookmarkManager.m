//
//  TextBookmarkManager.m
//  imysound
//
//  Created by gewara on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TextBookmarkManager.h"
#import "KeyValueManagerFactory.h"
#import "CodeUtils.h"

@interface TextBookmarkManager ()

@property(nonatomic, retain)id<KeyValueManager> keyValueMgr;

@end

@implementation TextBookmarkManager

@synthesize keyValueMgr = _keyValueMgr;

- (void)dealloc
{
    [_keyValueMgr release];
    [super dealloc];
}

+ (id<TextBookmarkManager>)createManager
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    self = [super init];
    
    self.keyValueMgr = [KeyValueManagerFactory createLocalDBKeyValueManagerWithName:@"textbookmark"];
    
    return self;
}

- (void)addBookmark:(TextBookmark *)bookmark forIdentifier:(NSString *)identifier
{
    NSMutableArray *newBookmarkList = [NSMutableArray array];
    NSArray *existBookmarkList = [self bookmarkListForIdentifier:identifier];
    if(existBookmarkList){
        [newBookmarkList addObjectsFromArray:existBookmarkList];
    }
    [newBookmarkList addObject:bookmark];
    [self.keyValueMgr setValue:[CodeUtils encodeWithData:[NSKeyedArchiver archivedDataWithRootObject:newBookmarkList]] 
                        forKey:identifier];
}

- (void)setBookmarkList:(NSArray *)bookmarkList forIdentifier:(NSString *)identifier
{
    [self.keyValueMgr setValue:[CodeUtils encodeWithData:[NSKeyedArchiver archivedDataWithRootObject:bookmarkList]] 
                        forKey:identifier];
}

- (NSArray *)bookmarkListForIdentifier:(NSString *)identifier
{
    NSData *objData = [CodeUtils dataDecodedWithString:[self.keyValueMgr valueForKey:identifier]];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:objData];
}

@end
