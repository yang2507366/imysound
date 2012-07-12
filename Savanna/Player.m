//
//  Player.m
//  imyvoa
//
//  Created by gewara on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import <AVFoundation/AVFoundation.h>

NSString *kPlayerDidStartPlayNotification = @"kPlayerDidStartPlayNotification";
NSString *kPlayerDidPauseNotification = @"kPlayerDidPauseNotification";
NSString *kPlayerDidStopNotification = @"kPlayerDidStopNotification";
NSString *kPlayerDidChangeSoundNotification = @"kPlayerDidChangeSoundNotification";

@interface Player () <AVAudioPlayerDelegate>

@property(nonatomic, retain)AVAudioPlayer *audioPlayer;

@end

@implementation Player

@synthesize audioPlayer = _audioPlayer;
@synthesize currentSoundFilePath = _currentSoundFilePath;

+ (Player *)sharedInstance
{
    static Player *instance = nil;
    @synchronized(instance){
        if(!instance){
            instance = [[Player alloc] init];
        }
    }
    return instance;
}

- (void)dealloc
{
    [_audioPlayer release];
    [_currentSoundFilePath release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (void)playSoundAtFilePath:(NSString *)soundFilePath autoPlay:(BOOL)autoPlay
{
    if(_currentSoundFilePath != soundFilePath){
        [_currentSoundFilePath release];
        _currentSoundFilePath = nil;
    }
    _currentSoundFilePath = [soundFilePath retain];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidChangeSoundNotification object:nil];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:_currentSoundFilePath];
    self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil] autorelease];
    self.audioPlayer.delegate = self;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    if(autoPlay){
        [self play];
    }
}

- (void)playSoundAtFilePath:(NSString *)soundFilePath
{
    [self playSoundAtFilePath:soundFilePath autoPlay:YES];
}

- (void)play
{
    [self.audioPlayer play];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidStartPlayNotification object:nil];
}

- (void)pause
{
    [self.audioPlayer pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidPauseNotification object:nil];
}

- (void)resume
{
    [self.audioPlayer play];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidStartPlayNotification object:nil];
}

- (void)stop
{
    [self.audioPlayer stop];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidPauseNotification object:nil];
}

- (BOOL)playing
{
    return self.audioPlayer.playing;
}

- (NSTimeInterval)duration
{
    return self.audioPlayer.duration;
}

- (NSTimeInterval)currentTime
{
    return self.audioPlayer.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)time
{
    self.audioPlayer.currentTime = time;
}

#pragma mark - AudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerDidStopNotification object:nil];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
}

@end
