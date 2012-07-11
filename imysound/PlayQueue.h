//
//  PlayQueue.h
//  imysound
//
//  Created by yzx on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayQueueControl.h"

@interface PlayQueue : NSObject {
    NSArray *_playItemList;
    
    id<PlayQueueControl> _playQueueControl;
    
    NSInteger _currentIndex;
}

@property(nonatomic, retain)id<PlayQueueControl> playQueueControl;

- (id)initWithPlayItemList:(NSArray *)playItemList;

- (NSInteger)currentPlayingIndex;
- (NSInteger)numberOfPlayItems;
- (PlayItem *)playItemAtIndex:(NSInteger)index;

- (PlayItem *)nextPlayItem;

@end
