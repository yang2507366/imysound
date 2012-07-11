//
//  PlayQueue.m
//  imysound
//
//  Created by yzx on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayQueue.h"

@interface PlayQueue ()

@property(nonatomic, retain)NSArray *playItemList;

@property(nonatomic, assign)NSInteger currentIndex;

@end

@implementation PlayQueue

@synthesize playQueueControl = _playQueueControl;

@synthesize playItemList = _playItemList;

@synthesize currentIndex = _currentIndex;

- (void)dealloc
{
    [_playItemList release];
    
    [_playQueueControl release];
    [super dealloc];
}

- (id)initWithPlayItemList:(NSArray *)playItemList
{
    self = [super init];
    
    self.playItemList = playItemList;
    self.currentIndex = 0;
    
    return self;
}

- (NSInteger)currentPlayingIndex
{
    return self.currentIndex;
}

- (NSInteger)numberOfPlayItems
{
    return self.playItemList.count;
}

- (PlayItem *)playItemAtIndex:(NSInteger)index
{
    return [self.playItemList objectAtIndex:index];
}

- (PlayItem *)nextPlayItem
{
    if(self.playQueueControl){
        return [self.playQueueControl nextPlayItemFromQueue:self];
    }
    
    return nil;
}

@end
