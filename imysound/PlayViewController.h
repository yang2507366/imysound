//
//  PlayViewController.h
//  imysound
//
//  Created by gewara on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class PlayQueue;
@class PlayerStatusView;
@class PlayerControlView;
@class Timer;

@interface PlayViewController : BaseViewController {
    PlayQueue *_playQueue;
    
    PlayerStatusView *_playerStatusView;
    PlayerControlView *_playerControlView;
    
    Timer *_timer;
    Timer *_trackFinishTimer;
}

+ (id)sharedInstance;

- (void)playWithPlayQueue:(PlayQueue *)playQueue;

@end
