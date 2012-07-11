//
//  PlayQueueControlNormal.m
//  imysound
//
//  Created by yzx on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayQueueControlNormal.h"
#import "PlayQueue.h"

@implementation PlayQueueControlNormal

- (PlayItem *)nextPlayItemFromQueue:(PlayQueue *)queue
{
    NSInteger nextIndex = [queue currentPlayingIndex];
    if(nextIndex != [queue numberOfPlayItems]){
        return [queue playItemAtIndex:nextIndex];
    }
    return nil;
}

@end
