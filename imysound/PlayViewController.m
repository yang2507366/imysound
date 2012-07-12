//
//  PlayViewController.m
//  imysound
//
//  Created by gewara on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayQueue.h"
#import "PlayerStatusView.h"
#import "PlayerControlView.h"
#import "Player.h"
#import "Timer.h"
#import "PlayItem.h"
#import "PlayQueueControlFactory.h"

@interface PlayViewController () <PlayerStatusViewDelegate, PlayerControlViewDelegate, TimerDelegate>

@property(nonatomic, retain)PlayQueue *playQueue;

@property(nonatomic, retain)PlayerStatusView *playerStatusView;
@property(nonatomic, retain)PlayerControlView *playerControlView;

@property(nonatomic, retain)Timer *timer;
@property(nonatomic, retain)Timer *trackFinishTimer;

- (void)playWithPlayItem:(PlayItem *)playItem;
- (NSTimeInterval)currentTimeWithPlayItem:(PlayItem *)playItem;
- (NSTimeInterval)totalTimeWithPlayItem:(PlayItem *)playItem;
- (void)onPlayQueueOver;

@end

@implementation PlayViewController

@synthesize playQueue = _playQueue;

@synthesize playerStatusView = _playerStatusView;
@synthesize playerControlView = _playerControlView;

@synthesize timer = _timer;
@synthesize trackFinishTimer = _trackFinishTimer;

- (void)dealloc
{
    [_playQueue release];
    
    [_playerStatusView release];
    [_playerControlView release];
    
    [_timer cancel]; [_timer release];
    [_trackFinishTimer cancel]; [_trackFinishTimer release];
    [super dealloc];
}

+ (id)sharedInstance
{
    static PlayViewController *instance = nil;
    @synchronized(instance){
        if(instance == nil){
            instance = [[PlayViewController alloc] init];
        }
    }
    
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.playerStatusView = [[[PlayerStatusView alloc] init] autorelease];
    [self.view addSubview:self.playerStatusView];
    self.playerStatusView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60.0f);
    self.playerStatusView.delegate = self;
    
    self.playerControlView = [[[PlayerControlView alloc] init] autorelease];
    [self.view addSubview:self.playerControlView];
    CGFloat tmpY = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 44.0f;
    self.playerControlView.frame = CGRectMake(0, tmpY, self.view.bounds.size.width, 44.0f);
    self.playerControlView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onPlayerDidStartPlayNotification:) 
                                                 name:kPlayerDidStartPlayNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onPlayerDidPauseNotification:) 
                                                 name:kPlayerDidPauseNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onPlayerDidStopNotification:) 
                                                 name:kPlayerDidStopNotification 
                                               object:nil];
    
    [self playWithPlayItem:[self.playQueue currentPlayItem]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - events
- (void)onPlayerDidStartPlayNotification:(NSNotification *)n
{
    [self.playerControlView setPlaying:YES];
    PlayItem *currentItem = [self.playQueue currentPlayItem];
    if(currentItem){
        self.playerStatusView.currentTime = [self currentTimeWithPlayItem:currentItem];
        self.playerStatusView.totalTime = [self totalTimeWithPlayItem:currentItem];
    }
    
    if(self.timer){
        [self.timer cancel];
        self.timer = nil;
    }
    self.timer = [[[Timer alloc] init] autorelease];
    self.timer.delegate = self;
    [self.timer startWithTimeInterval:0.50f];
    
    if(self.trackFinishTimer){
        [self.trackFinishTimer cancel];
        self.trackFinishTimer = nil;
    }
    self.trackFinishTimer = [[[Timer alloc] init] autorelease];
    self.trackFinishTimer.delegate = self;
    [self.trackFinishTimer startWithTimeInterval:0.01];
}

- (void)onPlayerDidPauseNotification:(NSNotification *)n
{
    [self.playerControlView setPlaying:NO];
    
    [self.timer cancel];
    self.timer = nil;
    [self.trackFinishTimer cancel];
    self.trackFinishTimer = nil;
}

- (void)onPlayerDidStopNotification:(NSNotification *)n
{
    [self.playerControlView setPlaying:NO];
    
    [self.timer cancel];
    self.timer = nil;
    [self.trackFinishTimer cancel];
    self.trackFinishTimer = nil;
    
    self.playerStatusView.currentTime = 0.0f;
    self.playerStatusView.totalTime = 0.0f;
    
    PlayItem *nextItem = [self.playQueue nextPlayItem];
    if(nextItem){
        [self playWithPlayItem:nextItem];
    }
}

#pragma mark - instance methods
- (void)playWithPlayQueue:(PlayQueue *)playQueue
{
    self.playQueue = playQueue;
    self.playQueue.playQueueControl = [PlayQueueControlFactory createNormalPlayQueueControl];
}

#pragma mark - private methods
- (void)playWithPlayItem:(PlayItem *)playItem
{
    Player *player = [Player sharedInstance];
    [player playSoundAtFilePath:playItem.soundFilePath autoPlay:NO];
    player.currentTime = playItem.beginTime;
    [player play];
}

- (NSTimeInterval)currentTimeWithPlayItem:(PlayItem *)playItem
{
    NSTimeInterval position = [Player sharedInstance].currentTime;
    return position - playItem.beginTime;
}

- (NSTimeInterval)totalTimeWithPlayItem:(PlayItem *)playItem
{
    return playItem.endTime - playItem.beginTime;
}

- (void)onPlayQueueOver
{
    [Player sharedInstance].currentTime = 0.0f;
    self.playQueue.finished = YES;
}

#pragma mark - TimerDelegate
- (void)timer:(Timer *)timer timerRunningWithInterval:(CGFloat)interval
{
    PlayItem *currentItem = [self.playQueue currentPlayItem];
    if(timer == self.timer){
        if(currentItem){
            self.playerStatusView.currentTime = [self currentTimeWithPlayItem:currentItem];
            self.playerStatusView.totalTime = [self totalTimeWithPlayItem:currentItem];
        }
    }else if(timer == self.trackFinishTimer){
        if(currentItem){
            NSTimeInterval currentTime = [self currentTimeWithPlayItem:currentItem];
            NSTimeInterval totalTime = [self totalTimeWithPlayItem:currentItem];
            if(currentTime >= totalTime){
                PlayItem *nextItem = [self.playQueue nextPlayItem];
                if(nextItem){
                    [self playWithPlayItem:nextItem];
                }else{
                    [[Player sharedInstance] stop];
                    [self onPlayerDidStopNotification:nil];
                    [self onPlayQueueOver];
                }
            }else{
                NSLog(@"%f->%f", [self currentTimeWithPlayItem:currentItem], [self totalTimeWithPlayItem:currentItem]);
            }
        }
    }
}

#pragma mark - PlayerStatusViewDelegate
- (void)playerStatusView:(PlayerStatusView *)playerStatusView didChangeToNewPosition:(float)value
{
    PlayItem *playItem = [self.playQueue currentPlayItem];
    if(playItem){
        [Player sharedInstance].currentTime = playItem.beginTime + value;
    }
}

#pragma mark - PlayerControlViewDelegate
- (void)playerControlView:(PlayerControlView *)playerControlView didUpdatePlayStatus:(BOOL)playing
{
    if(!self.playQueue.finished){
        Player *player = [Player sharedInstance];
        if(playing){
            [player resume];
        }else{
            [player pause];
        }
    }else{
        [self.playQueue reset];
        [self playWithPlayItem:self.playQueue.currentPlayItem];
    }
}

- (void)playerControlViewDidControlToPrevious:(PlayerControlView *)playerControlView
{
    
}

- (void)playerControlViewDidControlToNext:(PlayerControlView *)playerControlView
{
}

@end
