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
#import "CommonUtils.h"
#import "SoundSub.h"
#import "SoundSubManager.h"

@interface SoundSubEditViewController () <PlayerStatusViewDelegate, PlayerControlViewDelegate, TimerDelegate, UIAlertViewDelegate>

@property(nonatomic, copy)NSString *soundFilePath;

@property(nonatomic, retain)PlayerStatusView *playerStatusView;
@property(nonatomic, retain)PlayerControlView *playerControlView;

@property(nonatomic, retain)Timer *timer;

@property(nonatomic, assign)NSTimeInterval beginTime;
@property(nonatomic, assign)NSTimeInterval endTime;

@property(nonatomic, retain)UIButton *markBeginTimeBtn;
@property(nonatomic, retain)UIButton *markEndTimeBtn;

- (NSString *)timeFormat:(NSTimeInterval)time;

@end

@implementation SoundSubEditViewController

@synthesize soundFilePath = _soundFilePath;

@synthesize playerStatusView = _playerStatusView;
@synthesize playerControlView = _playerControlView;

@synthesize timer = _timer;

@synthesize beginTime = _beginTime;
@synthesize endTime = _endTime;
@synthesize markBeginTimeBtn = _markBeginTimeBtn;
@synthesize markEndTimeBtn = _markEndTimeBtn;

- (void)dealloc
{
    [_soundFilePath release];
    
    [_playerStatusView release];
    [_playerControlView release];
    
    [_timer cancel]; [_timer release];
    
    [_markBeginTimeBtn release];
    [_markEndTimeBtn release];
    [super dealloc];
}

- (id)initWithSoundFilePath:(NSString *)soundFilePath
{
    self = [super init];
    
    self.title = NSLocalizedString(@"edit_sound_sub", nil);
    
    self.soundFilePath = soundFilePath;
    
    self.beginTime = 0.0f;
    self.endTime = 0.0f;
    
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
    [self.playerControlView hideNextButton:YES];
    [self.playerControlView hidePreviousButton:YES];
    
    self.markBeginTimeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.markBeginTimeBtn];
    self.markBeginTimeBtn.frame = CGRectMake(10, 120, (self.view.bounds.size.width - 30) / 2, 40);
    [self.markBeginTimeBtn setTitle:NSLocalizedString(@"mark_begin_time", nil) forState:UIControlStateNormal];
    [self.markBeginTimeBtn addTarget:self action:@selector(onMarkBeginTimeBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.markEndTimeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.markEndTimeBtn];
    self.markEndTimeBtn.frame = CGRectMake(self.markBeginTimeBtn.frame.origin.x + self.markBeginTimeBtn.frame.size.width + 10, 
                                           self.markBeginTimeBtn.frame.origin.y, 
                                           self.markBeginTimeBtn.frame.size.width, 
                                           self.markBeginTimeBtn.frame.size.height);
    [self.markEndTimeBtn setTitle:NSLocalizedString(@"mark_end_time", nil) forState:UIControlStateNormal];
    [self.markEndTimeBtn addTarget:self action:@selector(onMarkEndTimeBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:saveBtn];
    saveBtn.frame = CGRectMake(60, 220, 200, 40);
    [saveBtn setTitle:NSLocalizedString(@"save_sound_sub", nil) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [[Player sharedInstance] playSoundAtFilePath:self.soundFilePath autoPlay:NO];
    self.playerStatusView.currentTime = [Player sharedInstance].currentTime;
    self.playerStatusView.totalTime = [Player sharedInstance].duration;
}

#pragma mark - private methods
- (NSString *)timeFormat:(NSTimeInterval)time
{
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    NSTimeInterval dot = time - (NSInteger)time;
    NSString *dotString = [NSString stringWithFormat:@"%f", dot];
    dotString = [dotString substringFromIndex:1];
    return [NSString stringWithFormat:@"%@:%@%@", [CommonUtils formatTimeNumber:minute], 
            [CommonUtils formatTimeNumber:second], dotString];
}

#pragma mark - events
- (void)onDoneBtnTapped
{
    [[Player sharedInstance] stop];
    [self dismissModalViewControllerAnimated:YES];
}

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
    self.playerStatusView.currentTime = 0.0f;
    self.playerStatusView.totalTime = 0.0f;
    
    [self.timer cancel];
    self.timer = nil;
}

- (void)onMarkBeginTimeBtnTapped
{
    self.beginTime = [Player sharedInstance].currentTime;
    [self.markBeginTimeBtn setTitle:[self timeFormat:self.beginTime] 
                           forState:UIControlStateNormal];
}

- (void)onMarkEndTimeBtnTapped
{
    self.endTime = [Player sharedInstance].currentTime;
    [self.markEndTimeBtn setTitle:[self timeFormat:self.endTime] 
                         forState:UIControlStateNormal];
}

- (void)onSaveBtnTapped
{
    if(self.beginTime != 0.0f || self.endTime != 0.0f){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"enter_sub_name", nil) 
                                                            message:@"\n" 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                                  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 43, 252, 30)];
        [alertView addSubview:textField];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.tag = 27;
        textField.text = [NSString stringWithFormat:@"%@-%@", [self timeFormat:self.beginTime], [self timeFormat:self.endTime]];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [alertView show];
        [textField becomeFirstResponder];
        [alertView release];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        UITextField *textField = (id)[alertView viewWithTag:27];
        if(textField.text.length != 0){
            [self saveCurrentSoundSubWithTitle:textField.text];
        }else{
            [self onSaveBtnTapped];
        }
    }
}

#pragma mark - TimerDelegate
- (void)timer:(Timer *)timer timerRunningWithInterval:(CGFloat)interval
{
    self.playerStatusView.currentTime = [Player sharedInstance].currentTime;
    self.playerStatusView.totalTime = [Player sharedInstance].duration;
}

#pragma mark - instance methods
- (void)saveCurrentSoundSubWithTitle:(NSString *)title
{
    SoundSub *sub = [[[SoundSub alloc] init] autorelease];
    sub.title = title;
    sub.beginTime = self.beginTime;
    sub.endTime = self.endTime;
    
    NSArray *subList = [[SoundSubManager sharedInstance] subListForIdentifier:self.soundFilePath];
    NSMutableArray *newSubList = nil;
    if(subList){
        newSubList = [NSMutableArray arrayWithArray:subList];
        [newSubList addObject:sub];
    }else{
        newSubList = [NSMutableArray arrayWithObject:sub];
    }
    [[SoundSubManager sharedInstance] setSubListWithArray:newSubList forIdentifier:self.soundFilePath];
    [self alert:NSLocalizedString(@"sound_sub_save_succeed", nil)];
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
            [player play];
        }
    }else{
        [player pause];
    }
}

@end
