//
//  SoundSubEditViewController.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubEditViewController.h"
#import "PlayerStatusView.h"
#import "PlayerControlView.h"
#import "Player.h"
#import "Timer.h"

@interface SoundSubEditViewController () <PlayerStatusViewDelegate, PlayerControlViewDelegate, TimerDelegate>

@property(nonatomic, copy)NSString *soundFilePath;

@property(nonatomic, retain)PlayerStatusView *playerStatusView;
@property(nonatomic, retain)PlayerControlView *playerControlView;

@property(nonatomic, retain)Timer *timer;

@end

@implementation SoundSubEditViewController

@synthesize soundFilePath = _soundFilePath;

@synthesize playerStatusView = _playerStatusView;
@synthesize playerControlView = _playerControlView;

@synthesize timer = _timer;

- (void)dealloc
{
    [_soundFilePath release];
    
    [_playerStatusView release];
    [_playerControlView release];
    
    [_timer cancel]; [_timer release];
    [super dealloc];
}

- (id)initWithSoundFilePath:(NSString *)soundFilePath
{
    self = [super init];
    
    self.title = NSLocalizedString(@"edit_sound_sub", nil);
    
    self.soundFilePath = soundFilePath;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                             target:self 
                                                                             action:@selector(onDoneBtnTapped)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    [doneBtn release];
    
    self.playerStatusView = [[[PlayerStatusView alloc] init] autorelease];
    [self.view addSubview:self.playerStatusView];
    self.playerStatusView.delegate = self;
    self.playerStatusView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    self.playerControlView = [[[PlayerControlView alloc] init] autorelease];
    [self.view addSubview:self.playerControlView];
    self.playerControlView.delegate = self;
    self.playerControlView.frame = CGRectMake(0, 
                                              self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 44, 
                                              self.view.frame.size.width, 
                                              44);
    
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
    
}

#pragma mark - events
- (void)onPlayerDidStartPlayNotification:(NSNotification *)n
{
    [self.playerControlView setPlaying:YES];
    self.playerStatusView.totalTime = [Player sharedInstance].duration;
    
    if(self.timer){
        [self.timer cancel];
        self.timer = nil;
    }
    self.timer = [[[Timer alloc] init] autorelease];
    self.timer.delegate = self;
    [self.timer startWithTimeInterval:0.50f];
}

- (void)onPlayerDidPauseNotification:(NSNotification *)n
{
    [self.playerControlView setPlaying:NO];
    
    [self.timer cancel];
    self.timer = nil;
}

- (void)onPlayerDidStopNotification:(NSNotification *)n
{
    [self.playerControlView setPlaying:NO];
    self.playerStatusView.totalTime = 0.0f;
    
    [self.timer cancel];
    self.timer = nil;
}

#pragma mark - TimerDelegate
- (void)timer:(Timer *)timer timerRunningWithInterval:(CGFloat)interval
{
    self.playerStatusView.currentTime = [Player sharedInstance].currentTime;
    self.playerStatusView.totalTime = [Player sharedInstance].duration;
}

#pragma mark - instance methods
- (void)onDoneBtnTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - PlayerStatusViewDelegate
- (void)playerStatusView:(PlayerStatusView *)playerStatusView didChangeToNewPosition:(float)value
{
    [Player sharedInstance].currentTime = value;
}

#pragma mark - PlayerControlViewDelegate
- (void)playerControlView:(PlayerControlView *)playerControlView didUpdatePlayStatus:(BOOL)playing
{
    Player *player = [Player sharedInstance];
    if(playing){
        if([player.currentSoundFilePath isEqualToString:self.soundFilePath] && !player.playing){
            [player resume];
        }else{
            [player playSoundAtFilePath:self.soundFilePath];
        }
    }else{
        [player pause];
    }
}

@end
